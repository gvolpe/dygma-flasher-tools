{ lib
, appimageTools
, fetchurl
, makeWrapper
}:

let
  pname = "dygma-flasher-tools";
  version = "10.4.6";
  src = appimageTools.extract {
    inherit pname version;
    src = fetchurl {
      url = "https://github.com/gvolpe/dygma-flasher-tools/releases/download/v${version}/FlasherTools-10.4.6.AppImage";
      hash = "sha256-85LCnSoLGngkl5eAgoIyUsjs46X1rXCOnWrj29CsmcM=";
    };
  };
in
appimageTools.wrapAppImage {
  inherit pname version src;

  nativeBuildInputs = [ makeWrapper ];

  extraPkgs = pkgs: [ pkgs.glib ];

  extraInstallCommands = ''
    wrapProgram $out/bin/dygma-flasher-tools \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}"

    mkdir -p $out/lib/udev/rules.d
    install -m 444 -D ${./60-dygma.rules} $out/lib/udev/rules.d/60-dygma.rules
  '';

  meta = {
    description = "Flasher Tools for Dygma Products";
    homepage = "https://github.com/Dygmalab/Bazecor";
    changelog = "https://github.com/gvolpe/dygma-flasher-tools/releases/tag/v${version}";
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ gvolpe ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "dygma-flasher-tools";
  };
}
