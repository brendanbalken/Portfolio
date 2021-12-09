#!/bin/bash

mntz.sh

cd /mnt/z/Data_Processed/MRI_dicomsort/sorted


read -p "Please enter sid >> " sid

#for d in */; do

# Find subject id number based on folder name (remove slash from end)
#sid=${d%/}

mkdir /mnt/z/Data_Processed/MRI_dicomsort/sorted/$sid/mri/ROIs/

cd /mnt/z/Data_Processed/MRI_dicomsort/sorted/$sid/mri/

read -p 'Enter COG for '$sid' (or enter s to skip) >> ' cog

if [[ ($cog =~ ^[Ss]$) ]] ;
then

echo "Participant $sid skipped..."

else

bet2 t1_inv2_$sid.nii t1_inv2_brain.nii -c $cog -m

gunzip -f t1_inv2_brain.nii.gz
gunzip -f t1_inv2_brain_mask.nii.gz

fslmaths MP2RAGE_cleaned_$sid.nii -mas t1_inv2_brain_mask.nii MP2RAGE_cleaned_brain_$sid.nii

gunzip -f MP2RAGE_cleaned_brain_$sid.nii.gz

cd /mnt/z/Data_Processed/MRI_dicomsort/sorted/$sid/mri/ROIs

flirt -in /usr/local/fsl/data/standard/MNI152_T1_0.5mm.nii.gz -ref /mnt/z/Data_Processed/MRI_dicomsort/sorted/$sid/mri/MP2Rage_cleaned_$sid.nii -omat /mnt/z/Data_Processed/MRI_dicomsort/sorted/$sid/mri/ROIs/MNI_to_SCS.mat


flirt -in $FSLDIR/data/atlases/Juelich/Juelich-maxprob-thr0-1mm.nii.gz -ref /mnt/z/Data_Processed/MRI_dicomsort/sorted/$sid/mri/MP2Rage_cleaned_$sid.nii -out /mnt/z/Data_Processed/MRI_dicomsort/sorted/$sid/mri/ROIs/juelich_SCS.nii -init /mnt/z/Data_Processed/MRI_dicomsort/sorted/$sid/mri/ROIs/MNI_to_SCS.mat -applyxfm -interp nearestneighbour

gunzip -f /mnt/z/Data_Processed/MRI_dicomsort/sorted/$sid/mri/ROIs/juelich_SCS.nii.gz

fslmaths juelich_SCS.nii -thr 41 -uthr 41 LTE10.nii.gz
fslmaths juelich_SCS.nii -thr 42 -uthr 42 RTE10.nii.gz
fslmaths juelich_SCS.nii -thr 43 -uthr 43 LTE11.nii.gz
fslmaths juelich_SCS.nii -thr 44 -uthr 44 RTE11.nii.gz
fslmaths juelich_SCS.nii -thr 41 -uthr 44 ACx.nii.gz

fslmaths juelich_SCS.nii -thr 81 -uthr 82 PVCx.nii.gz
fslmaths juelich_SCS.nii -thr 81 -uthr 81 LPVCx.nii.gz
fslmaths juelich_SCS.nii -thr 82 -uthr 82 RPVCx.nii.gz

fslmaths RTE11.nii -add RTE10.nii RACx.nii
fslmaths LTE11.nii -add LTE10.nii LACx.nii


fslmaths ACx -thr 1 -bin ACx
fslmaths LACx -thr 1 -bin LACx
fslmaths RACx -thr 1 -bin RACx
fslmaths PVCx -thr 1 -bin PVCx
fslmaths RPVCx -thr 1 -bin RPVCx
fslmaths LPVCx -thr 1 -bin LPVCx

gunzip -f ACx.nii.gz
gunzip -f LACx.nii.gz
gunzip -f RACx.nii.gz
gunzip -f PVCx.nii.gz
gunzip -f RPVCx.nii.gz
gunzip -f LPVCx.nii.gz

rm LTE10.nii.gz
rm RTE10.nii.gz
rm LTE11.nii.gz
rm RTE11.nii.gz
echo $sid

fi

#done

echo 'Done!'
