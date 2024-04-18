{ config, pkgs, lib, ... }:

{
  programs.thunderbird = {
    enable = true;

    profiles = {
      saghen = {
        isDefault = true;
        settings = {
          # required for userChrome.css and userContent.css
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
          # allow remote debugging for working on userChrome.css
          "devtools.chrome.enabled" = true;
          "devtools.debugger.remote-enabled" = true;
          "devtools.toolbox.host" = "right";

          "browser.aboutConfig.showWarning" = false;
          "browser.bookmarks.restore_default_bookmarks" = false;
          "browser.contentblocking.category" = "strict";

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
      };
    };
  };

  accounts.email.accounts = {
    saghendev = {
      primary = true;
      address = "saghendev@gmail.com";
      flavor = "gmail.com";
    };
    liamcdyer = {
      address = "liamcdyer@gmail.com";
      flavor = "gmail.com";
    };
    liqwid = {
      address = "liam@liqwid.finance";
      flavor = "gmail.com";
    };
    liam-super = {
      address = "liam@super.fish";
      imap.host = "imap.purelymail.com";
    };
    superlodon-super = {
      address = "superlodon@super.fish";
      imap.host = "imap.purelymail.com";
    };
  };
}
