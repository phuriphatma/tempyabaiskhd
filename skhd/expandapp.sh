#!/bin/zsh

function update() {
    winSpace1=$(yabai -m query --windows --space 1)
    echo "$winSpace1" | jq 'map(.app) | unique | length | select(. >1) | "more"'
    # app_names=$(cat your_json_file.json | jq 'map(.app) | unique | .[1:] | @tsv')
    other_apps=$(echo "$winSpace1" | jq 'map(.app) | unique | .[1:] | @tsv')
    echo $other_apps
    other_apps2=$(echo "$winSpace1" | jq -r '.[].app' | sort | uniq | tail -n +2)
    echo "$other_apps2"
    # windowid_of_apps2 = $(yabai -m query --windows | jq ".[] | select(.app | contains($other_apps2)) | .id")
    # other_windows2=$(yabai -m query --windows | jq ".[] | select(.app | contains(\"$other_apps2\")) | .id")
    other_apps=$(echo "$winSpace1" | jq -r '.[].app' | sort | uniq | tail -n +2 | jq -sR 'join(",")')
    echo "$other_apps"
    other_windows2=$(yabai -m query --windows | jq --arg apps "$other_apps" '.[] | select(.app | contains($apps)) | .id')
    echo "$other_windows2"

    echo "$other_windows2"
}

update

# # Assign the list of app names to an array
# all_names=($(yabai -m query --windows | jq -r '.[].app' | sort -u))

# # Iterate over each app name
# for name in "${all_names[@]}"; do
#     # Query window ids for the current app name
#     arc_window_ids=$(yabai -m query --windows | jq ".[] | select(.app | contains(\"$name\")) | .id")

#     space_ids=$(yabai -m query --windows | jq ".[] | select(.app | contains(\"$name\")) | .space")
# min_space=$(echo "$space_ids" | jq -s min)

# for id in ${(f)arc_window_ids}; do
#     echo "Window ID: $id"

# yabai -m window $id --space $min_space
# done

#     # Echo app name and associated window ids
#     echo "App Name: $name"
#     echo "Window IDs: $arc_window_ids"
#     echo "Done"
# done

# # yabai -m query --spaces --display | \
# #      jq -re 'map(select(."is-native-fullscreen" == false)) | length > 1' \
# #      && yabai -m query --spaces | \
# #           jq -re 'map(select(."windows" == [] and ."has-focus" == false).index) | reverse | .[] ' | \
# #           xargs -I % sh -c 'yabai -m space % --destroy'
