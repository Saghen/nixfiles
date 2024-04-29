{ config, lib, pkgs, utils, ... }:
let
  inherit (lib)
    mkEnableOption mkPackageOption mkOption mkIf mkDefault types optionals
    getExe;
  inherit (utils) escapeSystemdExecArgs;
  cfg = config.programs.firefoxNativefy;
  jsonFormat = pkgs.formats.json { };

  appConfig = with types; {
    options = {
      name = mkOption {
        type = str;
        default = "Firefox";
        description = "Name of the application";
      };

      id = mkOption {
        type = types.ints.unsigned;
        default = 0;
        description = ''
          Profile ID. This should be set to a unique number per profile.
        '';
      };

      url = mkOption {
        type = str;
        default = "https://mozilla.com";
        description = "Url of the website to nativefy";
      };

      icon = mkOption {
        type = str;
        default = "Firefox";
        description =
          "Icon for the desktop entry. Can be an icon name, e.g. firefox, or an absolute path, e.g. /home/user/.local/share/icons/custom.png";
      };

      openLinksInBrowser = mkOption {
        type = bool;
        default = true;
        description = "Open links in the default browser";
      };

      defaultPermissions = {
        camera = mkOption {
          type = bool;
          default = false;
          description = "Allow access to the camera";
        };
        microphone = mkOption {
          type = bool;
          default = false;
          description = "Allow access to the microphone";
        };
        notifications = mkOption {
          type = bool;
          default = false;
          description = "Allow notifications";
        };
        geolocation = mkOption {
          type = bool;
          default = false;
          description = "Allow access to the geolocation";
        };
      };

      settings = mkOption {
        type = attrsOf (jsonFormat.type // {
          description =
            "Firefox preference (int, bool, string, and also attrs, list, float as a JSON string)";
        });
        default = {
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
          "permissions.default.desktop-notification" = 1;
        };
        example = literalExpression ''
          {
            "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
            "permissions.default.desktop-notification" = 1;
          }
        '';
        description = ''
          Attribute set of Firefox preferences.

          Firefox only supports int, bool, and string types for
          preferences, but home-manager will automatically
          convert all other JSON-compatible values into strings.
        '';
      };

      extraConfig = mkOption {
        type = lines;
        default = "";
        description = ''
          Extra preferences to add to {file}`user.js`.
        '';
      };

      useDefaultUserChrome = mkOption {
        type = bool;
        default = true;
        description =
          "Use the default userChrome.css which hides most UI elements";
      };
      userChrome = mkOption {
        type = lines;
        default = "";
        description = "Custom Firefox user chrome CSS.";
        example = ''
          /* Hide tab bar in FF Quantum */
          @-moz-document url("chrome://browser/content/browser.xul") {
            #TabsToolbar {
              visibility: collapse !important;
              margin-bottom: 21px !important;
            }

            #sidebar-box[sidebarcommand="treestyletab_piro_sakura_ne_jp-sidebar-action"] #sidebar-header {
              visibility: collapse !important;
            }
          }
        '';
      };

      userContent = mkOption {
        type = lines;
        default = "";
        description = "Custom Firefox user content CSS.";
        example = ''
          /* Hide scrollbar in FF Quantum */
          *{scrollbar-width:none !important}
        '';
      };

      extensions = mkOption {
        type = listOf package;
        default = [ ];
        example = literalExpression ''
          with pkgs.nur.repos.rycee.firefox-addons; [
            privacy-badger
          ]
        '';
        description = ''
          List of Firefox add-on packages to install for this profile.
          Some pre-packaged add-ons are accessible from the
          [Nix User Repository](https://github.com/nix-community/NUR).
          Once you have NUR installed run

          ```console
          $ nix-env -f '<nixpkgs>' -qaP -A nur.repos.rycee.firefox-addons
          ```

          to list the available Firefox add-ons.

          Note that it is necessary to manually enable these extensions
          inside Firefox after the first installation.
        '';
      };
    };
  };
in {
  options.programs.firefoxNativefy = {
    enable =
      mkEnableOption ''Turn websites into "native" applications with Firefox'';

    apps = mkOption {
      default = { };
      description = "Set of applications to nativefy";
      type = types.attrsOf (types.submodule appConfig);
    };
  };

  config = mkIf cfg.enable {
    programs.firefox.profiles = lib.attrsets.mapAttrs' (name: value:
      let nameDns = lib.toLower (lib.replaceStrings [ " " ] [ "-" ] name);
      in {
        name = "nativefy-${nameDns}";
        value = {
          isDefault = false;
          id = value.id;
          settings = {
            # Allow userChrome and userContent by default
            "toolkit.legacyUserProfileCustomizations.stylesheets" = true;

            # Set default permissions based on cfg.defaultPermissions
            "permissions.default.desktop-notification" =
              if value.defaultPermissions.notifications then 1 else 2;
            "permissions.default.camera" =
              if value.defaultPermissions.camera then 1 else 2;
            "permissions.default.microphone" =
              if value.defaultPermissions.microphone then 1 else 2;
            "permissions.default.geo" =
              if value.defaultPermissions.geolocation then 1 else 2;
          } // value.settings;
          extraConfig = value.extraConfig;
          extensions = value.extensions;

          userChrome = lib.concatStrings [
            (if value.useDefaultUserChrome then
              builtins.readFile ./userChrome.css
            else
              "")
            value.userChrome
          ];
          userContent = value.userContent;
        };
      }) cfg.apps;

    xdg.desktopEntries = lib.attrsets.mapAttrs' (name: value:
      let nameDns = lib.toLower (lib.replaceStrings [ " " ] [ "-" ] name);
      in {
        name = "nativefy-${nameDns}";
        value = {
          type = "Application";
          name = value.name;
          icon = value.icon;
          comment =
            "${value.name}, nativefied from ${value.url} using Firefox Nativefy in Home Manager";
          exec = ''
            ${
              getExe pkgs.firefox
            } --name ${nameDns} --class ${nameDns} --new-instance -P nativefy-${nameDns} -url "${value.url}"'';
          categories = [ "Network" ];
          settings = { StartupWMClass = nameDns; };
        };
      }) cfg.apps;
  };
}
