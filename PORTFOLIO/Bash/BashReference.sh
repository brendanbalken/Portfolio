#!/bin/bash

# Bash Reference

# General cheatsheet!
https://devhints.io/bash


# For loop

for VARIABLE in file1 file2 file3
do
	command1 on $VARIABLE
	command2
	commandN
done


# If statement

if ! [ -d "/mnt/z" ]; # if directory exists (-f for file)
then
sudo mkdir /mnt/z
fi


# Array operations

# arr=() 	Create an empty array
# arr=(1 2 3) 	Initialize array
# ${arr[2]} 	Retrieve third element
# ${arr[@]} 	Retrieve all elements
# ${!arr[@]} 	Retrieve array indices
# ${#arr[@]} 	Calculate array size
# arr[0]=3 	Overwrite 1st element
# arr+=(4) 	Append value(s)
# str=$(ls) 	Save ls output as a string
# arr=( $(ls) ) 	Save ls output as an array of files
# ${arr[@]:s:n} 	Retrieve n elements starting at index s


# Find files (put in array not string)

# All files under ~ (home) (recursive)
homeFiles=()
while IFS=  read -r -d $'\0'; do
    homeFiles+=("$REPLY")
done < <(find ~ -type f -print0)

# Find all csv files in current directory
array=()
while IFS=  read -r -d $'\0'; do
    array+=("$REPLY")
done < <(find . -name "*.csv" -print0)

# Index first value
echo ${array[0]}


# String manipulation

# Split path and filename
p=/foo/bar/file1
path=$( echo ${p%/*} )
file=$( echo ${p##*/} )

# Cheat sheet!
https://gist.github.com/magnetikonline/90d6fe30fc247ef110a1


# File Reading
# Read last line of file
tag=$( tail -n 1 history.txt )

