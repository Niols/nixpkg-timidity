{
  inputs.flake-utils.url = github:numtide/flake-utils;

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:

      let pkgs = nixpkgs.legacyPackages.${system}; in
      {
        packages.default = self.packages.${system}.timidity;
        packages.timidity = pkgs.callPackage ./timidity {
          inherit (pkgs.darwin.apple_sdk.frameworks) CoreAudio;
          enableVorbis = true;
        };
      }
    );
}
