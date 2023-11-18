#/bin/sh
#  ___    _ _      _   _                 
# |_ _|__| | | ___| |_(_)_ __ ___   ___  
#  | |/ _` | |/ _ \ __| | '_ ` _ \ / _ \ 
#  | | (_| | |  __/ |_| | | | | | |  __/ 
# |___\__,_|_|\___|\__|_|_| |_| |_|\___| 
#                                        
#  
# by Stephan Raabe (2023) 
# ----------------------------------------------------- 

DIR="$HOME/.config/hypr"
source "$DIR"/theme/current.bash

# Colors
bg=${background:1}  fg=${foreground:1}
red=${color1:1}     green=${color2:1}    yellow=${color3:1}
blue=${color4:1}    magenta=${color5:1}  cyan=${color6:1}
alpha='00000000'

timeswaylock=300
timeoff=360

multi_line_string=$(cat <<EOF
swaylock -f 
    \
    `# General` \
    --ignore-empty-password \
    --show-failed-attempts \
    --hide-keyboard-layout \
    --indicator-caps-lock \
    \
    `# Appearance` \
    --color ${bg}E6 \
    --font 'JetBrainsMono Nerd Font' --font-size 18 \
    --image ~/.config/hypr/wallpapers/lockscreen.png \
    --clock --indicator --effect-blur 7x5\
    \
    `# Backspace Key` \
    --key-hl-color ${green} \
    --caps-lock-key-hl-color ${blue} \
    --bs-hl-color ${red} \
    --caps-lock-bs-hl-color ${red} \
    \
    `# Indicator` \
    --indicator-radius 120 \
    --indicator-thickness 10 \
    \
    `# Inside Circle Colors` \
    --inside-color ${alpha} \
    --inside-clear-color ${alpha} \
    --inside-caps-lock-color ${alpha} \
    --inside-ver-color ${blue} \
    --inside-wrong-color ${red} \
    \
    `# Layout Colors` \
    --layout-bg-color ${cyan} \
    --layout-border-color ${cyan} \
    --layout-text-color ${bg} \
    \
    `# Line Colors` \
    --line-color ${bg} \
    --line-clear-color ${red} \
    --line-caps-lock-color ${bg} \
    --line-ver-color ${bg} \
    --line-wrong-color ${bg} \
    \
    `# Ring Colors` \
    --ring-color ${cyan} \
    --ring-clear-color ${bg} \
    --ring-caps-lock-color ${magenta} \
    --ring-ver-color ${blue} \
    --ring-wrong-color ${red} \
    \
    `# Separator Color` \
    --separator-color ${bg} \
    \
    `# Text Colors` \
    --text-color ${fg} \
    --text-clear-color ${fg} \
    --text-caps-lock-color ${fg} \
    --text-ver-color ${bg} \
    --text-wrong-color ${bg}
EOF
)

if [ -f "/usr/bin/swayidle" ]; then
    echo "swayidle is installed."
    swayidle -w timeout $timeswaylock "$(echo $multi_line_string)" timeout $timeoff 'hyprctl dispatch dpms off' resume 'hyprctl dispatch dpms on'
else
    echo "swayidle not installed."
fi;

