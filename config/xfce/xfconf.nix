{
  # 0xff50 Home
  # 0xff57 End
  # see https://github.com/novoid/nixos-config/blob/main/homemanager/xfce.nix
  xfwm4 = {
    "general/workspace_count" = 2;
  };
  xfce4-panel = {
    "plugins/plugin-2/grouping" = false;
    "plugins/plugin-7/enable-keyboard-shortcuts" = true;
  };
  xfce4-keyboard-shortcuts = {
    "xfwm4/custom/<Super>Down"   = "tile_down_key";
    "xfwm4/custom/<Super>Up"     = "tile_up_key";
    "xfwm4/custom/<Super>Left"   = "tile_left_key";
    "xfwm4/custom/<Super>Right"  = "tile_right_key";
    # "xfwm4/custom/<Primary>a"    = "";
    # "xfwm4/custom/<Primary>e"    = "";
    "xfwm4/custom/<Super>Return" = "maximize_window_key";
    "xfwm4/custom/<Primary><Alt><Shift>Left"  = "move_window_prev_workspace_key";
    "xfwm4/custom/<Primary><Alt><Shift>Right" = "move_window_next_workspace_key";
  };
  keyboard-layout = {
    "Default/XkbLayout"  = "us,th";
    "Default/XkbVariant" = "altgr-intl,";
    "Default/XkbDisable" = false;
    "Default/XkbOptions/Group" = "grp:win_space_toggle";
  };
  pointers = {
    "SynPS2_Synaptics_TouchPad/Properties/Device_Enabled" = 0;
  };
  xsettings = {
    "Net/ThemeName" = "Zukitre-dark";
  };
}
