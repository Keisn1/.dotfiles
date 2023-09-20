# Copyright (c) 2010, 2014 dequis
# Copyright (c) 2012 Randall Ma
# Copyright (c) 2012-2014 Tycho Andersen
# Copyright (c) 2012 Craig Barnes
# Copyright (c) 2013 horsik
# Copyright (c) 2013 Tao Sauvage
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

from libqtile import bar, layout, widget
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal
from libqtile import hook, qtile

from libqtile.command.client import CommandClient

import subprocess
from libqtile.command.client import InteractiveCommandClient


mod = "mod4"
terminal = guess_terminal()
# xrandr --output DP-2-2 --primary --mode 1920x1080 --output DP-2-1 --mode 1920x1080 --right-of DP-2-2 --output DP-1 --mode 1920x1200 --left-of DP-2-2

subprocess.run(["setxkbmap", "-option", "ctrl:nocaps"])

# check for number of monitors
st = subprocess.check_output(["xrandr", "--listactivemonitors"], encoding="UTF-8")
num_of_monitors = int(st.split("\n")[0][-1])

if num_of_monitors == 3:
    subprocess.run(["xrandr", "--output", "DP-2", "--rotate", "left"])
    subprocess.run(["xrandr", "--output", "DP-1-1", "--primary", "--mode", "1920x1080"])
    subprocess.run(
        ["xrandr", "--output", "DP-1-2", "--mode", "1920x1080", "--right-of", "DP-1-1"]
    )
    subprocess.run(
        ["xrandr", "--output", "DP-2", "--mode", "1920x1200", "--left-of", "DP-1-1"]
    )


keys = [
    # A list of available commands that can be bound to keys can be found
    # at https://docs.qtile.org/en/latest/manual/config/lazy.html
    # Switch between windows
    Key([mod], "h", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "l", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "j", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "k", lazy.layout.up(), desc="Move focus up"),
    Key([mod], "space", lazy.layout.next(), desc="Move window focus to other window"),
    # Move windows between left/right columns or move up/down in current stack.
    # Moving out of range in Columns layout will create new column.
    Key(
        [mod, "shift"], "h", lazy.layout.shuffle_left(), desc="Move window to the left"
    ),
    Key(
        [mod, "shift"],
        "l",
        lazy.layout.shuffle_right(),
        desc="Move window to the right",
    ),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up(), desc="Move window up"),
    # Grow windows. If current window is on the edge of screen and direction
    # will be to screen edge - window would shrink.
    Key([mod, "control"], "h", lazy.layout.grow_left(), desc="Grow window to the left"),
    Key(
        [mod, "control"], "l", lazy.layout.grow_right(), desc="Grow window to the right"
    ),
    Key([mod, "control"], "j", lazy.layout.grow_down(), desc="Grow window down"),
    Key([mod, "control"], "k", lazy.layout.grow_up(), desc="Grow window up"),
    Key([mod], "n", lazy.layout.normalize(), desc="Reset all window sizes"),
    # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with
    # multiple stack panes
    Key(
        [mod, "shift"],
        "Return",
        lazy.layout.toggle_split(),
        desc="Toggle between split and unsplit sides of stack",
    ),
    Key([mod], "Return", lazy.spawn(terminal), desc="Launch terminal"),
    # Toggle between different layouts as defined below
    Key([mod], "Tab", lazy.next_layout(), desc="Toggle between layouts"),
    Key([mod], "w", lazy.window.kill(), desc="Kill focused window"),
    Key(
        [mod],
        "f",
        lazy.window.toggle_fullscreen(),
        desc="Toggle fullscreen on the focused window",
    ),
    Key(
        [mod],
        "t",
        lazy.window.toggle_floating(),
        desc="Toggle floating on the focused window",
    ),
    Key([mod, "control"], "r", lazy.reload_config(), desc="Reload the config"),
    Key([mod, "control"], "q", lazy.shutdown(), desc="Shutdown Qtile"),
    Key([mod], "r", lazy.spawncmd(), desc="Spawn a command using a prompt widget"),
    Key([mod, "Control"], "n", lazy.prev_screen(), desc="Move to next Screen"),
    Key([mod, "Control"], "p", lazy.next_screen(), desc="Move to next Screen"),
    Key([mod], "1", lazy.to_screen(1), desc="left screen"),
    Key([mod], "2", lazy.to_screen(0), desc="middle screen"),
    Key([mod], "3", lazy.to_screen(2), desc="right screen"),
]


group_names = [
    ("DEV", {"layout": "columns"}, "d"),
    ("WWW", {"layout": "columns"}, "i"),
    ("ORG", {"layout": "columns"}, "o"),
    ("SYS", {"layout": "columns"}, "s"),
    ("VID", {"layout": "columns"}, "v"),
    ("CHAT", {"layout": "columns"}, "c"),
]

groups = [Group(name, **kwargs) for name, kwargs, _ in group_names]


for i, (name, _, key) in enumerate(group_names, 1):
    keys.extend(
        [
            # mod1 + letter of group = switch to group
            Key(
                [mod],
                key,
                lazy.group[name].toscreen(),
                desc="Switch to group {}".format(name),
            ),
            # mod1 + shift + letter of group = switch to & move focused window to group
            # Key(
            #     [mod, "shift"],
            #     str(i),
            #     lazy.window.togroup(name, switch_group=True),
            #     desc="Switch to & move focused window to group {}".format(name),
            # ),
            # Or, use below if you prefer not to switch to that group.
            # # mod1 + shift + letter of group = move focused window to group
            Key(
                [mod, "shift"],
                key,
                lazy.window.togroup(name),
                desc="move focused window to group {}".format(name),
            ),
        ]
    )


layout_theme = {
    "border_focus": "#c792ea",
    "border_normal": "#4c566a",
    "border_width": 2,
    "margin_on_single": 4,
    "margin": 4,
}


layouts = [
    layout.Columns(**layout_theme, border_on_single=True),
    layout.Max(**layout_theme),
    # Try more layouts by unleashing below layouts.
    # layout.Stack(num_stacks=2),
    # layout.Bsp(),
    # layout.Matrix(),
    # layout.MonadTall(**layout_theme),
    # layout.MonadWide(),
    # layout.RatioTile(),
    # layout.Tile()
    # layout.TreeTab(),
    # layout.VerticalTile(),
    # layout.Zoomy(),
]

widget_defaults = dict(
    font="JetBrainsMonoNL Nerd Font",
    fontsize=12,
    padding=3,
)
extension_defaults = widget_defaults.copy()


def get_cur_grp_name():
    client = InteractiveCommandClient()
    return client.group.info()["name"]


date_command = ["/usr/bin/date", "+%a %D"]


def get_date():
    return "📆 " + subprocess.check_output(date_command).decode("utf-8").strip()


def get_time():
    return (
        " ⏰ "
        + subprocess.check_output(["/usr/bin/date", "+%I:%M %p"])
        .decode("utf-8")
        .strip()
    )


def get_datetime():
    return get_date() + get_time()


screens = [
    Screen(
        top=bar.Bar(
            [
                widget.Sep(size_percent=0.05),
                widget.CurrentLayoutIcon(
                    scale=0.9,
                    foreground="EFEFEF",
                ),
                # widget.GenPollText(
                #     func=get_cur_grp_name,
                #     update_interval=0.5,
                #     foreground="EFEFEF",
                #     padding=1,
                # ),
                widget.GroupBox(
                    active="F6F6F6",
                    inactive="968F92",
                    this_current_screen_border="#bc8f8f",
                    this_screen_border="#bc8f8f",
                    highlight_method="default",
                    highlight_color=["1A2024", "060A0F"],
                    fontsize=12,
                    margin=3,
                ),
                widget.Prompt(
                    fontsize=12,
                    cursor_color="FFFFFF",
                    foreground="FDF3A9",
                    background="271B1B",
                ),
                widget.WindowName(
                    foreground="F6F6F6",
                ),
                widget.GenPollText(
                    func=get_datetime,
                    update_interval=1,
                    foreground="F6F6F6",
                ),
                widget.Systray(),
                widget.Sep(size_percent=0.05),
            ],
            28,
            background=["1A2024", "060A0F"],
            opacity=0.90,
        ),
        wallpaper="~/.wallpapers/pexels-eberhard-grossgasteiger-640781.jpg",
        wallpaper_mode="stretch",
    ),
    Screen(
        top=bar.Bar(
            [
                widget.Sep(size_percent=0.05),
                widget.CurrentLayoutIcon(
                    scale=0.9,
                    foreground="EFEFEF",
                ),
                # widget.GenPollText(
                #     func=get_cur_grp_name,
                #     update_interval=0.5,
                #     foreground="EFEFEF",
                #     padding=1,
                # ),
                widget.GroupBox(
                    active="F6F6F6",
                    inactive="968F92",
                    this_current_screen_border="#bc8f8f",
                    this_screen_border="#bc8f8f",
                    highlight_method="default",
                    highlight_color=["1A2024", "060A0F"],
                    fontsize=12,
                    margin=3,
                ),
                widget.Prompt(
                    fontsize=12,
                    cursor_color="FFFFFF",
                    foreground="FDF3A9",
                    background="271B1B",
                ),
                widget.WindowName(
                    foreground="F6F6F6",
                ),
                widget.GenPollText(
                    func=get_datetime,
                    update_interval=1,
                    foreground="F6F6F6",
                ),
                widget.Sep(size_percent=0.05),
            ],
            28,
            background=["1A2024", "060A0F"],
            opacity=0.90,
        ),
        wallpaper="~/.wallpapers/pexels-eberhard-grossgasteiger-1366919.jpg",
        wallpaper_mode="stretch",
        # You can uncomment this variable if you see that on X11 floating resize/moving is laggy
        # By default we handle these events delayed to already improve performance, however your system might still be struggling
        # This variable is set to None (no cap) by default, but you can set it to 60 to indicate that you limit it to 60 events per second
        # x11_drag_polling_rate = 60,
    ),
    Screen(
        top=bar.Bar(
            [
                widget.Sep(size_percent=0.05),
                widget.CurrentLayoutIcon(
                    scale=0.9,
                    foreground="EFEFEF",
                ),
                # widget.GenPollText(
                #     func=get_cur_grp_name,
                #     update_interval=0.5,
                #     foreground="EFEFEF",
                #     padding=1,
                # ),
                widget.GroupBox(
                    active="F6F6F6",
                    inactive="968F92",
                    this_current_screen_border="#bc8f8f",
                    this_screen_border="#bc8f8f",
                    highlight_method="default",
                    highlight_color=["1A2024", "060A0F"],
                    fontsize=12,
                    margin=3,
                ),
                widget.Prompt(
                    fontsize=12,
                    cursor_color="FFFFFF",
                    foreground="FDF3A9",
                    background="271B1B",
                ),
                widget.WindowName(
                    foreground="F6F6F6",
                ),
                widget.GenPollText(
                    func=get_datetime,
                    update_interval=1,
                    foreground="F6F6F6",
                ),
                widget.Sep(size_percent=0.05),
            ],
            28,
            background=["1A2024", "060A0F"],
            opacity=0.90,
        ),
        wallpaper="~/.wallpapers/pexels-eberhard-grossgasteiger-640781.jpg",
        wallpaper_mode="stretch",
    ),
]

# Drag floating layouts.
mouse = [
    Drag(
        [mod],
        "Button1",
        lazy.window.set_position_floating(),
        start=lazy.window.get_position(),
    ),
    Drag(
        [mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()
    ),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: list
follow_mouse_focus = True
bring_front_click = False
floats_kept_above = True
cursor_warp = False
floating_layout = layout.Floating(
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry
    ]
)
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True

# When using the Wayland backend, this can be used to configure input devices.
wl_input_rules = None

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"


@hook.subscribe.startup_once
def startup_once():
    subprocess.run("/home/kaypro/.config/qtile/autostart_once.sh")

    # Set initial groups
    if len(qtile.screens) > 1:
        qtile.groups_map["DEV"].cmd_toscreen(1, toggle=False)
        qtile.groups_map["WWW"].cmd_toscreen(0, toggle=False)
        qtile.groups_map["ORG"].cmd_toscreen(2, toggle=False)


@hook.subscribe.shutdown
def shutdown():
    subprocess.run("/home/kaypro/.config/qtile/shutdown.sh")


if __name__ in ["config", "__main__"]:
    auto_fullscreen = False
