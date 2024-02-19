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
    nativeBuildInputs = [pkgs.pkg-config];
    buildInputs = [pkgs.glibc pkgsStatic.openssl];
    doCheck = false;
    CARGO_BUILD_TARGET = target;
    CARGO_BUILD_RUSTFLAGS = "-Ctarget-feature=+crt-static";
  };
in {
  inherit hermes_1_8_0;
  inherit hermes_gas_estimation;
}
