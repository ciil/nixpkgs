{ stdenv, fetchFromGitHub, cmake, openssl, libevent }:

stdenv.mkDerivation rec {
  name = "libevhtp-${version}";
  version = "1.1.6";

  src = fetchFromGitHub {
    owner = "criticalstack";
    repo = "libevhtp";
    rev = version;
    sha256 = "1k11r6gvndd1nzk6gs896hpfl5cnqir7jrl4jn7p5hsqpllzjjzs";
  };

  buildInputs = [ cmake openssl libevent ];

  buildPhase = ''
    cmake -DEVHTP_DISABLE_SSL=ON -DEVHTP_BUILD_SHARED=OFF .
    make
  '';

  meta = with stdenv.lib; {
    description = "A more flexible replacement for libevent's httpd API";
    homepage = "https://github.com/criticalstack/libevhtp";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ciil ];
    platforms = platforms.linux;
  };
}
