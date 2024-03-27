with inputs.nixpkgs; let
  target =
    if system == "x86_64-linux"
    then "x86_64-unknown-linux-musl"
    else "aarch64-unknown-linux-musl";

  toolchain = with inputs.fenix.packages.${system};
    combine [
      default.cargo
      default.rustc
      targets.${target}.latest.rust-std
    ];

  craneLib = (inputs.crane.mkLib pkgs).overrideToolchain toolchain;

  hermes_1_8_0 = craneLib.buildPackage {
    src = fetchTarball {
      url = "https://github.com/informalsystems/hermes/archive/refs/tags/v1.8.0.tar.gz";
      sha256 = "sha256:16piirbdgddvws9wbd0hcpwmgsk0plxalwlf9llqaaj3xj3dbl1i";
    };
    doCheck = false;
    CARGO_BUILD_TARGET = target;
    CARGO_BUILD_RUSTFLAGS = "-Ctarget-feature=+crt-static";
  };
  hermes_gas_estimation = craneLib.buildPackage {
    src = fetchTarball {
      url = "https://github.com/devashishdxt/hermes/archive/refs/heads/gas-estimate.tar.gz";
      sha256 = "sha256:1mwm0ia69wlshr5m5a8vblc6zh244rrxxm7np5df74jg330nyw7z";
    };
    nativeBuildInputs = [pkg-config];
    buildInputs = [pkgsStatic.openssl];
    doCheck = false;
    CARGO_BUILD_TARGET = target;
    CARGO_BUILD_RUSTFLAGS = "-Ctarget-feature=+crt-static";
  };
  hermes_1_8_2 = rustPlatform.buildRustPackage rec {
    pname = "hermes";
    version = "1.8.2";
    src = fetchTarball {
      url = "https://github.com/informalsystems/hermes/archive/refs/tags/v${version}.tar.gz";
      sha256 = "sha256:0m201mr5if71p4vj340i2cxn77y0778g1q3p923ilg3fr5czp0zn";
    };
    doCheck = false;
    cargoHash = "sha256-CwU9VTAPo9hm5JGzt1XzCLGWbHFlie/+jhZ5ckWo2qU=";
  };
in {
  inherit hermes_1_8_0;
  inherit hermes_1_8_2;
  inherit hermes_gas_estimation;
}
