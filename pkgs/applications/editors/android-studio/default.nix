{ stdenv, callPackage, makeFontsConf, gnome2 }:

let
  mkStudio = opts: callPackage (import ./common.nix opts) {
    fontsConf = makeFontsConf {
      fontDirectories = [];
    };
    inherit (gnome2) GConf gnome_vfs;
  };
  stableVersion = {
    version = "3.2.1.0"; # "Android Studio 3.2.1"
    build = "181.5056338";
    sha256Hash = "117skqjax1xz9plarhdnrw2rwprjpybdc7mx7wggxapyy920vv5r";
  };
  betaVersion = {
    version = "3.3.0.16"; # "Android Studio 3.3 Beta 4"
    build = "182.5114240";
    sha256Hash = "12gzwnlvc1w5lywpdckdgwxy2yrhf0m0fvaljdsis2arw0x9qdh2";
  };
  latestVersion = { # canary & dev
    version = "3.4.0.2"; # "Android Studio 3.4 Canary 3"
    build = "183.5112304";
    sha256Hash = "0dzk4ag1dirfq8l2q91j6hsfyi07wx52qcsmbjb9a2710rlwpdhp";
  };
in rec {
  # Old alias
  preview = beta;

  # Attributes are named by their corresponding release channels

  stable = mkStudio (stableVersion // {
    channel = "stable";
    pname = "android-studio";
  });

  beta = mkStudio (betaVersion // {
    channel = "beta";
    pname = "android-studio-preview";
  });

  dev = mkStudio (latestVersion // {
    channel = "dev";
    pname = "android-studio-dev";
  });

  canary = mkStudio (latestVersion // {
    channel = "canary";
    pname = "android-studio-canary";
  });
}
