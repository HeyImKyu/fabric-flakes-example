### This is supposed to be an example repo of how i use fabric in nixos ^^

---

Configuration.nix and home.nix are in [hosts/nixos](https://github.com/HeyImKyu/fabric-flakes-example/tree/main/hosts/nixos)

The fabric configuration is imported in home.nix and is located in [modules/homemanager/fabric/default.nix](https://github.com/HeyImKyu/fabric-flakes-example/blob/main/modules/home-manager/fabric/default.nix)

## Usage

With this configuration, you can simply run `run-widget <your-widget>.py` and `fabric-cli`.

If you need extra packages or python inputs for your widget, they can be defined as shown in the [fabric/default.nix](https://github.com/HeyImKyu/fabric-flakes-example/blob/main/modules/home-manager/fabric/default.nix)

### Update

This is my updated version to use my nur repository.
If for whatever reason, i should not keep my stuff updated, please look at how it was done before this, in the [legacy branch](https://github.com/HeyImKyu/fabric-flakes-example/tree/legacy)
