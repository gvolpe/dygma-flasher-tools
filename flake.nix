{
  description = "Dygma Flasher Tools flake";

  inputs = {
    #nixpkgs.url = "nixpkgs/nixos-unstable";
    # nix doesn't need the full history, this should be the default ¯\_(ツ)_/¯
    nixpkgs.url = "git+https://github.com/NixOS/nixpkgs?shallow=1&ref=nixos-unstable";
  };

  outputs = { nixpkgs, ... }:
    let
      system = "x86_64-linux";

      flasherOverlay = f: p: {
        dygma-flasher-tools = p.callPackage ./drv.nix { };
      };

      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [ flasherOverlay ];
      };
    in
    {
      packages.${system}.default = pkgs.dygma-flasher-tools;
    };
}
