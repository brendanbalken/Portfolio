#!/bin/bash

script="$0"
basename="$(dirname $script)"

# Defines set of all real integers (|R)
re='^[0-9]+$'

# prepare the T1, get the FSL orientation
read -p "Please enter SID >>  " -r sid



#for d in */; do
#
## Find subject id number based on folder name (remove slash from end)
#SID=${d%/}

t1name=/mnt/z/Data_Processed/MRI_dicomsort/sorted/$sid/t1_mp2rage_sag_p3_iso/t1_mp2rage_sag_p3_iso.nii

echo "Running fslreorient2std..."
fslreorient2std $t1name $t1name
echo "Running fslorient..."
fslorient -forceradiological $t1name
echo "Running fslswapdim..."
fslswapdim $t1name RL PA IS $t1name

# extract the brain
# do this, then check to see if it worked
echo "Extracting brain..."
bet2 $t1name $t1name"_brain"

read -p "Please chose approximate COG of brain in MRIcron and enter those coordinates here in the following format: x y z >>  " -r cog

# has neck, other stuff
# use mricron to find the approximate COG
echo "Enhancing..."
bet2 $t1name $t1name"_brain" -c $cog

# open -a mricron ./$t1name"_brain.nii.gz"
echo "Brain extraction result has been opened for you to check. If this result is unsatisfactory, you can press control+c to terminate this script and run the alternative method."


# get the head surfaces
# need to register the head to MNI head for betsurf
echo "Registering head to MNI head..."
flirt -in $t1name -ref $FSLDIR/data/standard/MNI152_T1_1mm.nii.gz -omat T1_to_MNI_head.mat
# extract the vtk mesh with bet2, use fractional intensity VERY SMALL to not change
echo "Getting head surfaces..."
bet2 $t1name"_brain" $t1name"_brain" -e -f 0.0001
betsurf --t1only -m $t1name $t1name"_brain_mesh.vtk" T1_to_MNI_head.mat $t1name"_headparts"

# get the GM segments
echo "Getting GM segments..."
fast -o $t1name"_brainparts" $t1name"_brain"

# get the ROIs. First register brain to MNI brain, then extract Juelich
echo "Registering brain to MNI brain..."
flirt -in $t1name"_brain" -ref $FSLDIR/data/standard/MNI152_T1_1mm_brain.nii.gz -omat T1_to_MNI_brain.mat
convert_xfm -inverse T1_to_MNI_brain.mat -omat T1_to_MNI_brain_inverse.mat
echo "Extracting Juelich atlas..."
flirt -in $FSLDIR/data/atlases/Juelich/Juelich-maxprob-thr0-1mm.nii.gz -ref $t1name"_brain" -out $t1name"_brain_juelich" -init t1_to_MNI_brain_inverse.mat -applyxfm -interp nearestneighbour

fslmaths 1221_t1_brain_juelich.nii.gz -thr 42 -uthr 42 RACx.nii.gz
fslmaths 1221_t1_brain_juelich.nii.gz -thr 41 -uthr 41 LACx.nii.gz
fslmaths 1221_t1_brain_juelich.nii.gz -thr 41 -uthr 42 ACx.nii.gz



echo "Done!"



#done



