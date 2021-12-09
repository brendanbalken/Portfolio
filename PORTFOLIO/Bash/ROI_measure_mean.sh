#!/bin/bash
# Applies RIAC Mask to FA and dmean MRI image and measures mean intensity of ROI
# Could easily be altered to apply any mask to any image and measure mean intensity of ROI

echo
echo -e "\033[96mWelcome! This script requires two or three files per participant to run.
(1) A binary ROI mask (located here: Z:/Data_Processed/MRI_dicomsort/sorted/????/mri/ROIs/*.nii.gz)
(2,3) an FA image called ****_fa_dti.nii and/or a dmean image called ****_dmean_dti.nii

Note that this script needs to be in the same location as the participant folders that contain the three files listed above.
Wherever that may be it should look something like this for example (these subject numbers are fake examples):
1234
4321
1111
5555

The script should find the requisite files automatically assuming they are all in their respective participant folders or subfolders.
If the script is returning confusing errors, it is likely having trouble finding the files it is looking for. Also, attempting to run this script on the Z drive may result in errors unless you delete the meanD.csv and meanFA.csv files that are there.

All participant folders must be named only with numbers. No symbols or characters. Ex: 7729_2 will be ignored.
If the script finds multiple files named "****_fa_dti.nii" or "****_dmean_dti.nii", then it will run for each one and record the file locations for you to ensure those measurements do not get confused.


When the script is done running, it will write the measurements to two files (one for FA and one for dmean).
If you run the script multiple times, these files will not be overwritten (ie you cannot start over from scratch without deleting these files)
but rather they will be appended. Running the script mutiple times will result in duplicated results which would need to be removed later in excel."

echo


# Ask user if they're ready to begin
read -p "Are you ready? (y/n) " -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    exit 1
fi

read -r -p "Please drag and drop the file you would like to extract ROI data from into this window..." ex_file

ex_file="${ex_file/Z://mnt/z}"
ex_file="$(echo $ex_file | sed 's/\\/\//g')"


ex_PpID=$(echo $ex_file | grep -o '/[!0-9][!0-9][!0-9][!0-9]/')
ex_PpID=${ex_PpID:1:4}


# Finds filepath of script and assigns that value to basename. This is the script's "home directory"
script="$0"
basename="$(dirname $script)"
cd $basename
echo

# If a file with mean values in it already exists in the same place that this script will be writing one (ie if this script has been run before), let the user known and ask if they would like to cancel, append, or overwrite.
if [ -f $basename/meanFA.csv ] ;
then
	# change permisions of data files so that they can be appended (requires user to input password)
        sudo chmod ugo+rwx $basename/meanFA.csv

	read -p "You already have a mean data file. Would you like to overwrite it, append it, or cancel? (o/a/c) " -r oa
		echo

		if [[ ! $oa =~ ^[OoAa]$ ]]
		then
		    exit 1
		fi





fi

echo




PS3='Please choose an ROI: '
options=("ACx" "PVCx" "LACx" "RACx")
select opt in "${options[@]}"
do
case $opt in
"ACx")
echo "You chose ACx..."
mask_name="ACx.nii"
ROI="ACx"
break
;;

"PVCx")
echo "You chose PVCx..."
mask_name="PVCx.nii"
ROI="PVCx"
break
;;
"RACx")
echo "You chose RACx..."
mask_name="RACx.nii"
ROI="RACx"
break
;;
"LACx")
echo "You chose LACx..."
mask_name="LACx.nii"
ROI="LACx"
break
;;
# Use this syntax to add a new option (and make sure to also add the option to the "options" array ex: options=("ACx" "PVCx" "LACx" "RACx" "NEW_OPTION")):
#"NEW_OPTION")
#       echo "You chose NEW_OPTION"
#       mask_name="NEW_OPTION.nii.gz"
#       ROI="ROIname"
#       break
#       ;;

*) echo "invalid option $REPLY";;
esac
done






# Create empty array into which our results will go. These arrays will then be printed to files named meanD.csv and meanFA.csv.
mean_csv=()


# Search through current directory for participant folders
for d in */ ; do

	# Find subject id number based on folder name (remove slash from end)
	SID=${d%/}
	file=${ex_file//$ex_PpID/$SID}



    # do the same for the mask, but look in the mask folder (Right_IAC_Masks)
	mask_path="/mnt/z/Data_Processed/MRI_dicomsort/sorted/$SID/mri/ROIs/"
	


	mask="$mask_path$mask_name"





	# Maybe probably defines set of all real integers (|R)
	re='^[0-9]+$'



    # if subject id is a real number AND the mask is where it should be AND the fa image is where it should be,
    # then calculate mean FA using fslstats based on the fa image and the corresponding mask
	if [[ ($SID =~ $re) && ( -f $mask)  && ( -f $file ) ]] ;	then
		mean=$(fslstats $file -k $mask -m)
		echo -e "\033[1;31m$SID\033[0m mean \033[32m$mean\033[0m"

		# write this subject's mean to a file called meanFA.csv (for this particular ****_fa_dti.nii). If multiple fa's were found, this step will be run again.

		mean_csv+="$SID $mean $ROI\n"
		


		# Else if subject id is real number and fa is where it should be, BUT mask is missing, then tell user that mask is missing
        elif [[ ($SID =~ $re) && ( -f $file) ]] ; then
			echo "$SID skipped due to missing mask"

		# Else if fa is missing
		elif [[ ($SID =~ $re) && ( -f $mask) ]] ; then
			echo "$SID skipped due to missing fa. Please place subject's FA nii in their folder and try again."

		# Otherwise we likely are looking at a folder that is not a participant folder (the masks folder for example)
		else
			echo "$SID skipped due to missing files or not participant folder"

	fi



done

# Write the results out to a file
if [[ $oa =~ ^[Aa]$ ]]; then
echo "Appending mean.csv..."
echo -e $mean_csv >> mean.csv
elif [[ $oa =~ ^[Oo]$ ]]; then
echo "Overwriting mean.csv..."
echo -e $mean_csv > mean.csv
else
echo -e $mean_csv >> mean.csv
fi


echo -e "\033[1;32mDone!\033[0m"

echo
echo

