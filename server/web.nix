{ config, pkgs, lib, ... }:

with import ./vars.nix;

{
  services = {
    caddy = {
      enable = true;
      agree = true;
      email = "crazedprogrammer@gmail.com";
      config = ''
        http://cc.crzd.me https://cc.crzd.me {
          root /var/www/cc.crzd.me
          browse /maven
        }
        https://i.crzd.me {
          proxy / localhost:${toString shittydlPort}
        }
        https://lounge.crzd.me {
          proxy / localhost:${toString theloungePort}
        }
        https://grafana.crzd.me {
          proxy / localhost:${toString grafanaPort}
        }
        https://ccemux.crzd.me {
          root /var/www/ccemux.crzd.me

          browse /dist
          redir 302 {
            if {path} is /
            / /dist
          }
        }
      '';
    };
    grafana = {
      enable = true;
      addr = "";
      domain = "grafana.crzd.me";
      rootUrl = "https://grafana.crzd.me/";
      port = grafanaPort;
      analytics.reporting.enable = false;
    };
    prometheus = {
      enable = true;
      listenAddress = ":${toString prometheusPort}";
      scrapeConfigs = [{
        job_name = "node";
        scrape_interval = "5s";
        static_configs = [{
          targets = ["localhost:${toString nodeExporterPort}"];
        }];
      }];
      nodeExporter = {
        enable = true;
        listenAddress = "";
        port = nodeExporterPort;
      };
    };
  };
}
