/**
  Threema Desktop 2.0 (beta), built from source.

  Upstream ships the Linux build only as a Flatpak. This builds the same consumer-live flavor:
  libthreema as wasm, the Electron app bundle, the two native modules against the Electron
  headers, and the restart launcher, which then runs the app on the nixpkgs Electron.
*/
{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  cargo,
  rustc,
  lld,
  wasm-bindgen-cli_0_2_114,
  binaryen,
  protobuf,
  nodejs_22,
  pnpm_11,
  fetchPnpmDeps,
  pnpmConfigHook,
  node-gyp,
  python3,
  electron_42,
  makeWrapper,
  makeDesktopItem,
  copyDesktopItems,
}:

let
  pname = "threema-desktop";
  version = "2.0-beta66";
  flavor = "consumer-live";
  electron = electron_42;

  src = fetchFromGitHub {
    owner = "threema-ch";
    repo = "threema-desktop";
    tag = "v${version}";
    hash = "sha256-eEYGXD/DRucQbcz0DgmWg/SdKwTdBcGIH0wUtnfeOpA=";
  };

  /**
    libthreema compiled to wasm with its web bindings, as `tools/build-wasm.sh --target=web`
    produces it.
  */
  libthreema = stdenv.mkDerivation {
    pname = "libthreema-wasm";
    inherit version;
    src = "${src}/packages/libthreema-wasm/libs/libthreema";

    cargoDeps = rustPlatform.fetchCargoVendor {
      pname = "libthreema-wasm";
      inherit version;
      src = "${src}/packages/libthreema-wasm/libs/libthreema";
      hash = "sha256-s9j88rYsEIls95SG5mlqjmBzr0Lzqdv+ZRvRut2IjCU=";
    };

    nativeBuildInputs = [
      rustPlatform.cargoSetupHook
      cargo
      rustc
      lld
      wasm-bindgen-cli_0_2_114
      binaryen
      protobuf
    ];

    env.CARGO_TARGET_WASM32_UNKNOWN_UNKNOWN_LINKER = "wasm-ld";

    buildPhase = ''
      runHook preBuild
      bash ./tools/build-wasm.sh --target=web --no-container
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      cp -r build/wasm/web $out
      runHook postInstall
    '';
  };

  /**
    Restarts the app when it exits asking for a restart, and handles the profile reset and
    rename requests that come back the same way.
  */
  launcher = rustPlatform.buildRustPackage {
    pname = "threema-desktop-launcher";
    inherit version src;

    sourceRoot = "${src.name}/apps/desktop/src/rust";
    cargoRoot = "launcher";
    buildAndTestSubdir = "launcher";
    cargoHash = "sha256-ZfAyrGGWLNvJExnBdleqhEASKmk4AYaMpOxqbZdLVho=";

    buildFeatures = [ "allow_path_override" ];
    env.THREEMA_BUILD_FLAVOR = flavor;
    doCheck = false;
  };

  /**
    Lets the pinned upstream toolchain versions pass with the ones nixpkgs provides.
  */
  relaxToolchainPins = ''
    sed -i '/^engineStrict:/d; /^pmOnFail:/d' pnpm-workspace.yaml
  '';
in
stdenv.mkDerivation (finalAttrs: {
  inherit pname version src;

  postPatch = relaxToolchainPins + ''
    sed -i '/"packageManager":/d' package.json apps/desktop/package.json

    substituteInPlace apps/desktop/src/electron/electron-main.ts \
      --replace-fail "path.join(process.resourcesPath, 'icon-512.png')" \
                     "'$out/share/threema-desktop/icon-512.png'"
  '';

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    pnpm = pnpm_11;
    postPatch = relaxToolchainPins;
    fetcherVersion = 4;
    hash = "sha256-iTipjUNU/U5eetZOPgJks0nJKN7YoWdY4jSQ69DuatU=";
  };

  nativeBuildInputs = [
    nodejs_22
    pnpm_11
    pnpmConfigHook
    node-gyp
    python3
    makeWrapper
    copyDesktopItems
  ];

  env = {
    ELECTRON_SKIP_BINARY_DOWNLOAD = "1";
    TURBO_BUILD_ENVIRONMENT = "live";
    TURBO_BUILD_VARIANT = "consumer";
    TURBO_BUILD_MODE = "production";
  };

  buildPhase = ''
    runHook preBuild

    mkdir -p packages/libthreema-wasm/libs/libthreema/build/wasm
    cp -r ${libthreema} packages/libthreema-wasm/libs/libthreema/build/wasm/web
    chmod -R u+w packages/libthreema-wasm/libs/libthreema/build

    for workspace in ts-utils vite-plugin-commonjs-externals vite-plugin-subresource-integrity; do
      pnpm --filter "./packages/$workspace" run build
    done

    for module in argon2 better-sqlcipher; do
      (cd "$(readlink -f apps/desktop/node_modules/$module)" \
        && node-gyp rebuild --release --nodedir=${electron.headers})
    done

    (cd apps/desktop && node tools/build-electron.mjs)

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    app=$out/share/threema-desktop/app
    modules=apps/desktop/node_modules
    mkdir -p $app/node_modules
    cp apps/desktop/package.json $app/
    cp -r apps/desktop/build $app/build
    rm -rf $app/build/electron/cli

    install -Dm644 -t $app/node_modules/argon2 $modules/argon2/{argon2.cjs,package.json}
    install -Dm644 -t $app/node_modules/argon2/build/Release $modules/argon2/build/Release/argon2.node
    install -Dm644 -t $app/node_modules/@phc/format \
      "$(readlink -f $modules/argon2)"/../@phc/format/{index.js,package.json}
    install -Dm644 -t $app/node_modules/better-sqlcipher $modules/better-sqlcipher/package.json
    cp -r $modules/better-sqlcipher/lib $app/node_modules/better-sqlcipher/lib
    install -Dm644 -t $app/node_modules/better-sqlcipher/build/Release \
      $modules/better-sqlcipher/build/Release/better_sqlcipher.node

    install -Dm644 apps/desktop/src/public/res/icons/${flavor}/icon-512.png \
      $out/share/threema-desktop/icon-512.png
    install -Dm644 apps/desktop/packaging/assets/icons/flatpak/${flavor}.svg \
      $out/share/icons/hicolor/scalable/apps/threema-beta.svg
    install -Dm644 apps/desktop/packaging/assets/icons/flatpak/${flavor}.png \
      $out/share/icons/hicolor/512x512/apps/threema-beta.png

    makeWrapper ${launcher}/bin/ThreemaDesktopLauncher $out/bin/threema-beta \
      --add-flags "--launcher-target-bin ${lib.getExe electron}" \
      --add-flags "$app"

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "threema-beta";
      desktopName = "Threema Beta";
      exec = "threema-beta %U";
      icon = "threema-beta";
      startupWMClass = "Threema";
      categories = [
        "Network"
        "InstantMessaging"
        "Chat"
      ];
      keywords = [
        "encryption"
        "threema"
        "privacy"
        "chat"
        "communications"
      ];
    })
  ];

  passthru = { inherit libthreema launcher; };

  meta = {
    description = "Threema Desktop messenger (2.0 beta), built from source";
    homepage = "https://threema.ch/";
    license = lib.licenses.agpl3Plus;
    platforms = [ "x86_64-linux" ];
    mainProgram = "threema-beta";
  };
})
