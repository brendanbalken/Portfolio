#!/bin/bash

homeFiles=()
while IFS=  read -r -d $'\0'; do
    homeFiles+=("$REPLY")
done < <(find ~ -name '*.sh' -type f -print0)

for file in $homeFiles
do
	path=$( echo ${file%/*} )
	filename=$( echo ${file##*/} )
	name=${filename%%???}
	eval alias $name=$file
done
