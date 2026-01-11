#!/bin/zsh

# receive input number from user from any where on mac
input_message=$(osascript -e 'tell app "System Events" to display dialog "Enter the space numbers to delete:" default answer ""' -e 'text returned of result')

# Now you can use the variable $input_message in your script
echo "You entered: $input_message"

# store input_message as array 
array=(${=input_message})

# remove duplicate and sort
array=($(printf "%s\n" "${array[@]}" | sort -nu))

#print size of an array
echo "Size of array: ${#array[@]}"

delete_space() {
    # The first argument to the function is the space number
    local space=$1

    #get all pids in specific space
    IFS=$'\n' window_pids=($(yabai -m query --windows --space $space | jq -r '.[].pid'))

    #iterate over pids
    for window_pid in "${window_pids[@]}"; do
        echo "window_pid: $window_pid"
        #if pid is only 1, kill that pid(in else part)
        count_pid=$(yabai -m query --windows | jq "[.[] | select(.pid == ${window_pid})] | length")
        if [ "$count_pid" -gt 1 ]; then
            # yabai -m window --close
            echo "count_pid: $count_pid"
            echo "window_pid: $window_pid"
            pid=$window_pid 
            IFS=$'\n' space_pid=($(yabai -m query --windows | jq -r ".[] | select(.pid == ${pid}) | .space"))

            echo "space_pid: $space_pid"

            #check if all windows of pid are in same space
            all_same=true
            for pid in "${space_pid[@]}"; do
                echo "Current pid: $pid"
                if [ "$pid" != "$space" ]; then
                # there is a window of the same app(pid) in different space, 
                # you can't delete the pid because it'll effect the same app in other spaces.

                    all_same=false
                    break
                fi
            done

            if $all_same; then
                echo "same"
                kill "${window_pid}"
                else
                    echo "not same"
            #get all window ids in specific space
            IFS=$'\n' window_ids=($(yabai -m query --windows --space $space | jq -r '.[].id'))
            echo "window_ids: $window_ids"

            # now you can loop over window_ids array
            for window_id in "${window_ids[@]}"; do
                echo "window_id: $window_id"
                yabai -m window $window_id --close
            done
            fi
        else
            kill "${window_pid}"
        fi
    done
}

#iterate over array
for i in "${array[@]}"
do
    echo "Deleting space $i"
    delete_space $i
done


sleep 0.3
yabai -m query --spaces --display |
    jq -re 'map(select(."is-native-fullscreen" == false)) | length > 1' &&
    yabai -m query --spaces |
    jq -re 'map(select(."windows" == [] and ."has-focus" == false).index) | reverse | .[] ' |
        xargs -I % sh -c 'yabai -m space % --destroy'