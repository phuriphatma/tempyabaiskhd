
#if there is more than 1 app opened in space 1, do function
# if [ $(yabai -m query --windows | jq '.[] | select(.space == 1) | .app' | wc -l) -gt 1 ]; then
#     echo "There are more than 1 app opened in space 1"

#     # Get the list of app names other than the first one to an array
#     # all_names=($(yabai -m query --windows --space 1 | jq -r '.[].app' | sort -u | tail -n +2))
#     IFS=$'\n' all_names=($(yabai -m query --windows --space 1 | jq -r '.[].app' | sort -u | tail -n +2))

#     echo $all_names
#     echo "Number of items in array: ${#all_names[@]}"
#     loop_num=0

#     # Iterate over each app name
#     for name in "${all_names[@]}"; do
#         echo "Loop$loop_num"
#         echo $name
#         # Query window ids for the current app name
#         IFS=$'\n' arc_window_ids=($(yabai -m query --windows --space 1 | jq -r '.[] | select(.app=="'"$name"'") | .id'))

#         # get the index of the current space
#         index=$(yabai -m query --spaces --space | jq ".index")
#         # create new space at the last
#         yabai -m space --create
#         target_index=$((2 + loop_num))
#         echo "target: $target_index"

#         yabai -m space last --move "${target_index}"

#         # yabai -m space --focus "${next_index}"
#         #move window id to index
#         for id in ${arc_window_ids}; do
#             echo $index
#             echo "Window ID: $id"
#             yabai -m window $id --space $target_index
#             echo "move $name to space $target_index"
#         done
#         loop_num=$((loop_num + 1))
#         echo "end loop$loop_num"
#         # echo $arc_window_ids
#         sketchybar --trigger space_windows_change && sketchybar --trigger space_change

#     done
# fi
