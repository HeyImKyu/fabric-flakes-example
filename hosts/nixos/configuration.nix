{ pkgs, inputs, ... }:
{
users.groups.wireshark = {};
security.wrappers.dumpcap = {
  source = "${pkgs.wireshark}/bin/dumpcap";
  capabilities = "cap_net_raw,cap_net_admin=eip";
  owner = "root";
  group = "wireshark";
};
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix 
      inputs.home-manager.nixosModules.default
    ];

  services = {
    printing.enable = true;

    # Disable sound with pipewire.
    pulseaudio.enable = false;
    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      wireplumber = {
        enable = true;
      };
      pulse.enable = true;
    };
  };

  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
  };

  hardware = {
    bluetooth = {
      enable = true; # enables support for Bluetooth
      powerOnBoot = true; # powers up the default Bluetooth controller on boot
      settings = {
        General = {
          Experimental = true;
        };
      };
    };
  };

  security = {
    # Swaylock fix
    pam.services.swaylock = {
      u2fAuth = true; 
    };
    
    # Enable sound with pipewire.
    rtkit.enable = true;
  };

  programs.zsh.enable = true;

  users.users = {
    kyu = {
      isNormalUser = true;
      description = "Kyu";
      extraGroups = [ "networkmanager" "wheel" "wireshark" ];
      shell = pkgs.zsh;
    };
  };

  nix = {
    package = pkgs.lix;
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
    };
  };

  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05";

  # Bootloader.
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  time.timeZone = "Europe/Berlin";
  i18n = {
    defaultLocale = "en_US.UTF-8";

    extraLocaleSettings = {
      LC_ADDRESS = "de_DE.UTF-8";
      LC_IDENTIFICATION = "de_DE.UTF-8";
      LC_MEASUREMENT = "de_DE.UTF-8";
      LC_MONETARY = "de_DE.UTF-8";
      LC_NAME = "de_DE.UTF-8";
      LC_NUMERIC = "de_DE.UTF-8";
      LC_PAPER = "de_DE.UTF-8";
      LC_TELEPHONE = "de_DE.UTF-8";
      LC_TIME = "de_DE.UTF-8";
    };
  };

  console.keyMap = "de";
}
