yabai -m window --focus "$(yabai -m query --windows | jq 'map(select(.app == "kitty")) | .[0].id')"
