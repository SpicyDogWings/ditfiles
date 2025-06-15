#!/bin/bash

ROFI_ARGS="-dmenu -p Apagado -i"

declare -A options
options["   Power Off"]="systemctl poweroff"
options["   Reboot"]="systemctl reboot"
options["   Logout"]="systemctl --user exit" # For Hyprland
#options["   Logout"]="hyprctl dispatch exit 0" # For Hyprland
#options[" Lock"]="loginctl lock-session"     # or 'swaylock' if you use it, or 'hyprlock'
#options["󰜉 Hibernate"]="systemctl hibernate"  # Check if hibernate is configured on your system
#options[" Suspend"]="systemctl suspend"

menu_choices=""
for option in "${!options[@]}"; do
  menu_choices+="${option}\n"
done

chosen_option=$(echo -e "${menu_choices%\\n}" | rofi ${ROFI_ARGS})

if [[ -n "$chosen_option" ]]; then
  command_to_execute="${options[$chosen_option]}"
  if [[ -n "$command_to_execute" ]]; then
    eval "$command_to_execute"
  else
    echo "Error: Command not found for $chosen_option" >&2
    exit 1
  fi
else
  exit 0
fi
