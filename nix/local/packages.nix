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
  hermes_1_10_0 = rustPlatform.buildRustPackage rec {
    pname = "hermes";
    version = "1.10.0";
    src = fetchTarball {
      url = "https://github.com/informalsystems/hermes/archive/refs/tags/v${version}.tar.gz";
      sha256 = "sha256:02wrpg2m5waz9m5qxc8592m4aw249p6a1qz1gy5kgcw0zbzgp4jp";
    };
    doCheck = false;
    cargoHash = "sha256-wa0dzSvsS050qHEf2EMQRiQ+/c22Yxg5BsU7olrx4Ws=";
  };
  hermes_1_10_5 = rustPlatform.buildRustPackage rec {
    pname = "hermes";
    version = "1.10.5";
    src = fetchTarball {
      url = "https://github.com/informalsystems/hermes/archive/refs/tags/v${version}.tar.gz";
      sha256 = "sha256:0bllmk32m3xd6y4z1q4p86bbs7rb672ksjn4lc25j3g4cbyf06vj";
    };
    doCheck = false;
    cargoHash = "sha256-uwkcMegGnzEHqs161idOJLmVoHbGxBj79Bq2gYZA6jI=";
  };
  hermes_test_20251112 = rustPlatform.buildRustPackage rec {
    pname = "hermes";
    version = "test-20251112";
    src = fetchTarball {
      url = "https://github.com/henrywong-crypto/hermes/archive/refs/tags/${version}.tar.gz";
      sha256 = "sha256:0s9dy7581b1yphgcr7lkddjf688bwzvvcwa9f3ci6mx6q449dk3w";
    };
    doCheck = false;
    cargoHash = "sha256-wGe1tn+iIsSfdWXfMAILA1U9ejdccb9he3uBJ3Lvl/w=";
  };
  hermes_test_20251208 = rustPlatform.buildRustPackage rec {
    pname = "hermes";
    version = "test-20251208";
    src = fetchTarball {
      url = "https://github.com/henrywong-crypto/hermes/archive/refs/tags/${version}.tar.gz";
      sha256 = "sha256:16x7p8g8fr2j0ysg1ivqwpadgsfspmli39vq5cby8m0f9r5yml54";
    };
    doCheck = false;
    cargoHash = "sha256-wGe1tn+iIsSfdWXfMAILA1U9ejdccb9he3uBJ3Lvl/w=";
  };
in {
  inherit hermes_1_10_0;
  inherit hermes_1_10_5;
  inherit hermes_1_8_0;
  inherit hermes_1_8_2;
  inherit hermes_gas_estimation;
  inherit hermes_test_20251112;
  inherit hermes_test_20251208;
}
