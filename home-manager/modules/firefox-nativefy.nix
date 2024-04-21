{ config, lib, pkgs, utils, ... }:
let
  inherit (lib)
    mkEnableOption mkPackageOption mkOption mkIf mkDefault types optionals
    getExe;
  inherit (utils) escapeSystemdExecArgs;
  cfg = config.programs.firefoxNativefy;

  # ports used are offset from a single base port, see https://docs.lizardbyte.dev/projects/sunshine/en/latest/about/advanced_usage.html#port
  generatePorts = port: offsets: map (offset: port + offset) offsets;
  defaultPort = 47989;

  appsFormat = pkgs.formats.json { };
  settingsFormat = pkgs.formats.keyValue { };

  appsFile = appsFormat.generate "apps.json" cfg.applications;
  configFile = settingsFormat.generate "sunshine.conf" cfg.settings;
in {
  options.programs.firefoxNativefy = with types; {
    enable =
      mkEnableOption ''Turn websites into "native" applications with Firefox'';

    apps = mkOption {
      default = { };
      description = "Set of applications to nativefy";
      type = submodule {
        options = {
          name = mkOption {
            type = string;
            default = "Firefox";
            description = "Name of the application";
          };

          url = mkOption {
            type = string;
            default = "https://mozilla.com";
            description = "Url of the website to nativefy";
          };

          icon = mkOption {
            type = string;
            default = "Firefox";
            description =
              "Icon for the desktop entry. Can be an icon name, e.g. firefox, or an absolute path, e.g. /home/user/.local/share/icons/custom.png";
          };

          settings = mkOption {
            type = types.attrsOf (jsonFormat.type // {
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
            type = types.lines;
            default = "";
            description = ''
              Extra preferences to add to {file}`user.js`.
            '';
          };

          userChrome = mkOption {
            type = types.lines;
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
            type = types.lines;
            default = "";
            description = "Custom Firefox user content CSS.";
            example = ''
              /* Hide scrollbar in FF Quantum */
              *{scrollbar-width:none !important}
            '';
          };

          extensions = mkOption {
            type = types.listOf types.package;
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
    };
  };

  config = mkIf cfg.enable {
    # TODO: merge it
    programs.firefox.profiles = builtins.mapAttrs (name: value:
      {

      });
  };
}
