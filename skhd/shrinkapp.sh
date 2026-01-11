#!/bin/zsh


# all_names=$(yabai -m query --windows | jq -r '.[].app' | sort -u)
#
# for name in ${all_names}; do
#     arc_window_ids=$(yabai -m query --windows | jq '.[] | select(.app == "$name") | .id')
# space_ids=$(yabai -m query --windows | jq '.[] | select(.app == "$name") | .space')
# min_space=$(echo "$space_ids" | jq -s min)
#
# for id in ${(f)arc_window_ids}; do
#     echo "Window ID: $id"
#     
# yabai -m window $id --space $min_space
# done
# done

#real deal
# #!/bin/zsh
#
# all_names=$(yabai -m query --windows | jq -r '.[].app' | sort -u)
#
#
# arc_window_ids=$(yabai -m query --windows | jq '.[] | select(.app == "Arc") | .id')
# space_ids=$(yabai -m query --windows | jq '.[] | select(.app == "Arc") | .space')
# min_space=$(echo "$space_ids" | jq -s min)
#
# for id in ${(f)arc_window_ids}; do
#     echo "Window ID: $id"
#     
# yabai -m window $id --space $min_space
# done




#!/bin/zsh

# Assign the list of app names to an array
all_names=($(yabai -m query --windows | jq -r '.[].app' | sort -u))

# Iterate over each app name
for name in "${all_names[@]}"; do
    # Query window ids for the current app name
    arc_window_ids=$(yabai -m query --windows | jq ".[] | select(.app | contains(\"$name\")) | .id")
    
    space_ids=$(yabai -m query --windows | jq ".[] | select(.app | contains(\"$name\")) | .space")
min_space=$(echo "$space_ids" | jq -s min)

for id in ${(f)arc_window_ids}; do
    echo "Window ID: $id"
    
yabai -m window $id --space $min_space
done



    # Echo app name and associated window ids
    echo "App Name: $name"
    echo "Window IDs: $arc_window_ids"
    echo "Done"
done

yabai -m query --spaces --display | \
     jq -re 'map(select(."is-native-fullscreen" == false)) | length > 1' \
     && yabai -m query --spaces | \
          jq -re 'map(select(."windows" == [] and ."has-focus" == false).index) | reverse | .[] ' | \
          xargs -I % sh -c 'yabai -m space % --destroy'


#get how many app opened in space 1
yabai -m query --windows | jq '.[] | select(.space == 1) | .app' | wc -l


#if there is more than 1 app opened in space 1, do function
if [ $(yabai -m query --windows | jq '.[] | select(.space == 1) | .app' | wc -l) -gt 1 ]; then
    echo "There are more than 1 app opened in space 1"
    #get all app name other than the first one
    all_names=$(yabai -m query --windows | jq '.[] | select(.space == 1) | .app' | tail -n +2)
    #print all_names
    echo $all_names

    #iterate over all_names
    for name in $all_names; do
        #get window id of the app
        arc_window_ids=$(yabai -m query --windows | jq ".[] | select(.app == \"$name\") | .id")
    done
fi







# # Start an infinite loop
# while true; do
#     echo "This will run indefinitely"
#     # Add any other commands you want to run indefinitely here
# done
