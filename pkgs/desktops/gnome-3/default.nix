{ pkgs, lib }:

let

  pkgsFun = overrides:
    let
      self = self_ // overrides;
      self_ = with self; {

  overridePackages = f:
    let newself = pkgsFun (f newself self);
    in newself;

  callPackage = pkgs.newScope self;

  # Convert a version to branch (3.26.18 → 3.26)
  # Used for finding packages on GNOME mirrors
  versionBranch = version: builtins.concatStringsSep "." (lib.take 2 (lib.splitString "." version));

  updateScript = callPackage ./update.nix { };

  version = "3.26";
  maintainers = with pkgs.lib.maintainers; [ lethalman jtojnar ];

  corePackages = with gnome3; [
    pkgs.desktop-file-utils
    pkgs.shared-mime-info # for update-mime-database
    glib # for gsettings
    gtk3.out # for gtk-update-icon-cache
    glib-networking gvfs dconf gnome-backgrounds gnome-control-center
    gnome-menus gnome-settings-daemon gnome-shell
    gnome-themes-standard defaultIconTheme gnome-shell-extensions
    pkgs.hicolor-icon-theme
  ];

  optionalPackages = with gnome3; [ baobab eog epiphany evince
    gucharmap nautilus totem vino yelp gnome-bluetooth
    gnome-calculator gnome-contacts gnome-font-viewer gnome-screenshot
    gnome-system-log gnome-system-monitor simple-scan
    gnome-terminal gnome-user-docs evolution file-roller gedit
    gnome-clocks gnome-music gnome-tweak-tool gnome-photos
    nautilus-sendto dconf-editor vinagre gnome-weather gnome-logs
    gnome-maps gnome-characters gnome-calendar accerciser gnome-nettool
    gnome-getting-started-docs gnome-packagekit gnome-software
    gnome-power-manager
  ];

  gamesPackages = with gnome3; [ swell-foop lightsoff iagno
    tali quadrapassel gnome-sudoku aisleriot five-or-more
    four-in-a-row gnome-chess gnome-klotski gnome-mahjongg
    gnome-mines gnome-nibbles gnome-robots gnome-tetravex
    hitori gnome-taquin
  ];

  inherit (pkgs) glib gtk2 webkitgtk gtk3 gtkmm3 libcanberra-gtk2
    clutter clutter-gst clutter-gtk cogl gtkvnc;
  inherit (pkgs.gnome2) ORBit2;
  libsoup = pkgs.libsoup.override { gnomeSupport = true; };
  libchamplain = pkgs.libchamplain.override { libsoup = libsoup; };
  orbit = ORBit2;
  gnome3 = self // { recurseForDerivations = false; };
  gtk = gtk3;
  gtkmm = gtkmm3;
  vala = pkgs.vala_0_38;
  gegl_0_3 = pkgs.gegl_0_3.override { inherit gtk; };

# Simplify the nixos module and gnome packages
  defaultIconTheme = adwaita-icon-theme;

# ISO installer
# installerIso = callPackage ./installer.nix {};

#### Core (http://ftp.acc.umu.se/pub/GNOME/core/)

  adwaita-icon-theme = callPackage ./core/adwaita-icon-theme { };

  baobab = callPackage ./core/baobab { };

  caribou = callPackage ./core/caribou { };

  dconf = callPackage ./core/dconf { };
  dconf-editor = callPackage ./core/dconf-editor { };

  empathy = callPackage ./core/empathy { };

  epiphany = callPackage ./core/epiphany { };

  evince = callPackage ./core/evince { }; # ToDo: dbus would prevent compilation, enable tests

  evolution-data-server = callPackage ./core/evolution-data-server { };

  gconf = callPackage ./core/gconf { };

  geocode-glib = callPackage ./core/geocode-glib { };

  gcr = callPackage ./core/gcr { }; # ToDo: tests fail

  gdm = callPackage ./core/gdm { };

  gjs = callPackage ./core/gjs { };

  glib-networking = pkgs.glib-networking.override {
    inherit gsettings-desktop-schemas;
  };

  gnome-backgrounds = callPackage ./core/gnome-backgrounds { };

  gnome-bluetooth = callPackage ./core/gnome-bluetooth { };

  gnome-contacts = callPackage ./core/gnome-contacts { };

  gnome-control-center = callPackage ./core/gnome-control-center { };

  gnome-calculator = callPackage ./core/gnome-calculator { };

  gnome-common = callPackage ./core/gnome-common { };

  gnome-desktop = callPackage ./core/gnome-desktop { };

  gnome-dictionary = callPackage ./core/gnome-dictionary { };

  gnome-disk-utility = callPackage ./core/gnome-disk-utility { };

  gnome-font-viewer = callPackage ./core/gnome-font-viewer { };

  gnome-menus = callPackage ./core/gnome-menus { };

  gnome-keyring = callPackage ./core/gnome-keyring { };

  libgnome-keyring = callPackage ./core/libgnome-keyring { };

  libgnomekbd = callPackage ./core/libgnomekbd { };

  folks = callPackage ./core/folks { };

  gnome-online-accounts = callPackage ./core/gnome-online-accounts { };

  gnome-online-miners = callPackage ./core/gnome-online-miners { };

  gnome-session = callPackage ./core/gnome-session { };

  gnome-shell = callPackage ./core/gnome-shell { };

  gnome-shell-extensions = callPackage ./core/gnome-shell-extensions { };

  gnome-screenshot = callPackage ./core/gnome-screenshot { };

  gnome-settings-daemon = callPackage ./core/gnome-settings-daemon { };

  gnome-software = callPackage ./core/gnome-software { };

  gnome-system-log = callPackage ./core/gnome-system-log { };

  gnome-system-monitor = callPackage ./core/gnome-system-monitor { };

  gnome-terminal = callPackage ./core/gnome-terminal { };

  gnome-themes-standard = callPackage ./core/gnome-themes-standard { };

  gnome-user-docs = callPackage ./core/gnome-user-docs { };

  gnome-user-share = callPackage ./core/gnome-user-share { };

  grilo = callPackage ./core/grilo { };

  grilo-plugins = callPackage ./core/grilo-plugins { };

  gsettings-desktop-schemas = callPackage ./core/gsettings-desktop-schemas { };

  gsound = callPackage ./core/gsound { };

  gtksourceview = callPackage ./core/gtksourceview { };

  gtksourceviewmm = callPackage ./core/gtksourceviewmm { };

  gucharmap = callPackage ./core/gucharmap { };

  gvfs = pkgs.gvfs.override { gnome = gnome3; gnomeSupport = true; };

  eog = callPackage ./core/eog { };

  libcroco = callPackage ./core/libcroco {};

  libgee = callPackage ./core/libgee { };

  libgepub = callPackage ./core/libgepub { };

  libgdata = callPackage ./core/libgdata { };

  libgxps = callPackage ./core/libgxps { };

  libpeas = callPackage ./core/libpeas {};

  libgweather = callPackage ./core/libgweather { };

  libzapojit = callPackage ./core/libzapojit { };

  mutter = callPackage ./core/mutter { };

  nautilus = callPackage ./core/nautilus { };

  networkmanager-openvpn = pkgs.networkmanager-openvpn.override {
    inherit gnome3;
  };

  networkmanager-pptp = pkgs.networkmanager-pptp.override {
    inherit gnome3;
  };

  networkmanager-vpnc = pkgs.networkmanager-vpnc.override {
    inherit gnome3;
  };

  networkmanager-openconnect = pkgs.networkmanager-openconnect.override {
    inherit gnome3;
  };

  networkmanager-fortisslvpn = pkgs.networkmanager-fortisslvpn.override {
    inherit gnome3;
  };

  networkmanager-l2tp = pkgs.networkmanager-l2tp.override {
    inherit gnome3;
  };

  networkmanager-iodine = pkgs.networkmanager-iodine.override {
    inherit gnome3;
  };

  networkmanagerapplet = pkgs.networkmanagerapplet.override {
    inherit gnome3 gsettings-desktop-schemas glib-networking;
  };

  rest = callPackage ./core/rest { };

  simple-scan = callPackage ./core/simple-scan { };

  sushi = callPackage ./core/sushi { };

  totem = callPackage ./core/totem { };

  totem-pl-parser = callPackage ./core/totem-pl-parser { };

  tracker = callPackage ./core/tracker { };

  tracker-miners = callPackage ./core/tracker-miners { };

  vte = callPackage ./core/vte { };

  vte_290 = callPackage ./core/vte/2.90.nix { };

  vte-ng = callPackage ./core/vte/ng.nix { };

  vino = callPackage ./core/vino { };

  yelp = callPackage ./core/yelp { };

  yelp-xsl = callPackage ./core/yelp-xsl { };

  yelp-tools = callPackage ./core/yelp-tools { };

  zenity = callPackage ./core/zenity { };


#### Apps (http://ftp.acc.umu.se/pub/GNOME/apps/)

  accerciser = callPackage ./apps/accerciser { };

  bijiben = callPackage ./apps/bijiben { };

  cheese = callPackage ./apps/cheese { };

  evolution = callPackage ./apps/evolution { };

  file-roller = callPackage ./apps/file-roller { };

  gedit = callPackage ./apps/gedit { };

  ghex = callPackage ./apps/ghex { };

  glade = callPackage ./apps/glade { };

  gnome-boxes = callPackage ./apps/gnome-boxes { };

  gnome-calendar = callPackage ./apps/gnome-calendar { };

  gnome-characters = callPackage ./apps/gnome-characters { };

  gnome-clocks = callPackage ./apps/gnome-clocks { };

  gnome-documents = callPackage ./apps/gnome-documents { };

  gnome-getting-started-docs = callPackage ./apps/gnome-getting-started-docs { };

  gnome-logs = callPackage ./apps/gnome-logs { };

  gnome-maps = callPackage ./apps/gnome-maps { };

  gnome-music = callPackage ./apps/gnome-music { };

  gnome-nettool = callPackage ./apps/gnome-nettool { };

  gnome-photos = callPackage ./apps/gnome-photos {
    gegl = gegl_0_3;
  };

  gnome-power-manager = callPackage ./apps/gnome-power-manager { };

  gnome-weather = callPackage ./apps/gnome-weather { };

  nautilus-sendto = callPackage ./apps/nautilus-sendto { };

  polari = callPackage ./apps/polari { };

  # scrollkeeper replacement
  rarian = callPackage ./desktop/rarian { };

  seahorse = callPackage ./apps/seahorse { };

  vinagre = callPackage ./apps/vinagre { };

#### Dev http://ftp.gnome.org/pub/GNOME/devtools/

  anjuta = callPackage ./devtools/anjuta { };

  devhelp = callPackage ./devtools/devhelp { };

  gdl = callPackage ./devtools/gdl { };

  gnome-devel-docs = callPackage ./devtools/gnome-devel-docs { };

  nemiver = callPackage ./devtools/nemiver { };

#### Games

  aisleriot = callPackage ./games/aisleriot { };

  five-or-more = callPackage ./games/five-or-more { };

  four-in-a-row = callPackage ./games/four-in-a-row { };

  gnome-chess = callPackage ./games/gnome-chess { };

  gnome-klotski = callPackage ./games/gnome-klotski { };

  gnome-mahjongg = callPackage ./games/gnome-mahjongg { };

  gnome-mines = callPackage ./games/gnome-mines { };

  gnome-nibbles = callPackage ./games/gnome-nibbles { };

  gnome-robots = callPackage ./games/gnome-robots { };

  gnome-sudoku = callPackage ./games/gnome-sudoku { };

  gnome-taquin = callPackage ./games/gnome-taquin { };

  gnome-tetravex = callPackage ./games/gnome-tetravex { };

  hitori = callPackage ./games/hitori { };

  iagno = callPackage ./games/iagno { };

  lightsoff = callPackage ./games/lightsoff { };

  swell-foop = callPackage ./games/swell-foop { };

  tali = callPackage ./games/tali { };

  quadrapassel = callPackage ./games/quadrapassel { };

#### Misc -- other packages on http://ftp.gnome.org/pub/GNOME/sources/

  california = callPackage ./misc/california { };

  geary = callPackage ./misc/geary { };

  gfbgraph = callPackage ./misc/gfbgraph { };

  gitg = callPackage ./misc/gitg { };

  gspell = callPackage ./misc/gspell { };

  libgames-support = callPackage ./misc/libgames-support { };

  libgda = callPackage ./misc/libgda { };

  libgit2-glib = callPackage ./misc/libgit2-glib { };

  libmediaart = callPackage ./misc/libmediaart { };

  gexiv2 = callPackage ./misc/gexiv2 { };

  gnome-tweak-tool = callPackage ./misc/gnome-tweak-tool { };

  gpaste = callPackage ./misc/gpaste { };

  pidgin-im-gnome-shell-extension = callPackage ./misc/pidgin { };

  gtkhtml = callPackage ./misc/gtkhtml { };

  pomodoro = callPackage ./misc/pomodoro { };

  gnome-autoar = callPackage ./misc/gnome-autoar { };

  gnome-video-effects = callPackage ./misc/gnome-video-effects { };

  gnome-packagekit = callPackage ./misc/gnome-packagekit { };

#### Legacy aliases

  evolution_data_server = evolution-data-server; # added 2018-02-25
  geocode_glib = geocode-glib; # added 2018-02-25
  glib_networking = glib-networking; # added 2018-02-25
  gnome_common = gnome-common; # added 2018-02-25
  gnome_control_center = gnome-control-center; # added 2018-02-25
  gnome_desktop = gnome-desktop; # added 2018-02-25
  gnome_keyring = gnome-keyring; # added 2018-02-25
  gnome_online_accounts = gnome-online-accounts; # added 2018-02-25
  gnome_session = gnome-session; # added 2018-02-25
  gnome_settings_daemon = gnome-settings-daemon; # added 2018-02-25
  gnome_shell = gnome-shell; # added 2018-02-25
  gnome_terminal = gnome-terminal; # added 2018-02-25
  gnome_themes_standard = gnome-themes-standard; # added 2018-02-25
  gsettings_desktop_schemas = gsettings-desktop-schemas; # added 2018-02-25
  libcanberra_gtk2 = libcanberra-gtk2; # added 2018-02-25
  libgnome_keyring = libgnome-keyring; # added 2018-02-25
  networkmanager_fortisslvpn = networkmanager-fortisslvpn; # added 2018-02-25
  networkmanager_iodine = networkmanager-iodine; # added 2018-02-25
  networkmanager_l2tp = networkmanager-l2tp; # added 2018-02-25
  networkmanager_openconnect = networkmanager-openconnect; # added 2018-02-25
  networkmanager_openvpn = networkmanager-openvpn; # added 2018-02-25
  networkmanager_pptp = networkmanager-pptp; # added 2018-02-25
  networkmanager_vpnc = networkmanager-vpnc; # added 2018-02-25
  yelp_xsl = yelp-xsl; # added 2018-02-25
  yelp_tools = yelp-tools; # added 2018-02-25

    };
  in self; # pkgsFun

in pkgsFun {}
