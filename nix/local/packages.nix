with inputs.nixpkgs; let
  toolchain = with inputs.fenix.packages.${system};
    combine [
      default.cargo
      default.rustc
    ];

  craneLib = (inputs.crane.mkLib pkgs).overrideToolchain toolchain;

  hermes_1_8_0 = craneLib.buildPackage {
    src = fetchTarball {
      url = "https://github.com/informalsystems/hermes/archive/refs/tags/v1.8.0.tar.gz";
      sha256 = "sha256:16piirbdgddvws9wbd0hcpwmgsk0plxalwlf9llqaaj3xj3dbl1i";
    };
    doCheck = false;
  };
in {
  inherit hermes_1_8_0;
}
