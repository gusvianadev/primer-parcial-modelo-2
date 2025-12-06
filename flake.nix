{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };
  outputs =
    { nixpkgs, ... }:
    {
      devShells.x86_64-linux =
        let
          pkgs = import nixpkgs {
            system = "x86_64-linux";
          };
          riscvPkgs = pkgs.pkgsCross.riscv64;
        in
        {
          default = pkgs.mkShell {
            packages = with pkgs; [
              # RISC-V Cross-compiler toolchain
              riscvPkgs.buildPackages.gcc
              riscvPkgs.buildPackages.binutils

              nasm
              valgrind
              # QEMU for running RISC-V binaries
              qemu

              # Debugging tools
              gdb

              # Build tools
              gnumake

              # Optional: useful utilities
              file
              binutils

              clang-tools
              gdb
              SDL2
              (pkgs.python3.withPackages (python-pkgs: [
                python-pkgs.pygments
              ]))
            ];

          };
        };
    };
}
