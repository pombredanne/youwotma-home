#!/bin/sh

# Nautilus preferences
gconftool -t bool /apps/nautilus/preferences/show_desktop -s false
gconftool -t bool /apps/nautilus/preferences/exit_with_last_window -s true
gconftool -t bool /apps/nautilus/preferences/media_automount -s false

#Other
gconftool -t bool /desktop/gnome/background/draw_background false

#gnome-terminal preferences
gconftool -t string /apps/gnome-terminal/profiles/Default/delete_binding -s "escape-sequence"
gconftool -t string /apps/gnome-terminal/profiles/Default/backspace_binding -s "ascii-del"
gconftool -t string /apps/gnome-terminal/profiles/Default/font -s "DejaVu Sans Mono 9"
gconftool -t string /apps/gnome-terminal/profiles/Default/background_type -s "solid"
gconftool -t string /apps/gnome-terminal/profiles/Default/cursor_shape -s "ibeam"
gconftool -t string /apps/gnome-terminal/profiles/Default/visible_name -s "Default"
gconftool -t string /apps/gnome-terminal/profiles/Default/palette -s "#3EDE695858C6:#707050505050:#6060B4B48A8A:#DFDFAFAF8F8F:#9A9AB9B9D7D7:#DCDC8C8CC4C4:#8C8CD1D1D3D3:#DCDCDCDCCDCD:#707090908080:#AD5C00000000:#7272D5D5A2A2:#F0F0DFDFAFAF:#9494C0C0F3F3:#ECEC9393D5D5:#9393E1E1E3E3:#EEEEEEEEECEC"
gconftool -t string /apps/gnome-terminal/profiles/Default/background_color -s "#2C2C2C2C2C2C"
gconftool -t string /apps/gnome-terminal/profiles/Default/foreground_color -s "#DCDCDCDCCDCD"
gconftool -t string /apps/gnome-terminal/profiles/Default/bold_color -s "#000000000000"
gconftool -t bool /apps/gnome-terminal/profiles/Default/alternate_screen_scroll -s true
gconftool -t bool /apps/gnome-terminal/profiles/Default/scrollback_unlimited -s false
gconftool -t bool /apps/gnome-terminal/profiles/Default/default_show_menubar -s false
gconftool -t bool /apps/gnome-terminal/profiles/Default/use_system_font -s false
gconftool -t bool /apps/gnome-terminal/profiles/Default/allow_bold -s true
gconftool -t int /apps/gnome-terminal/profiles/Default/scrollback_lines -s 10000
gconftool -t float /apps/gnome-terminal/profiles/Default/background_darkness -s 0
gconftool -t bool /apps/gnome-terminal/profiles/Default/use_theme_colors -s false
gconftool -t bool /apps/gnome-terminal/profiles/Default/login_shell -s true


