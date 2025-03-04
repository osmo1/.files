{ lib, fetchgit, rustPlatform }:
rustPlatform.buildRustPackage rec {
	pname = "daisy";
	version = "1.1.7";
	cargoLock.lockFile = src + /Cargo.lock;

	src = builtins.fetchGit {
		url = "https://github.com/rm-dr/daisy.git";
		rev = "b8bde580a33dacaaa7958dda9ec7da04d712e420";
	};

	meta = with lib; {
		description = "A general-purpose scientific calculator";
		homepage = "https://github.com/rm-dr/daisy";
		#license = licenses.GPL;
		maintainers = [ maintainers.tailhook ];
	};
}
