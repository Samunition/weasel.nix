{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, nixos-wsl, home-manager, ... }: {
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          nixos-wsl.nixosModules.default
          {
            system.stateVersion = "24.05";
            wsl.enable = true;
	    wsl.defaultUser = "sam";
            nix.settings.experimental-features = ["nix-command" "flakes"];
          }
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.sam = ./home.nix;
	  }
	  { 
	    virtualisation.containerd.enable = true;
	    # This is rootless right haha
            programs.bash.shellAliases = { nerdctl = "sudo nerdctl"; }; 
            security.sudo.extraRules = [{
              commands = [
                { command = "${nixpkgs.pkgs.nerdctl}/bin/nerdctl"; options = [ "NOPASSWD" ]; }
              ];
            }];
	  }
	];
      };
    };
  };
}
