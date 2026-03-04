{
  description = "Espresso logic minimizer - two-level logic minimization";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      supportedSystems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      # 从 nixpkgs flake 取“按 system 的完整包集”（含 stdenv、meson 等），
      # 这是 flake 下的标准用法，名字里的 legacy 指接口形态，并非已废弃。
      pkgsFor = nixpkgs.legacyPackages;
    in
    {
      packages = forAllSystems (system:
        let
          pkgs = pkgsFor.${system};
        in
        {
          default = pkgs.stdenv.mkDerivation {
            pname = "espresso";
            version = "0.0.0";
            src = self;

            nativeBuildInputs = [ pkgs.meson pkgs.ninja pkgs.asciidoctor ];

            configurePhase = ''
              runHook preConfigure
              meson setup build . --prefix=$out -Dbuild_doc=enabled
              runHook postConfigure
            '';
            buildPhase = "ninja -C build";
            installPhase = "ninja -C build install";

            meta = with pkgs.lib; {
              description = "Two-level logic minimizer (PLA minimization)";
              homepage = "https://github.com/KINGFIOX/espresso";
              license = licenses.bsd3;
              mainProgram = "espresso";
              platforms = supportedSystems;
            };
          };
          espresso = self.packages.${system}.default;
        });

      # 供父项目通过 espresso 命令使用：在父项目 flake 的 buildInputs 或
      # devShell 的 nativeBuildInputs 中加入 inputs.espresso.packages.${system}.default，
      # 即可在构建/Shell 中直接使用 espresso 命令。
      apps = forAllSystems (system:
        let
          espresso = self.packages.${system}.default;
        in
        {
          default = {
            type = "app";
            program = "${espresso}/bin/espresso";
          };
        });

      devShells = forAllSystems (system:
        let
          pkgs = pkgsFor.${system};
        in
        {
          default = pkgs.mkShell {
            nativeBuildInputs = [
              pkgs.meson
              pkgs.ninja
              pkgs.asciidoctor
            ];
            shellHook = ''
              echo "Espresso dev shell. Run: meson setup build && ninja -C build"
            '';
          };
        });
    };
}
