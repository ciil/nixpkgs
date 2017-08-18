{ stdenv, fetchurl, pkgconfig, ccnet-server, seafile-shared, makeWrapper
, libevent, curl, intltool, sqlite, libmysql, libtool, vala }:

stdenv.mkDerivation rec {
  version = "6.1.2";
  name = "ccnet-server-${version}";

  src = fetchurl {
    url = "https://github.com/haiwen/ccnet-server/archive/v${version}-server.tar.gz";
    sha256 = "19imc3bmf8z991aspcc4s979305m6qrcq4dy6imr016kp4nlwwka";
  };

  nativeBuildInputs = [ pkgconfig makeWrapper ];
  buildInputs = [ libevent intltool sqlite libmysql libtool vala seafile-shared ];

  preConfigure = ''
    sed -ie 's|/bin/bash|${stdenv.shell}|g' ./autogen.sh
    ./autogen.sh
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/haiwen/ccnet-server;
    description = "Internal communication framework and user/group management for Seafile server.";
    license = licenses.agpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ciil ];
  };
}
