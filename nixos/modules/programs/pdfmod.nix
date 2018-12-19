{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.pdfmod;
in {
  options.programs.pdfmod.enable = mkEnableOption ''
    pdfmod - a simple application for modifying PDF documents
  '';

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ pdfmod gnome2.GConf ];
  };
}
