{
  description = "JDownloader Nix flake";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in {
      packages.${system}.default = pkgs.callPackage ./default.nix {};
      defaultPackage.${system} = self.packages.${system}.default;
    };
}
