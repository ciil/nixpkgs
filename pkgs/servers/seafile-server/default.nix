{ stdenv, fetchFromGitHub, pkgconfig, autoconf, automake, makeWrapper
, ccnet-server, seafile-shared, libevent, curl, intltool, sqlite
, libmysql, libtool, vala, python27, fuse, libarchive, libsearpc
, which, libevhtp, lzma, bzip2, file }:

stdenv.mkDerivation rec {
  name = "seafile-server-${version}";
  version = "6.1.2";

  src = fetchFromGitHub {
    owner = "haiwen";
    repo = "seafile-server";
    rev = "v${version}-server";
    sha256 = "0mvwcd517mvhysmdysza7gbgkxa8h4zcqs9l3gh0c6iwz9qn56zz";
  };

  nativeBuildInputs = [ 
    pkgconfig autoconf automake makeWrapper python27 libarchive fuse 
    libsearpc which libevhtp lzma bzip2 file 
  ];
  buildInputs = [ 
    libevent intltool sqlite libmysql libtool vala seafile-shared 
  ];

  preConfigure = ''
    sed -ie 's|/bin/bash|${stdenv.shell}|g' ./autogen.sh
    ./autogen.sh
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/haiwen/seafile-server;
    description = "The seafile server, an open source cloud storage system with features on privacy protection and teamwork.";
    license = licenses.agpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ciil ];
  };
}
