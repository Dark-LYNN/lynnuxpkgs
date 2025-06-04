pkgs.stdenv.mkDerivation rec {
  pname = "jdownloader";
  version = "2";
  unpackPhase = ":";

  src = pkgs.fetchurl {
    url = "https://installer.jdownloader.org/JDownloader.jar";
    sha256 = "1ppnplh4pwg7b6sy2h3vv8mrb26zj3lzzxq7zmwm2p2z3l99860c";
  };

  nativeBuildInputs = [ pkgs.makeWrapper pkgs.jre ];

installPhase = ''
  mkdir -p $out/libexec/jdownloader
  cp $src $out/libexec/jdownloader/JDownloader.jar

  mkdir -p $out/bin
  cat > $out/bin/jdownloader <<'EOF'
#!/bin/sh

homeDir="$HOME"
mkdir -p "$homeDir/.config/JDownloader/cfg" "$homeDir/.config/JDownloader/logs"
cd "$homeDir/.config/JDownloader"

if [ ! -e "$homeDir/.config/JDownloader/JDownloader.jar" ]; then
  cp "$out/libexec/jdownloader/JDownloader.jar" "$homeDir/.config/JDownloader/JDownloader.jar"
  chmod u+w "$homeDir/.config/JDownloader/JDownloader.jar"
fi

export JD_CONFIG_DIR="$homeDir/.config/JDownloader"

exec ${pkgs.jre}/bin/java -jar "$homeDir/.config/JDownloader/JDownloader.jar" "$@"
EOF

  chmod +x $out/bin/jdownloader

  mkdir -p $out/share/applications
  cat > $out/share/applications/jdownloader.desktop <<EOF
[Desktop Entry]
Name=JDownloader
GenericName=Download Manager
Comment=Download manager for file hosting services
Exec=$out/bin/jdownloader
Terminal=false
Type=Application
Categories=Network;Utility;
EOF
'';


  meta = with pkgs.lib; {
    description = "Download manager for file hosting services";
    homepage = "https://jdownloader.org/";
    license = licenses.unfree;
    maintainers = with maintainers; [ "Lynnux" ];
    platforms = platforms.linux;
  };
}
