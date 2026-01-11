#!/bin/zsh
# delete space up to space numbers (example 2 3 for deleting space 2 and 3)

# receive input number from user from any where on mac
input_message=$(osascript -e 'tell app "System Events" to display dialog "Enter the space numbers to delete:" default answer ""' -e 'text returned of result')

# Now you can use the variable $input_message in your script
echo "You entered: $input_message"

# store input_message as array
array=(${=input_message})

#print size of an array
echo "Size of array: ${#array[@]}"