#!/bin/bash

read -p 'Please drag and drop the t1 file here >>' t1name

extension=${t1name##*.}

extension=$(echo $t1name | cut -f1 -d".")

t1name_juelich=${t1name%".$extension"}
t1name_juelich=$t1name_juelich"_juelich"

echo $t1name_juelich

exit

flirt -in $FSLDIR/data/atlases/Juelich/Juelich-maxprob-thr0-1mm.nii.gz -ref $t1name -out $t1name"_juelich" -init t1_to_MNI_brain_inverse.mat -applyxfm -interp nearestneighbour

fslmaths 1221_t1_brain_juelich.nii.gz -thr 42 -uthr 42 RACx.nii.gz
fslmaths 1221_t1_brain_juelich.nii.gz -thr 41 -uthr 41 LACx.nii.gz
fslmaths 1221_t1_brain_juelich.nii.gz -thr 41 -uthr 42 ACx.nii.gz