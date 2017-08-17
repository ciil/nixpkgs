{stdenv, fetchurl, automake, autoconf, pkgconfig, libtool, python2Packages, glib, jansson}:

stdenv.mkDerivation rec
{
  version = "3.1-latest";
  seafileVersion = "6.1.0";
  name = "libsearpc-${version}";

  src = fetchurl
  {
    url = "https://github.com/haiwen/libsearpc/archive/v${version}.tar.gz";
    sha256 = "143x6ycn1gb8qyy3rbydjgs1wm9k0i1lv82csdnsxmxpyji5zd43";
  };

  patches = [ ./libsearpc.pc.patch ];

  buildInputs = [ automake autoconf pkgconfig libtool python2Packages.python python2Packages.simplejson ];
  propagatedBuildInputs = [ glib jansson ];

  preConfigure = ''
    sed -ie 's|/bin/bash|${stdenv.shell}|g' ./autogen.sh
    ./autogen.sh
  '';

  buildPhase = "make -j1";

  meta = with stdenv.lib; {
    homepage = https://github.com/haiwen/libsearpc;
    description = "A simple and easy-to-use C language RPC framework (including both server side & client side) based on GObject System";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ calrama ciil ];
  };
}
