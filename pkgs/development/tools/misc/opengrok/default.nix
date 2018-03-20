{ fetchurl, stdenv, jre, ctags, makeWrapper, coreutils, git }:

stdenv.mkDerivation rec {
  name = "opengrok-${version}";
  version = "1.0";

  # 1.0 is the latest distributed as a .tar.gz file.
  # Newer are distribued as .zip so a source build is required.

  # if builded from source
  #src = fetchurl {
  #  url = "https://github.com/OpenGrok/OpenGrok/archive/${version}.tar.gz";
  #  sha256 = "01r7ipnj915rnyxyqrnmjfagkip23q5lx9g787qb7qrnbvgfi118";
  #};

  # binary distribution
  src = fetchurl {
    url = https://github.com/OpenGrok/OpenGrok/files/213268/opengrok-0.12.1.5.tar.gz;
    sha256 = "1bafiq4s9sqldinl6fy931rm0x8zj2magfdlbi3nqlnidsghgkn3";
  };

  buildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out
    cp -a * $out/
    substituteInPlace $out/bin/OpenGrok --replace /bin/uname ${coreutils}/bin/uname
    wrapProgram $out/bin/OpenGrok \
      --prefix PATH : "${stdenv.lib.makeBinPath [ ctags git ]}" \
      --set JAVA_HOME "${jre}" \
      --set OPENGROK_TOMCAT_BASE "/var/tomcat"
  '';

  meta = with stdenv.lib; {
    description = "Source code search and cross reference engine";
    homepage = https://opengrok.github.io/OpenGrok/;
    license = licenses.cddl;
    maintainers = [ maintainers.lethalman ];
  };
}
