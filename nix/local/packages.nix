with inputs.nixpkgs; let
  hermes_1_8_0 = stdenv.mkDerivation {
    name = "hermes";
    version = "1.8.0";
    src = fetchurl {
      url = "https://github.com/informalsystems/hermes/releases/download/v1.8.0/hermes-v1.8.0-aarch64-unknown-linux-gnu.tar.gz";
      hash = "sha256-uQ6VKXJXK/63jXWSVU61Bk0+DZbH+f7cnHg+lKNQE0Y=";
    };
    dontBuild = true;
    sourceRoot = ".";
    installPhase = ''
      runHook preInstall
      install -m755 -D hermes $out/bin/hermes
      runHook postInstall
    '';
    nativeBuildInputs = [
      autoPatchelfHook
    ];
    buildInputs = [glibc];
  };
in {
  inherit hermes_1_8_0;
}
