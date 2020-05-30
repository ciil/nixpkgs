{ stdenv, fetchFromGitHub }:
stdenv.mkDerivation rec {
  pname = "map";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "soveran";
    repo = "map";
    rev = version;
    sha256 = "0w1rjd114r30sj86af5w0cyq1pppicx4np4ks2ra5migkj2ycv68";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  postInstall = ''
    mkdir -p "$out/share/doc/${pname}"
    cp README* LICENSE "$out/share/doc/${pname}"
  '';

  meta = {
    inherit version;
    description = "Map lines from stdin to commands";
    license = stdenv.lib.licenses.bsd2;
    maintainers = [stdenv.lib.maintainers.ciil];
    platforms = stdenv.lib.platforms.unix;
    homepage = "https://github.com/soveran/map";
  };
}
