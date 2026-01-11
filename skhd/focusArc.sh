yabai -m window --focus "$(yabai -m query --windows | jq 'map(select(.app == "Arc")) | .[0].id')" 
