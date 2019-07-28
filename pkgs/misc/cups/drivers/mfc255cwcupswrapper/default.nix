{ coreutils, dpkg, fetchurl, gnugrep, gnused, makeWrapper,
mfc255cwlpr, perl, stdenv}:

stdenv.mkDerivation rec {
  name = "mfc255cwcupswrapper-${version}";
  version = "1.1.3-1";

  src = fetchurl {
    url = "https://download.brother.com/welcome/dlf006070/${name}.i386.deb";
    sha256 = "0bl9r8mmj4vnanwpfjqgq3c9lf2v46wp5k6r2n9iqprf7ldd1kb2";
  };

  nativeBuildInputs = [ dpkg makeWrapper ];

  phases = [ "installPhase" ];

  installPhase = ''
    dpkg-deb -x $src $out

    basedir=${mfc255cwlpr}/opt/brother/Printers/mfc255cw
    dir=$out/opt/brother/Printers/mfc255cw

    substituteInPlace $dir/cupswrapper/brother_lpdwrapper_mfc255cw \
      --replace /usr/bin/perl ${perl}/bin/perl \
      --replace "basedir =~" "basedir = \"$basedir/\"; #" \
      --replace "PRINTER =~" "PRINTER = \"mfc255cw\"; #"

    wrapProgram $dir/cupswrapper/brother_lpdwrapper_mfc255cw \
      --prefix PATH : ${stdenv.lib.makeBinPath [ coreutils gnugrep gnused ]}

    mkdir -p $out/lib/cups/filter
    mkdir -p $out/share/cups/model

    ln $dir/cupswrapper/brother_lpdwrapper_mfc255cw $out/lib/cups/filter
    ln $dir/cupswrapper/brother_mfc255cw_printer_en.ppd $out/share/cups/model
    '';

  meta = {
    description = "Brother MFC-L8690CDW CUPS wrapper driver";
    homepage = http://www.brother.com/;
    license = stdenv.lib.licenses.unfree;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.ciil];
  };
}
