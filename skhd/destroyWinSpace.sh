#!/bin/zsh
# # yabai -m query --windows --space | jq -r '.[].id' | xargs -I{} yabai -m window {} --close

# # Get the index of the current space
# index=$(yabai -m query --spaces --space | jq ".index")
# # Get the total number of spaces
# total_spaces=$(yabai -m query --spaces | jq 'length')

# #iterate through space except current and delete all windows in the space
# for ((space = 1; space <= total_spaces; space += 1)); do
#     if [ $space -ne $index ]; then
#         echo "Destroying space $space"
#         # yabai -m query --windows --space $space | jq -r '.[].id' | xargs -I{} yabai -m window {} --close
#         kill $(yabai -m query --windows --space $space | jq .pid)
#         # yabai -m space --destroy $space

#         # yabai -m space $space --destroy
#     fi
# done

#!/bin/zsh

# Get the index of the current space
index=$(yabai -m query --spaces --space | jq ".index")
# Get the total number of spaces
total_spaces=$(yabai -m query --spaces | jq 'length')

# Calculate the number of iterations
iterations=$((total_spaces - index))

# window_pid=$(yabai -m query --windows --space $space | jq -r '.[].pid')
# count_pid=$(yabai -m query --windows | jq "[.[] | select(.pid == ${window_pid})] | length")
# if [ "$count_pid" -gt 1 ]; then
#     yabai -m window --close
# else
#     kill "${window_pid}"
# fi

# Iterate through space except current and delete all windows in the space
for ((i = 0; i < iterations; i++)); do
    space=$((index + i + 1))
    echo "Destroying space $space"
    # Get the pids of all windows in the space and kill them
    # yabai -m query --windows --space $space | jq -r '.[].pid' | xargs kill
    # yabai -m space $space --destroy
    # window_pid=$(yabai -m query --windows --space $space | jq -r '.[].pid')
    # echo "window_pid: $window_pid"
    # count_pid=$(yabai -m query --windows | jq "[.[] | select(.pid == ${window_pid})] | length")
    # if [ "$count_pid" -gt 1 ]; then
    #     # yabai -m window --close
    #     kill "${window_pid}"
    # else
    #     kill "${window_pid}"
    # fi
    IFS=$'\n' window_pids=($(yabai -m query --windows --space $space | jq -r '.[].pid'))
    for window_pid in "${window_pids[@]}"; do
        echo "window_pid: $window_pid"
        count_pid=$(yabai -m query --windows | jq "[.[] | select(.pid == ${window_pid})] | length")
        if [ "$count_pid" -gt 1 ]; then
            # yabai -m window --close
            kill "${window_pid}"
        else
            kill "${window_pid}"
        fi
    done
done

# # Iterate through spaces on the left of the current space and delete all windows in the space
# for ((i = 1; i < index; i++)); do
#     echo "Destroying space $i"
#     # Get the pids of all windows in the space and kill them
#     # yabai -m query --windows --space $i | jq -r '.[].pid' | xargs kill
#     # yabai -m space $i --destroy
#     window_pid=$(yabai -m query --windows --space $i | jq -r '.[].pid')
#     echo "window_pid: $window_pid"
#     count_pid=$(yabai -m query --windows | jq "[.[] | select(.pid == ${window_pid})] | length")
#     if [ "$count_pid" -gt 1 ]; then
#         # yabai -m window --close
#         kill "${window_pid}"
#     else
#         kill "${window_pid}"
#     fi
# done

# Iterate through spaces on the left of the current space and delete all windows in the space
for ((i = 1; i < index; i++)); do
    echo "Destroying space $i"
    # Get the pids of all windows in the space and kill them
    IFS=$'\n' window_pids=($(yabai -m query --windows --space $i | jq -r '.[].pid'))
    for window_pid in "${window_pids[@]}"; do
        echo "window_pid: $window_pid"
        count_pid=$(yabai -m query --windows | jq "[.[] | select(.pid == ${window_pid})] | length")
        if [ "$count_pid" -gt 1 ]; then
            # yabai -m window --close
            kill "${window_pid}"
        else
            kill "${window_pid}"
        fi
    done
done

# #iterate through space except current and delete all windows in the space
# for ((space = index + 1; space <= total_spaces; space += 1)); do
#     if [ $space -ne $index ]; then
#         echo "Destroying space $space"
#         # Get the pids of all windows in the space and kill them
#         yabai -m query --windows --space $space | jq -r '.[].pid' | xargs kill
#         yabai -m space $space --destroy
#     fi
# done

sleep 0.05
yabai -m query --spaces --display |
    jq -re 'map(select(."is-native-fullscreen" == false)) | length > 1' &&
    yabai -m query --spaces |
    jq -re 'map(select(."windows" == [] and ."has-focus" == false).index) | reverse | .[] ' |
        xargs -I % sh -c 'yabai -m space % --destroy'

sketchybar --trigger space_windows_change && sketchybar --trigger space_change
