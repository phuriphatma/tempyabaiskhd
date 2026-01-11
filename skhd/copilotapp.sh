#!/bin/zsh

#get how many app opened in space 1
# yabai -m query --windows | jq '.[] | select(.space == 1) | .app' | wc -l

# Get the total number of spaces
total_spaces=$(yabai -m query --spaces | jq 'length')

total_moved=0
apps_moved=0

function move_apps_to_new_spaces {
    # The first argument to the function is the space number
    local space_number=$1

    # Get the list of app names other than the first one to an array
    IFS=$'\n' all_names=($(yabai -m query --windows --space $space_number | jq -r '.[].app' | sort -u | tail -n +2))

    echo $all_names
    echo "Number of items in array: ${#all_names[@]}"
    # apps_moved+=${#all_names[@]}
    # apps_moved=$(($apps_moved + ${#all_names[@]}))
    apps_moved=${#all_names[@]}
    total_moved=$((total_moved + apps_moved))

    echo "app_moved += ${#all_names[@]}"
    echo "inside apps_moved: $apps_moved"
    loop_num=0

    # Iterate over each app name
    for name in "${all_names[@]}"; do
        echo "Loop$loop_num"
        echo $name
        # Query window ids for the current app name
        IFS=$'\n' arc_window_ids=($(yabai -m query --windows --space $space_number | jq -r '.[] | select(.app=="'"$name"'") | .id'))

        # get the index of the current space
        index=$(yabai -m query --spaces --space | jq ".index")
        # create new space at the last
        yabai -m space --create
        next_index=$((2 + loop_num))
        target_index=$((2 + loop_num + $space_number - 1))
        echo "target: $target_index"

        yabai -m space last --move "${target_index}"

        #move window id to index
        for id in ${arc_window_ids}; do
            echo $index
            echo "Window ID: $id"
            yabai -m window $id --space $target_index
            echo "move $name to space $target_index"
        done
        loop_num=$((loop_num + 1))
        echo "end loop$loop_num"
        sketchybar --trigger space_windows_change && sketchybar --trigger space_change
    done
}

# Iterate over each space
for ((space = 1; space <= total_spaces + total_moved; space += 1 + apps_moved)); do
    # Check if there are more than 1 app opened in this space
    apps_moved=0

    echo "\nCheckSpace $space\n"
    #create an array to store space that has more than 1 app
    if [ $(yabai -m query --windows | jq '.[] | select(.space == '"$space"') | .app' | wc -l) -gt 1 ]; then
        echo "There are more than 1 app opened in space $space"
        echo "total_spaces: $total_spaces"
        echo "space: $space"

        # Add the space number to the array
        spaces_with_multiple_apps+=($space)
        echo "spaces_with_multiple_apps: $spaces_with_multiple_apps"

        move_apps_to_new_spaces $space
        echo "app_moved: $apps_moved"
    else
        echo "There is 1 or no app opened in space $space"
    fi
    echo "end space: $space"
    echo "Don't more then $total_spaces + $apps_moved"
done

sketchybar --trigger space_windows_change && sketchybar --trigger space_change

# yabai -m query --spaces --display | \
#      jq -re 'map(select(."is-native-fullscreen" == false)) | length > 1' \
#      && yabai -m query --spaces | \
#           jq -re 'map(select(."windows" == [] and ."has-focus" == false).index) | reverse | .[] ' | \
#           xargs -I % sh -c 'yabai -m space % --destroy'