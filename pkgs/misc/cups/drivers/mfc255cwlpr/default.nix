{ coreutils, dpkg, fetchurl, file, ghostscript, gnugrep, gnused,
makeWrapper, perl, pkgs, stdenv, which }:

stdenv.mkDerivation rec {
  name = "mfc255cwlpr-${version}";
  version = "1.1.3-1";

  src = fetchurl {
    url = "https://download.brother.com/welcome/dlf006068/${name}.i386.deb";
    sha256 = "1x8zd4b1psmw1znp2ibncs37xm5mljcy9yza2rx8jm8lp0a3l85v";
  };

  nativeBuildInputs = [ dpkg makeWrapper ];

  phases = [ "installPhase" ];

  installPhase = ''
    dpkg-deb -x $src $out

    dir=$out/opt/brother/Printers/mfc255cw
    filter=$dir/lpd/filter_mfc255cw

    substituteInPlace $filter \
      --replace /usr/bin/perl ${perl}/bin/perl \
      --replace "BR_PRT_PATH =~" "BR_PRT_PATH = \"$dir/\"; #" \
      --replace "PRINTER =~" "PRINTER = \"mfc255cw\"; #"

    wrapProgram $filter \
      --prefix PATH : ${stdenv.lib.makeBinPath [
      coreutils file ghostscript gnugrep gnused which
      ]}

    # need to use i686 glibc here, these are 32bit proprietary binaries
    interpreter=${pkgs.pkgsi686Linux.glibc}/lib/ld-linux.so.2
    patchelf --set-interpreter "$interpreter" $dir/lpd/brmfc255cwfilter
  '';

  meta = {
    description = "Brother MFC-L8690CDW LPR printer driver";
    homepage = http://www.brother.com/;
    license = stdenv.lib.licenses.unfree;
    maintainers = [ stdenv.lib.maintainers.ciil ];
    platforms = [ "i686-linux" ];
  };
}
