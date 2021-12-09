%% Segment and create dartel-imported tissue class images
% BJB
% Written 12/31/19
% Last Modified 12/31/19
% Input images should be cleaned t1 rigidly aligned to mni space

clear variables
close all
clc

PpID=[... 
1221
1408
1647
1820
2185
2199
2624
3080
3148
3392
3481
3748
4408
4437
4691
4863
4983
5257
5415
5445
5462
% 5642 % very large ventricles, outlier
5846
5938
5958
6283
6556
% 6626 % outlier
% 6643 % outlier
6819
7070 
7310
7361
7388
7421
7434
7815
8208
8397
8411
8535
8601
9097
9122
9141
9170
9179
9662
9758
1431 % outlier (big @$$ head - large GM_vol)
2590
2762
2835
3265
3576
3621
3733
3866
3931
4345
4777 % outlier for CAP AMP 110
4951
5348
5539
5755
5860
6135
6143
6185
6438
6627
6928
6956
7159
7213
7301
7316
7591
7742
7999
8399
8718
8828
9092
9437
];

%% Automatic from here

PpID=cellstr(num2str(PpID)); % Make the participant list a cell array of strings

w = 1;

%Initialize and configure (these two lines should always be run before running an spm batch)
spm_jobman('initcfg');
spm('defaults', 'FMRI');

% Create an spm batch to segment and output the dartel imported tissue
% class imagesS
for k=1:length(PpID)
    % Path to this participant's MNI-rigidly-aligned, cleaned t1 (reg_MP2Rage_cleaned)
    mri_path = ['Z:\Data_Processed\MRI_dicomsort\sorted\' PpID{k} '\CovAnalysis\reg_MP2Rage_cleaned_' PpID{k} '.nii'];
    
    if exist(mri_path, 'file')
        
        matlabbatch{w}.spm.spatial.preproc.channel.vols = {mri_path};
        matlabbatch{w}.spm.spatial.preproc.channel.biasreg = 0.001;
        matlabbatch{w}.spm.spatial.preproc.channel.biasfwhm = 60;
        matlabbatch{w}.spm.spatial.preproc.channel.write = [0 0];
        matlabbatch{w}.spm.spatial.preproc.tissue(1).tpm = {'C:\spm12\tpm\TPM.nii,1'};
        matlabbatch{w}.spm.spatial.preproc.tissue(1).ngaus = 1;
        matlabbatch{w}.spm.spatial.preproc.tissue(1).native = [0 1];
        matlabbatch{w}.spm.spatial.preproc.tissue(1).warped = [0 0];
        matlabbatch{w}.spm.spatial.preproc.tissue(2).tpm = {'C:\spm12\tpm\TPM.nii,2'};
        matlabbatch{w}.spm.spatial.preproc.tissue(2).ngaus = 1;
        matlabbatch{w}.spm.spatial.preproc.tissue(2).native = [0 1];
        matlabbatch{w}.spm.spatial.preproc.tissue(2).warped = [0 0];
        matlabbatch{w}.spm.spatial.preproc.tissue(3).tpm = {'C:\spm12\tpm\TPM.nii,3'};
        matlabbatch{w}.spm.spatial.preproc.tissue(3).ngaus = 2;
        matlabbatch{w}.spm.spatial.preproc.tissue(3).native = [0 1];
        matlabbatch{w}.spm.spatial.preproc.tissue(3).warped = [0 0];
        matlabbatch{w}.spm.spatial.preproc.tissue(4).tpm = {'C:\spm12\tpm\TPM.nii,4'};
        matlabbatch{w}.spm.spatial.preproc.tissue(4).ngaus = 3;
        matlabbatch{w}.spm.spatial.preproc.tissue(4).native = [0 1];
        matlabbatch{w}.spm.spatial.preproc.tissue(4).warped = [0 0];
        matlabbatch{w}.spm.spatial.preproc.tissue(5).tpm = {'C:\spm12\tpm\TPM.nii,5'};
        matlabbatch{w}.spm.spatial.preproc.tissue(5).ngaus = 4;
        matlabbatch{w}.spm.spatial.preproc.tissue(5).native = [0 1];
        matlabbatch{w}.spm.spatial.preproc.tissue(5).warped = [0 0];
        matlabbatch{w}.spm.spatial.preproc.tissue(6).tpm = {'C:\spm12\tpm\TPM.nii,6'};
        matlabbatch{w}.spm.spatial.preproc.tissue(6).ngaus = 2;
        matlabbatch{w}.spm.spatial.preproc.tissue(6).native = [0 0];
        matlabbatch{w}.spm.spatial.preproc.tissue(6).warped = [0 0];
        matlabbatch{w}.spm.spatial.preproc.warp.mrf = 1;
        matlabbatch{w}.spm.spatial.preproc.warp.cleanup = 1;
        matlabbatch{w}.spm.spatial.preproc.warp.reg = [0 0.001 0.5 0.05 0.2];
        matlabbatch{w}.spm.spatial.preproc.warp.affreg = 'mni';
        matlabbatch{w}.spm.spatial.preproc.warp.fwhm = 0;
        matlabbatch{w}.spm.spatial.preproc.warp.samp = 3;
        matlabbatch{w}.spm.spatial.preproc.warp.write = [0 0];

        w = w + 1;
    
    end


end

% Run the batch we just created
spm_jobman('run',matlabbatch);


% Move files generated from above batch into seperate folder
for k=1:length(PpID)
    
    mri_path = ['Z:\Data_Processed\MRI_dicomsort\sorted\' PpID{k} '\CovAnalysis\reg_MP2Rage_cleaned_' PpID{k} '.nii'];
    
    if exist(mri_path, 'file')
        mkdir(['Z:\Data_Processed\MRI_dicomsort\sorted\' PpID{k} '\CovAnalysis\DARTEL'])
        try
            movefile(['Z:\Data_Processed\MRI_dicomsort\sorted\' PpID{k} '\CovAnalysis\rc*.nii'], ['Z:\Data_Processed\MRI_dicomsort\sorted\' PpID{k} '\CovAnalysis\DARTEL'])
        catch
            disp(['Skipped ' PpID{k}])
        end
    end
    
end
