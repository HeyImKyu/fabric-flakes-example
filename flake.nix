{
  description = "Main Flake / NixOS / Home-Manager Config file; Blegh ;-;";

  inputs = {
    nixpkgs-stable.url = "github:nixos/nixpkgs?ref=nixos-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    fabric = {
      url = "github:Fabric-Development/fabric";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    fabric-gray = {
      url = "github:Fabric-Development/gray";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    fabric-cli = {
      url = "github:HeyImKyu/fabric-cli";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs = {
    nixpkgs-unstable,
    nixpkgs-stable,
    home-manager,
    nixos-hardware,
    fabric,
    fabric-gray,
    fabric-cli,
    ...
  } @ inputs:
  let
    systemArchitecture = "x86_64-linux";
    overlays = [
      (final: prev: {fabric-run-widget = fabric.packages.${systemArchitecture}.run-widget;})
      (final: prev: {fabric = fabric.packages.${systemArchitecture}.default;})
      (final: prev: {fabric-cli = fabric-cli.packages.${systemArchitecture}.default;})
      (final: prev: {fabric-gray = fabric-gray.packages.${systemArchitecture}.default;})

      fabric.overlays.${systemArchitecture}.default
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
          pkgs-stable = import nixpkgs-stable {
            system = systemArchitecture;
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
                pkgs-stable = import nixpkgs-stable {
                  system = systemArchitecture;
                  config.allowUnfree = true;
                };
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
            nixpkgs.overlays = [
                overlays
            ];
          }
        ];
      };
    };
  };
}
