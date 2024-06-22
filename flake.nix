{
  description = "cnnd's nixos config flake";

  inputs = {
    # might as well use the 24.05 version
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # add spicetify
    spicetify-nix.url = "github:the-argus/spicetify-nix";
  };

  outputs = { nixpkgs, ...} @ inputs: let     
    # here we use nixpkgs from our inputs, which is why why included it
    # above instead of just {...} @ inputs. If we did that, this would be
    # "inputs.nixpkgs".
    pkgs = import nixpkgs { system = "x86_64-linux"; };
  in {
    # replace komodo with your hostname
    nixosConfigurations = {
      komodo = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [
          ./nixos/configuration.nix
        ];
      };
    };
    homeConfigurations = {
      "cnnd@komodo" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        system = "x86_64-linux";
        modules = [
          ./home-manager/home.nix
          ./modules/spicetify.nix
        ];
      };
    };
  };
}