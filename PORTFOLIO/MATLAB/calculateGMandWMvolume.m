
GM = dir('Z:\Data_Processed\Structural_MRI\*\*\05_cat12segmentation\mri\p1MNI_BRAIN_clean_t1_mp2rage_sag_p3_iso_UNI_Images.nii');
GM = strcat({GM.folder}', '\', {GM.name}');



WM = dir('Z:\Data_Processed\Structural_MRI\*\*\05_cat12segmentation\mri\p2MNI_BRAIN_clean_t1_mp2rage_sag_p3_iso_UNI_Images.nii');
WM = strcat({WM.folder}', '\', {WM.name}');

PpIDs = cell(numel(GM), 1);
grant = cell(numel(WM), 1);


for k=1:numel(GM)
    
    temp = split(extractBetween(GM{k}, 'Structural_MRI\', '\05'), '\');
    PpIDs{k} = temp{1};
    grant{k} = temp{2};
    
    GM{k} = get_totals_bvol(GM{k});
    WM{k} = get_totals_bvol(WM{k});
    
end


myData = cell2table([PpIDs, grant, GM, WM]);

myData.Properties.VariableNames = {'PpID', 'Grant', 'GM', 'WM'};

writetable(myData, 'Z:\Data_Processed\Structural_MRI\metrics.xlsx')