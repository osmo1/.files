#!/usr/bin/env bash
set -eo pipefail
# TODO: Rebase on EmergentMinds new one

# User variables
target_hostname=""
target_destination=""
target_user="osmo"
ssh_key=""
ssh_port="22"
persist_dir=""
tpm=""
nbde=""
yubi=""
# Create a temp directory for generated host keys
temp=$(mktemp -d)

# Cleanup temporary directory on exit
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
	echo "  -d <target_destination>   specify ip or url to the target host."
	echo "  -k <ssh_key>              specify the full path to the ssh_key you'll use for remote access to the"
	echo "                            target during install process."
	echo "                            Example: -k /home/${target_user}/.ssh/my_ssh_key"
	echo
	echo "OPTIONS:"
	echo "  -u <target_user>          specify target_user with sudo access. .files will be cloned to their home."
	echo "                            Default='${target_user}'."
	echo "  --port <ssh_port>         specify the ssh port to use for remote access. Default=${ssh_port}."
	echo "  --impermanence            Use this flag if the target machine has impermanence enabled. WARNING: Assumes /persist path."
	echo "  --tpm                     Use this flag if the target machine has a tpm module and you want to use it."
	echo "  --nbde                    Use this flag if the target machine needs encryption over the network."
	echo "  --yubi                    Use this flag if the target machine needs encryption provided by yubikey."
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
	-d)
		shift
		target_destination=$1
		;;
	-u)
		shift
		target_user=$1
		;;
	-k)
		shift
		ssh_key=$1
		;;
	--port)
		shift
		ssh_port=$1
		;;
	--temp-override)
		shift
		temp=$1
		;;
	--impermanence)
		persist_dir="/persist"
		;;	
	--tpm)
		tpm=$1
		;;	
    --nbde)
		nbde=$1
		;;
    --yubi)
		yubi=$1
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
# SSH commands
ssh_cmd="ssh -oport=${ssh_port} -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i $ssh_key -t $target_user@$target_destination"
ssh_root_cmd=$(echo "$ssh_cmd" | sed "s|${target_user}@|root@|") # uses @ in the sed switch to avoid it triggering on the $ssh_key value
scp_cmd="scp -oport=${ssh_port} -o StrictHostKeyChecking=no -i $ssh_key"

git_root=$(git rev-parse --show-toplevel)

function nixos_anywhere() {
	# Clear the keys, since they should be newly generated for the iso
	green "Wiping known_hosts of $target_destination"
	sed -i "/$target_hostname/d; /$target_destination/d" ~/.ssh/known_hosts
	sudo sed -i "/$target_hostname/d; /$target_destination/d" /root/.ssh/known_hosts || true

	green "Installing NixOS on remote host $target_hostname at $target_destination"

	###
	# nixos-anywhere extra-files generation
	###
	green "Preparing a new ssh_host_ed25519_key pair for $target_hostname."
	# Create the directory where sshd expects to find the host keys
	install -d -m755 "$temp/etc/ssh"

	# Generate host ssh key pair without a passphrase
	ssh-keygen -t ed25519 -f "$temp/etc/ssh/ssh_host_ed25519_key" -C root@"$target_hostname" -N ""
	mkdir -p "$temp/home/osmo/.files/.secrets"
    cp /home/osmo/.files/.secrets/jwt.jwt $temp/home/osmo/.files/.secrets
	$ssh_root_cmd "mkdir -p /home/osmo/.files/.secrets"
	$scp_cmd $temp/home/osmo/.files/.secrets/jwt.jwt root@"$target_destination":/home/osmo/.files/.secrets/jwt.jwt
	 
	# Set the correct permissions so sshd will accept the key
	chmod 600 "$temp/etc/ssh/ssh_host_ed25519_key"

	echo "Adding ssh host fingerprint at $target_destination to ~/.ssh/known_hosts"
	# This will fail if we already know the host, but that's fine
	ssh-keyscan -p "$ssh_port" "$target_destination" >>~/.ssh/known_hosts || true

	###
	# nixos-anywhere installation
	###
	cd nixos-installer

	# when using luks, disko expects a passphrase on /tmp/disko-password, so we set it for now and will update the passphrase later
	# via the config
	# green "Preparing a temporary password for disko."
	
 	secret_file="${git_root}"/../.secrets/secrets.yaml
	#if [ -n "$tpm" ]; then
	#	#luks_passphrase=$(sops -d --extract '["nixos"]["klusteri-key"]' "$secret_file")
	#	luks_passphrase=$(dd if=/dev/random bs=64 count=1 2>/dev/null | od -An -tx1 | tr -d ' \n')
	#	$ssh_root_cmd "/bin/sh -c 'echo \"$luks_passphrase\" > /tmp/disko-password'"
	#	$ssh_root_cmd "/bin/sh -c 'tpm2-initramfs-tool seal --data \$(cat /tmp/disko-password) --pcrs 0,2'"
	#else
		luks_passphrase=osmo
		#luks_passphrase=$(sops -d --extract '["luks"]["secure"]' "$secret_file")
        $ssh_root_cmd "/bin/sh -c 'echo \"$luks_passphrase\" > /tmp/disko-password'"
	#fi

	green "Generating hardware-config.nix for $target_hostname and adding it to the nix-config."
	$ssh_root_cmd "nixos-generate-config --no-filesystems --root /mnt"
	$scp_cmd root@"$target_destination":/mnt/etc/nixos/hardware-configuration.nix "${git_root}"/hosts/"$target_hostname"/hardware-configuration.nix

	# --extra-files here picks up the ssh host key we generated earlier and puts it onto the target machine
	SHELL=/bin/sh nix run github:nix-community/nixos-anywhere -- --phases install --ssh-port "$ssh_port" --extra-files "$temp" --flake .#"$target_hostname" root@"$target_destination"

    after_install
}

function after_install() {
	if [ -n "$tpm" ]; then
        $ssh_root_cmd "/bin/sh -c 'device_name=\$(lsblk -no PKNAME,NAME | awk '\''\$2 == \"└─crypted\" {print \$1}'\''); systemd-cryptenroll --wipe-slot=tpm2 --tpm2-device=/dev/tpm0 --tpm2-pcrs=0+2 /dev/\$device_name'"
        $ssh_root_cmd "/bin/sh -c 'device_name=\$(lsblk -no PKNAME,NAME | awk '\''\$2 == \"└─crypted\" {print \$1}'\''); systemd-cryptenroll --recovery-key /dev/\$device_name'"
        if [[ "$(hostname)" == "klusteri-2" ]]; then
            $ssh_root_cmd "/bin/sh -c 'device_name=\$(lsblk -no PKNAME,NAME | grep crypted-extra | awk '\''{print \$1}'\''); systemd-cryptenroll --wipe-slot=tpm2 --tpm2-device=/dev/tpm0 --tpm2-pcrs=0+2 /dev/\$device_name'"
            $ssh_root_cmd "/bin/sh -c 'device_name=\$(lsblk -no PKNAME,NAME | grep crypted-extra | awk '\''{print \$1}'\''); systemd-cryptenroll --recovery-key /dev/\$device_name'"
        fi
	    # Tpm is not working on nixos 24.05 rn for somereason, will try again in 24.11
	    #$ssh_root_cmd "/bin/sh -c 'device_name=\$(lsblk -no PKNAME,NAME | grep crypted | awk '\''{print \$1}'\''); cryptsetup luksKillSlot /dev/\$device_name 0'"
	fi
	if [ -n "$nbde" ]; then
        $ssh_root_cmd "clevis luks bind -d /dev/nvme0n1p4 tang '{\"url\":\"192.168.11.2:8888\"}'"
        $ssh_root_cmd "clevis luks bind -d /dev/sda1 tang '{\"url\":\"192.168.11.2:8888\"}'"
        $ssh_root_cmd "clevis luks bind -d /dev/sdb1 tang '{\"url\":\"192.168.11.2:8888\"}'"
	fi
if [ -n "$yubi" ]; then
        $ssh_root_cmd "/bin/sh -c 'device_name=\$(lsblk -no PKNAME,NAME | awk '\''\$2 == \"└─crypted\" {print \$1}'\''); systemd-cryptenroll /dev/\$device_name --fido2-device=auto  --fido2-with-client-pin=yes'"
        $ssh_root_cmd "/bin/sh -c 'device_name=\$(lsblk -no PKNAME,NAME | awk '\''\$2 == \"└─crypted\" {print \$1}'\''); systemd-cryptenroll --recovery-key /dev/\$device_name'"
fi


	
	echo "Rebooting now"
	$ssh_root_cmd "sudo reboot now"

	sleep 3
	# Ping the target every 2 seconds until it becomes reachable, then sleep 5 seconds
	until ping -c 1 -W 1 "$target_destination" >/dev/null 2>&1; do
	    echo "Waiting for $target_destination to become reachable..."
	    sleep 2
	done

	echo "$target_destination is reachable, waiting an additional 5 seconds..."
	sleep 5s
	echo "Updating ssh host fingerprint at $target_destination to ~/.ssh/known_hosts"
	ssh-keyscan -p "$ssh_port" "$target_destination" >>~/.ssh/known_hosts || true

	if [ -n "$persist_dir" ]; then
		$ssh_root_cmd "mkdir -p $persist_dir/etc/ssh/ || true"
		$ssh_root_cmd "cp /etc/machine-id $persist_dir/etc/machine-id || true"
		$ssh_root_cmd "cp -R /etc/ssh/ $persist_dir/etc/ || true"
	fi

	cd -
}

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
		ssh-keyscan -p "$ssh_port" -t ssh-ed25519 "$target_destination" 2>&1 |
			grep ssh-ed25519 |
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

	# Extract the private key using sops and save it to a temporary file
	#sops -d --extract '["nixos"]["$target_hostname"]["git"]["private"]' ~/.secrets/secrets.yaml > /tmp/git_key
	eval "sops -d --extract '[\"nixos\"][\"$target_hostname\"][\"git\"][\"private\"]' ~/.secrets/secrets.yaml > /tmp/git_key"

	# Set appropriate permissions for the private key file
	chmod 600 /tmp/git_key

	$ssh_cmd "/bin/sh -c 'mkdir /home/$target_user/.ssh || true' "
	# Copy the private key file to the target machine
	$scp_cmd /tmp/git_key $target_user@$target_destination:/home/$target_user/.ssh/git

	# Clean up the temporary file
	rm -f /tmp/git_key
	$ssh_cmd "ssh-add ~/.ssh/git && mkdir -p ~/.config/sops/age"
	$scp_cmd /home/$target_user/.config/sops/age/git-agecrypt.txt $target_user@$target_destination:/home/$target_user/.config/sops/age/git-agecrypt.txt
}

#function generate_user_age_key() {
#	echo "First checking if ${target_hostname} age key already exists"
#	secret_file="${git_root}"/../.secrets/secrets.yaml
#	if ! sops -d --extract '["user_age_keys"]' "$secret_file" >/dev/null ||
#		! sops -d --extract "[\"user_age_keys\"][\"${target_hostname}\"]" "$secret_file" >/dev/null 2>&1; then
#		echo "Age key does not exist. Generating."
#		user_age_key=$(nix shell nixpkgs#age -c "age-keygen")
#		readarray -t entries <<<"$user_age_key"
#		secret_key=${entries[2]}
#		public_key=$(echo "${entries[1]}" | rg key: | cut -f2 -d: | xargs)
#		key_name="${target_user}_${target_hostname}"
#		# shellcheck disable=SC2116,SC2086
#		sops --set "$(echo '["user_age_keys"]["'${key_name}'"] "'$secret_key'"')" "$secret_file"
#		update_sops_file "$key_name" "users" "$public_key"
#	else
#		echo "Age key already exists for ${target_hostname}"
#	fi
#}

# Validate required options
# FIXME: The ssh key and destination aren't required if only rekeying, so could be moved into specific sections?
if [ -z "${target_hostname}" ] || [ -z "${target_destination}" ] || [ -z "${ssh_key}" ]; then
	red "ERROR: -n, -d, and -k are all required"
	echo
	help_and_exit
fi

if yes_or_no "Run nixos-anywhere installation?"; then
	nixos_anywhere
else
    if yes_or_no "Run after install only?"; then
        after_install
    fi
fi

if yes_or_no "Generate host (ssh-based) age key?"; then
	generate_host_age_key
	updated_age_keys=1
fi

#if yes_or_no "Generate user age key?"; then
#	#generate_user_age_key
#	updated_age_keys=1
#fi

if [[ $updated_age_keys == 1 ]]; then
	# Since we may update the sops.yaml file twice above, only rekey once at the end
	just rekey
	green "Updating flake input to pick up new .sops.yaml"
	nix flake lock --update-input secrets
fi

if yes_or_no "Add ssh host fingerprints for github and codeberg? If this is the first time running this script on $target_hostname, this will be required for the following steps?"; then
	green "Adding ssh host fingerprints for github and codeberg"
		#$ssh_cmd "sudo mkdir -p /root/.ssh/; ssh-keyscan -t ssh-ed25519 codeberg.org github.com >> /root/.ssh/known_hosts"
		$ssh_cmd "mkdir -p /home/$target_user/.ssh/; ssh-keyscan -t ssh-ed25519 codeberg.org github.com >> /home/$target_user/.ssh/known_hosts"
fi

if yes_or_no "Do you want to copy your full .files and .secrets to $target_hostname?"; then
	green "Adding ssh host fingerprint at $target_destination to ~/.ssh/known_hosts"
	ssh-keyscan -p "$ssh_port" "$target_destination" >>~/.ssh/known_hosts || true
	green "Copying full .files to $target_hostname"
	sync "$target_user" "${git_root}"/../.files
	green "Copying full .secrets to $target_hostname"
	sync "$target_user" "${git_root}"/../.secrets
	$ssh_cmd -oForwardAgent=yes "cd .files && git-agecrypt init"

if yes_or_no "Do you want to rebuild immediately?"; then
	green "Rebuilding .files on $target_hostname"
	#FIXME there are still a codeberg fingerprint request happening during the rebuild

	$ssh_cmd "sudo nixos-rebuild switch --flake ~/.files#$target_hostname"


	#$ssh_cmd -oForwardAgent=yes "cd .files && nh os switch"
	#if [ -n "$tpm" ]; then
	   # $ssh_root_cmd "/bin/sh -c 'device_name=\$(lsblk -no PKNAME,NAME | grep crypted | awk '\''{print \$1}'\''); systemd-cryptenroll --recovery-key /dev/\$device_name'"
	  #  $ssh_root_cmd "/bin/sh -c 'device_name=\$(lsblk -no PKNAME,NAME | grep crypted | awk '\''{print \$1}'\''); systemd-cryptenroll --wipe-slot=tpm2 --tpm2-device=auto --tpm2-pcrs=0+2 /dev/\$device_name'"
	 #   $ssh_root_cmd "/bin/sh -c 'device_name=\$(lsblk -no PKNAME,NAME | grep crypted | awk '\''{print \$1}'\''); cryptsetup luksKillSlot /dev/\$device_name 1'"
	#fi

fi
else
	echo
	green "NixOS was successfully installed!"
	echo "Post-install config build instructions:"
	echo "To copy .files from this machine to the $target_hostname, run the following command from ~/.files"
	echo "just sync $target_user $target_destination"
	echo "To rebuild, sign into $target_hostname and run the following command from ~/.files"
	echo "cd .files"
	echo "nh os switch"
	echo
fi

if yes_or_no "You can now commit and push the .files, which includes the hardware-configuration.nix for $target_hostname?"; then
	(pre-commit run --all-files 2>/dev/null || true) &&
		git add "$git_root/hosts/$target_hostname/hardware-configuration.nix" && (git commit -m "feat: hardware-configuration.nix for $target_hostname" || true) && git push
fi

#TODO prune all previous generations?

green "Success!"
green "If you are using a disko config with luks partitions, update luks to use non-temporary credentials."
