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

for k=1:length(PpID)
    
    GM_path = ['Z:\Data_Processed\MRI_dicomsort\sorted\' PpID{k} '\CovAnalysis\DARTEL\rc1reg_MP2Rage_cleaned_' PpID{k} '.nii'];
    
    if exist(GM_path, 'file')
        GM_paths{w, 1} = GM_path;
        w = w + 1;
    end
        
end



matlabbatch{1}.spm.tools.dartel.warp.images = {GM_paths};
matlabbatch{1}.spm.tools.dartel.warp.settings.template = 'DARTEL';
matlabbatch{1}.spm.tools.dartel.warp.settings.rform = 0;
matlabbatch{1}.spm.tools.dartel.warp.settings.param(1).its = 3;
matlabbatch{1}.spm.tools.dartel.warp.settings.param(1).rparam = [4 2 1e-06];
matlabbatch{1}.spm.tools.dartel.warp.settings.param(1).K = 0;
matlabbatch{1}.spm.tools.dartel.warp.settings.param(1).slam = 16;
matlabbatch{1}.spm.tools.dartel.warp.settings.param(2).its = 3;
matlabbatch{1}.spm.tools.dartel.warp.settings.param(2).rparam = [2 1 1e-06];
matlabbatch{1}.spm.tools.dartel.warp.settings.param(2).K = 0;
matlabbatch{1}.spm.tools.dartel.warp.settings.param(2).slam = 8;
matlabbatch{1}.spm.tools.dartel.warp.settings.param(3).its = 3;
matlabbatch{1}.spm.tools.dartel.warp.settings.param(3).rparam = [1 0.5 1e-06];
matlabbatch{1}.spm.tools.dartel.warp.settings.param(3).K = 1;
matlabbatch{1}.spm.tools.dartel.warp.settings.param(3).slam = 4;
matlabbatch{1}.spm.tools.dartel.warp.settings.param(4).its = 3;
matlabbatch{1}.spm.tools.dartel.warp.settings.param(4).rparam = [0.5 0.25 1e-06];
matlabbatch{1}.spm.tools.dartel.warp.settings.param(4).K = 2;
matlabbatch{1}.spm.tools.dartel.warp.settings.param(4).slam = 2;
matlabbatch{1}.spm.tools.dartel.warp.settings.param(5).its = 3;
matlabbatch{1}.spm.tools.dartel.warp.settings.param(5).rparam = [0.25 0.125 1e-06];
matlabbatch{1}.spm.tools.dartel.warp.settings.param(5).K = 4;
matlabbatch{1}.spm.tools.dartel.warp.settings.param(5).slam = 1;
matlabbatch{1}.spm.tools.dartel.warp.settings.param(6).its = 3;
matlabbatch{1}.spm.tools.dartel.warp.settings.param(6).rparam = [0.25 0.125 1e-06];
matlabbatch{1}.spm.tools.dartel.warp.settings.param(6).K = 6;
matlabbatch{1}.spm.tools.dartel.warp.settings.param(6).slam = 0.5;
matlabbatch{1}.spm.tools.dartel.warp.settings.optim.lmreg = 0.01;
matlabbatch{1}.spm.tools.dartel.warp.settings.optim.cyc = 3;
matlabbatch{1}.spm.tools.dartel.warp.settings.optim.its = 3;

spm_jobman('run',matlabbatch);