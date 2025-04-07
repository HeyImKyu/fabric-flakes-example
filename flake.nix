{
  description = "Main Flake / NixOS / Home-Manager Config file; Blegh ;-;";

  inputs = {
    nixpkgs-unstable.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs = {
    nixpkgs-unstable,
    home-manager,
    nur,
    ...
  } @ inputs:
  let
    systemArchitecture = "x86_64-linux";
    overlays = [
      nur.overlays.default
    ];
  in
  {
    nixosConfigurations = {
      nixos = nixpkgs-unstable.lib.nixosSystem {
        system = systemArchitecture;
        specialArgs = {
          inherit inputs;
          pkgs = import nixpkgs-unstable {
            system = systemArchitecture;
            overlays = overlays;
            config.allowUnfree = true;
          };
        };
        modules = [
          ./hosts/nixos/configuration.nix
          
          # make home-manager as a module of nixos
          # so that home-manager configuration will be deployed automatically when executing `nixos-rebuild switch`
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              extraSpecialArgs = {
                inherit inputs;
              }; 
              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = "backup";
              users = {
                kyu = {
                  imports = [
                    ./hosts/nixos/home.nix
                  ]; 
                };
              };
            };
            nixpkgs.overlays = overlays;
          }
        ];
      };
    };
  };
}
