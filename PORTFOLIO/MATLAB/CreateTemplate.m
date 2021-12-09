%% Step6_CreateTemplate
% Creates Dartel Template
% Author BJB
clear variables
close all hidden
clc

addpath Z:\MatlabSoftwarePackages\spm12



%% Define parameters

% Grant from which to pull images:
% (use '*' option to search all grants)
grant = '*';

% List of PpIDs to include in template

PpIDs = [
1221
1408
1431
1647
1749
1791
1820
1838
2149
2185
2199
2590
2624
2762
2835
3148
3315
3392
3481
3670
3733
3783
3866
3931
4345
4408
4437
4691
4777
4951
5415
5445
5462
5642
5755
5860
5938
5958
6015
6143
6283
6593
6626
6643
6819
6875
6908
6928
7301
7310
7316
7388
7421
7591
7729
7815
7999
8118
8208
8345
8397
8411
8535
8601
8718
9092
9141
9170
9179
9437
9551
9758

];
PpIDs = cellstr(num2str(PpIDs));

% To define a global template (one that includes ALL scans available), set
% to true
runAll = false;


templateName = 'DARTEL';

files = dir(['Z:\Data_Processed\Structural_MRI\*\' grant '\05_cat12segmentation\mri\rp1*.nii']);
PpIDs_all = repmat({''}, numel(files), 2);
for k=1:numel(files)
    file = fullfile(files(k).folder, files(k).name);
    PpID_grant = extractBetween(file, 'Structural_MRI\', '\05_cat12segmentation');
    PpIDs_all(k, :) = strsplit(PpID_grant{:}, '\');
end


if ~runAll
    indices = ismember(PpIDs_all, PpIDs);
    PpIDs = [PpIDs_all(indices(:,1), 1) PpIDs_all(indices(:,1), 2)];
else
    PpIDs = PpIDs_all;
end


rp1s = {''};
rp2s = {''};
for k=1:numel(PpIDs)/2
    PpID = PpIDs{k, 1};
    grant = PpIDs{k, 2};
    rp1s{k} = ['Z:\Data_Processed\Structural_MRI\' PpID '\' grant '\05_cat12segmentation\mri\rp1MNI_BRAIN_clean_t1_mp2rage_sag_p3_iso_UNI_Images_rigid.nii'];
    rp2s{k} = ['Z:\Data_Processed\Structural_MRI\' PpID '\' grant '\05_cat12segmentation\mri\rp2MNI_BRAIN_clean_t1_mp2rage_sag_p3_iso_UNI_Images_rigid.nii'];
end


matlabbatch{1}.spm.tools.dartel.warp.images = {
                                               rp1s'
                                               rp2s'
                                               }';
%% Define Parameters
matlabbatch{1}.spm.tools.dartel.warp.settings.template = templateName;
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



%% Run job - Create Template

spm_jobman('run', matlabbatch)


%% Move result
firstScan = rp1s{1};
[folder, name, ext] = fileparts(firstScan);
movefile([folder '\' templateName '_*' ext], 'Z:\Data_Processed\Structural_MRI\06_DartelGroupTemplate')


%% Warp

clear matlabbatch

u_rp1s = {''};
p1s = {''};
for k=1:numel(PpIDs)/2
    PpID = PpIDs{k, 1};
    grant = PpIDs{k, 2};
    u_rp1s{k} = ['Z:\Data_Processed\Structural_MRI\' PpID '\' grant '\05_cat12segmentation\mri\u_rp1MNI_BRAIN_clean_t1_mp2rage_sag_p3_iso_UNI_Images_rigid_' templateName '.nii'];
    p1s{k} = ['Z:\Data_Processed\Structural_MRI\' PpID '\' grant '\05_cat12segmentation\mri\p1MNI_BRAIN_clean_t1_mp2rage_sag_p3_iso_UNI_Images.nii'];
end

matlabbatch{1}.spm.tools.dartel.crt_warped.flowfields = u_rp1s';
matlabbatch{1}.spm.tools.dartel.crt_warped.images = {
                                                     rp1s'
                                                     }';
matlabbatch{1}.spm.tools.dartel.crt_warped.jactransf = 1;
matlabbatch{1}.spm.tools.dartel.crt_warped.K = 6;
matlabbatch{1}.spm.tools.dartel.crt_warped.interp = 1;


%% Run job - Warp

spm_jobman('run', matlabbatch)



%% For manual use only (leave commented out always):

outDir = 'Z:\Brendan\PLV_VBM\mwrp1\';
mkdir(outDir)
for k=1:numel(p1s)
    PpID = p1s{k}(34:37);
    copyfile(strrep(rp1s{k}, 'rp1', 'mwrp1'), [outDir 'mwrp1MNI_BRAIN_clean_t1_mp2rage_sag_p3_iso_UNI_Images_' PpID '.nii']);
end



% clc
% template = 'Z:\Data_Processed\Structural_MRI\06_DartelGroupTemplate\DARTEL_6.nii';
% for k=1:numel(p1s)
%     PpID = p1s{k}(34:37);
%     if mod(k, 5)==0
%         images = strcat(outDir, 'mwp1MNI_BRAIN_clean_t1_mp2rage_sag_p3_iso_UNI_Images_', PpIDs(k-4:k,1), '.nii');
%         spm_check_registration([template ',1'], images{:})
%         uiwait
%     end
% end

