{ ... }:

{
  programs.firefoxNativefy = {
    enable = true;
    apps = {
      todoist = {
        name = "Todoist";
        id = 2;
        url = "https://app.todoist.com/app/today";
        icon = "Todoist";
      };
    };
  };
}
