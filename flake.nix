{
  inputs.flake-utils.url = github:numtide/flake-utils;

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:

      let pkgs = nixpkgs.legacyPackages.${system}; in
      {
        packages.default = self.packages.${system}.timidityFromNixpkgs;

        ## This is TiMidity++ as provided by Nixpkgs.
        packages.timidityFromNixpkgs = pkgs.timidity;

        ## This is TiMidity++ as provided by Nixpkgs, except we do the
        ## `callPackage` manually here to show how it is done.
        packages.timidityFromNixpkgs' = pkgs.callPackage ./timidity {
          inherit (pkgs.darwin.apple_sdk.frameworks) CoreAudio;
        };

        ## This is TiMidity++ with additional vorbis support. Note the extra
        ## argument to `callPackage`.
        packages.timidityWithVorbis = pkgs.callPackage ./timidity {
          inherit (pkgs.darwin.apple_sdk.frameworks) CoreAudio;
          enableVorbis = true;
        };
      }
    );
}
