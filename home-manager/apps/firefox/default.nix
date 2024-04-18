{ config, pkgs, lib, ... }:

{
  home = {
    sessionVariables = { BROWSER = "firefox-developer-edition -p saghen"; };
  };

  programs.firefox = {
    enable = true;

    package = pkgs.firefox-devedition-bin;

    profiles = {
      saghen = {
        settings = {
          # required for userChrome.css and userContent.css
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;

          "browser.aboutConfig.showWarning" = false;
          "browser.bookmarks.restore_default_bookmarks" = false;
          "browser.contentblocking.category" = "strict";
          "browser.newtabpage.activity-stream.feeds.section.highlights" = true;
          "browser.newtabpage.activity-stream.section.highlights.includePocket" =
            false;
          "browser.newtabpage.activity-stream.showSponsored" = false;
          "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;

          "devtools.chrome.enabled" = true;
          "devtools.debugger.remote-enabled" = true;
          "devtools.toolbox.host" = "right";

          "layout.frame_rate" = 144;

          "privacy.annotate_channels.strict_list.enabled" = true;
          "privacy.donottrackheader.enabled" = true;
          "privacy.fingerprintingProtection" = true;
          "privacy.globalprivacycontrol.enabled" = true;
          "privacy.query_stripping.enabled" = true;
          "privacy.query_stripping.enabled.pbmode" = true;
          "privacy.trackingprotection.enabled" = true;
          "privacy.trackingprotection.emailtracking.enabled" = true;
          "privacy.trackingprotection.socialtracking.enabled" = true;
          "privacy.userContext.enabled" = true;
          "privacy.userContext.ui.enabled" = true;

          "services.sync.prefs.sync-seen.browser.newtabpage.pinned" = true;
          "dom.forms.autocomplete.formautofill" = true;
          "media.ffmpeg.vaapi.enabled" = true;
          "network.dns.disablePrefetch" = false;
          "network.predictor.enabled" = true;
          "network.prefetch-next" = true;
        };

        userChrome = builtins.readFile ./userChrome.css;
        userContent = builtins.readFile ./userContent.css;

        search = {
          force = true;
          default = "Kagi";
          order = [
            "Kagi"
            "DuckDuckGo"
            "NixOS Wiki"
            "Nix Packages"
            "Nix Options"
            "Home Manager"
            "Arch Wiki"
            "Arch Packages"
            "AUR"
            "NPM"
          ];
          engines = let updateInterval = 24 * 60 * 60 * 1000; # every day
          in {
            "Kagi" = {
              urls = [
                { template = "https://kagi.com/search?q={searchTerms}"; }
                {
                  template = "https://kagi.com/api/autosuggest?q={searchTerms}";
                  type = "application/x-suggestions+json";
                }
              ];
              iconUpdateURL = "https://assets.kagi.com/v2/favicon-32x32.png";
              updateInterval = updateInterval;
              definedAliases = [ "@kagi" "@k" ];
            };
            "NixOS Wiki" = {
              urls = [{
                template = "https://nixos.wiki/index.php?search={searchTerms}";
              }];
              iconUpdateURL = "https://nixos.wiki/favicon.png";
              updateInterval = updateInterval;
              definedAliases = [ "nw" ];
            };
            "Nix Packages" = {
              urls = [{
                template = "https://search.nixos.org/packages";
                params = [
                  {
                    name = "type";
                    value = "packages";
                  }
                  {
                    name = "channel";
                    value = "unstable";
                  }
                  {
                    name = "query";
                    value = "{searchTerms}";
                  }
                ];
              }];
              icon =
                "''${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = [ "np" ];
            };
            "Nix Options" = {
              urls = [{
                template = "https://search.nixos.org/options";
                params = [
                  {
                    name = "type";
                    value = "packages";
                  }
                  {
                    name = "channel";
                    value = "unstable";
                  }
                  {
                    name = "query";
                    value = "{searchTerms}";
                  }
                ];
              }];
              icon =
                "''${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = [ "no" ];
            };
            "Noogle" = {
              urls = [{
                template = "https://noogle.dev/q";
                params = [{
                  name = "term";
                  value = "{searchTerms}";
                }];
              }];
              icon =
                "''${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = [ "nx" ];
            };
            "Home Manager" = {
              urls = [{
                template =
                  "https://home-manager-options.extranix.com/home-manager-option-search/?query={searchTerms}";
              }];
              iconUpdateURL =
                "https://home-manager-options.extranix.com/home-manager-option-search/images/favicon.png";
              updateInterval = updateInterval;
              definedAliases = [ "hm" ];
            };
            "Arch Wiki" = {
              urls = [{
                template =
                  "https://wiki.archlinux.org/index.php?search={searchTerms}";
              }];
              iconUpdateURL = "https://wiki.archlinux.org/favicon.ico";
              updateInterval = updateInterval;
              definedAliases = [ "aw" ];
            };
            "AUR" = {
              urls = [{
                template =
                  "https://aur.archlinux.org/packages?O=0&K={searchTerms}";
              }];
              iconUpdateURL =
                "https://aur.archlinux.org/static/images/favicon.ico";
              updateInterval = updateInterval;
              definedAliases = [ "aur" ];
            };
            "NPM" = {
              urls =
                [{ template = "https://www.npmjs.com/package/{searchTerms}"; }];
              iconUpdateURL =
                "https://static-production.npmjs.com/b0f1a8318363185cc2ea6a40ac23eeb2.png";
              updateInterval = updateInterval;
              definedAliases = [ "npm" ];
            };
          };
        };
      };
    };
  };

  xdg.mimeApps.defaultApplications =
    let firefox = "firefox-developer-edition.desktop";

    in {
      "text/html" = [ firefox ];
      "text/xml" = [ firefox ];
      "x-scheme-handler/http" = [ firefox ];
      "x-scheme-handler/https" = [ firefox ];

      "application/pdf" = [ firefox ];
      "x-scheme-handler/about" = [ firefox ];
      "x-scheme-handler/unknown" = [ firefox ];
      "x-scheme-handler/webcal" = [ firefox ];
    };
}
