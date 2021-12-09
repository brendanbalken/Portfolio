#!/bin/bash
# Rename subject files
# This script does not currently support files with more than two file extensions
# This script assumes the file to be renamed begins with a four digit SID (ex: 1221_Pre1_1kHz.cdt)
# This process is irreversible, but the script will attempt to print and/or update a changelog that records all filename changes


#echo
#echo -e "\033[96mWarning! Make sure to change this script before running it! Currently it is configured to change filenames in ./SID/Plasticity_Grant/Aim2/Auditory_Tetanization/1kHzTet \033[0m"
#
#echo
#
#
## Ask user if they're ready to begin
#read -p "Are you ready? (y/n) " -r
#echo
#if [[ ! $REPLY =~ ^[Yy]$ ]]
#then
#    exit 1
#fi



# Finds filepath of script and assigns that value to basename. This is the script's "home directory"
script="$0"
basename="$(dirname $script)"
cd $basename
echo

# Ask user for input to define the names of the image files, mask files, and the folder in which the masks reside. Example inputs: "_fa_dti.nii", "Right_IAC_Masks", "_RIAC.nii" (the subject number for each subject will be added to the beginning of those strings later (ex: 1234_fa_dti.nii)

read -p 'Please drag and drop the file you wish to change the name of into this window and then press enter to continue >>' ex_file

echo

# builds a path to the file (directory only, no name)
d_path=${ex_file%/*}
file_name=${ex_file#"$d_path"}
file_name=${file_name#"/"}
generic_name=${file_name:4}


read -p 'Please type the name you wish to change to - EXCLUDING the subject ID and file extension (ex: "_1000_Pre1") >>' new_file_name
echo


# Defines set of all real integers (|R)
re='^[0-9]+$'


# finds the file extension (or the last one if there are multiple ex: .cdt.dpa)
extension=${generic_name##*.}
# creates a new variable with the extension removed from the end of the file name (if there were two extensions, the other extension still needs to be removed)
generic_name=${generic_name%".$extension"}
# if there is still an extension that has not yet been removed, remove it now and combine the two extensions into a variable "extension"
if [[ $generic_name == *"."* ]]; then
extension2=${generic_name##*.}
extension=".$extension2.$extension"
generic_name=${generic_name%".$extension2"}
else
extension=".$extension"
fi


# Search through current directory for participant folders
for d in */ ; do


    # Find subject id number based on folder name (remove slash from end)
    SID=${d%/}


if [[ ($SID =~ $re) && (-d $d_path) ]] ; then
    # build filepath by searching for it in their folder and subfolders
   # (outputs array name1)
    name1="$SID"
    name1+="$generic_name.*"
  file=()
   while IFS=  read -r -d $'\0'; do
   file+=("$REPLY")
   done < <(find "$d_path" -name "$name1" -print0)

# runs through each file that was found
for i in "${file[@]}"
do
:

    # finds the file extension (or the last one if there are multiple ex: .cdt.dpa)
    extension=${i##*.}
    # creates a new variable with the extension removed from the end of the file name (if there were two extensions, the other extension still needs to be removed)
    filename1=${i%".$extension"}
    # if there is still an extension that has not yet been removed, remove it now and combine the two extensions into a variable "extension"
    if [[ $filename1 == *"."* ]]; then
        extension2=${filename1##*.}
        extension=".$extension2.$extension"
    else
    extension=".$extension"
    fi

    # redefine filename1 in case a second extension was found
    filename1=${i%"$extension"}
    new_file=$d_path/$SID$new_file_name$extension
    old_file=${filename1#"$d_path"}




echo -e "Would you like to rename $d_path\033[1;31m$old_file$extension\033[0m to $d_path\033[96m/$SID$new_file_name$extension\033[0m ???"
read -n1 -r -p "Press [Y] to continue or [S] to skip..." confirm_rename
if [[ $confirm_rename =~ ^[Yy]$ ]]
then
echo -e "Renaming ..."
mv $i $new_file
date=date
echo -e "$i changed to $new_file on $(date)" >> renamer_changelog.csv #log all changes
else
echo
echo -e "\033[43;5mFile skipped ...\033[0m"
fi





done

fi

done



echo
echo -e "\033[1;32mDone!"
echo -e "\033[0m"
echo


