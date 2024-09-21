#!/usr/bin/env bash
set -eo pipefail

# User variables
target_hostname=""
target_user="osmo"
# Create a temp directory for generated host keys
temp=$(mktemp -d)

# Cleanup tatemporary directory on exit
function cleanup() {
	rm -rf "$temp"
}
trap cleanup exit

function red() {
	echo -e "\x1B[31m[!] $1 \x1B[0m"
	if [ -n "${2-}" ]; then
		echo -e "\x1B[31m[!] $($2) \x1B[0m"
	fi
}
function green() {
	echo -e "\x1B[32m[+] $1 \x1B[0m"
	if [ -n "${2-}" ]; then
		echo -e "\x1B[32m[+] $($2) \x1B[0m"
	fi
}
function yellow() {
	echo -e "\x1B[33m[*] $1 \x1B[0m"
	if [ -n "${2-}" ]; then
		echo -e "\x1B[33m[*] $($2) \x1B[0m"
	fi
}

function yes_or_no() {
	echo -en "\x1B[32m[+] $* [y/n] (default: y): \x1B[0m"
	while true; do
		read -rp "" yn
		yn=${yn:-y}
		case $yn in
		[Yy]*) return 0 ;;
		[Nn]*) return 1 ;;
		esac
	done
}

function sync() {
	# $1 = user, $2 = source, $3 = destination
	rsync -av --filter=':- .gitignore' -e "ssh -l $1 -oport=${ssh_port}" $2 $1@${target_destination}:
}

function help_and_exit() {
	echo
	echo "Remotely installs NixOS on a target machine using this .files."
	echo
	echo "USAGE: $0 -n <target_hostname> -d <target_destination> -k <ssh_key> [OPTIONS]"
	echo
	echo "ARGS:"
	echo "  -n <target_hostname>      specify target_hostname of the target host to deploy the nixos config on."
	echo "                            target during install process."
	echo "                            Example: -k /home/${target_user}/.ssh/my_ssh_key"
	echo
	echo "OPTIONS:"
	echo "  -u <target_user>          specify target_user with sudo access. .files will be cloned to their home."
	echo "                            Default='${target_user}'."
	echo "  --port <ssh_port>         specify the ssh port to use for remote access. Default=${ssh_port}."
	echo "  --impermanence            Use this flag if the target machine has impermanence enabled. WARNING: Assumes /persist path."
	echo "  --debug                   Enable debug mode."
	echo "  -h | --help               Print this help."
	exit 0
}

# Handle command-line arguments
while [[ $# -gt 0 ]]; do
	case "$1" in
	-n)
		shift
		target_hostname=$1
		;;
	-u)
		shift
		target_user=$1
		;;
	--temp-override)
		shift
		temp=$1
		;;
	--debug)
		set -x
		;;
	-h | --help) help_and_exit ;;
	*)
		echo "Invalid option detected."
		help_and_exit
		;;
	esac
	shift
done

git_root=$(git rev-parse --show-toplevel)

# args: $1 = key name, $2 = key type, $3 key
function update_sops_file() {
	key_name=$1
	key_type=$2
	key=$3

	if [ ! "$key_type" == "hosts" ] && [ ! "$key_type" == "users" ]; then
		red "Invalid key type passed to update_sops_file. Must be either 'hosts' or 'users'."
		exit 1
	fi
	cd "${git_root}"/../.secrets

	SOPS_FILE=".sops.yaml"
	sed -i "{
	# Remove any * and & entries for this host
	/[*&]$key_name/ d;
	# Inject a new age: entry
	# n matches the first line following age: and p prints it, then we transform it while reusing the spacing
	/age:/{n; p; s/\(.*- \*\).*/\1$key_name/};
	# Inject a new hosts or user: entry
	/&$key_type:/{n; p; s/\(.*- &\).*/\1$key_name $key/}
	}" $SOPS_FILE
	green "Updating .secrets/.sops.yaml"
	cd -
}

function generate_host_age_key() {
	green "Generating an age key based on the new ssh_host_ed25519_key."

	target_key=$(
		cat /etc/ssh/ssh_host_ed25519_key.pub |
			cut -f2- -d" " ||
			(
				red "Failed to get ssh key. Host down?"
				exit 1
			)
	)
	host_age_key=$(nix shell nixpkgs#ssh-to-age.out -c sh -c "echo $target_key | ssh-to-age")

	if grep -qv '^age1' <<<"$host_age_key"; then
		red "The result from generated age key does not match the expected format."
		yellow "Result: $host_age_key"
		yellow "Expected format: age10000000000000000000000000000000000000000000000000000000000"
		exit 1
	else
		echo "$host_age_key"
	fi

	green "Updating .secrets/.sops.yaml"
	update_sops_file "$target_hostname" "hosts" "$host_age_key"
}

# Validate required options
# FIXME: The ssh key and destination aren't required if only rekeying, so could be moved into specific sections?
if [ -z "${target_hostname}" ]; then
	red "ERROR: -n required"
	echo
	help_and_exit
fi

if yes_or_no "Generate host (ssh-based) age key?"; then
	generate_host_age_key
	updated_age_keys=1
fi

if [[ $updated_age_keys == 1 ]]; then
	# Since we may update the sops.yaml file twice above, only rekey once at the end
	just rekey
	green "Updating flake input to pick up new .sops.yaml"
	nix flake lock --update-input secrets
fi

if yes_or_no "Add ssh host fingerprints for github and codeberg? If this is the first time running this script on $target_hostname, this will be required for the following steps?"; then
	if [ "$target_user" == "root" ]; then
		home_path="/root"
	else
		home_path="/home/$target_user"
	fi
	green "Adding ssh host fingerprints for github and codeberg"
	$ssh_cmd "mkdir -p $home_path/.ssh/; ssh-keyscan -t ssh-ed25519 codeberg.org github.com >>$home_path/.ssh/known_hosts"
fi


if yes_or_no "You can now commit and push the .files, which includes the hardware-configuration.nix for $target_hostname?"; then
	(pre-commit run --all-files 2>/dev/null || true) &&
		git add "$git_root/hosts/$target_hostname/hardware-configuration.nix" && (git commit -m "feat: hardware-configuration.nix for $target_hostname" || true) && git push
fi

#TODO prune all previous generations?

echo
green "NixOS was successfully rebuilt!"
echo "Post-install config build instructions:"
echo "To copy .files from this machine to the $target_hostname, run the following command from ~/.files"
echo "just sync $target_user $target_destination"
echo "To rebuild, sign into $target_hostname and run the following command from ~/.files"
echo "cd .files"
echo "nh os switch"
echo
green "Success!"
green "If you are using a disko config with luks partitions, update luks to use non-temporary credentials."
