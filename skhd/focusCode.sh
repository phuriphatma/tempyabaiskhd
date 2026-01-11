yabai -m window --focus "$(yabai -m query --windows | jq 'map(select(.app == "Code")) | .[0].id')"
