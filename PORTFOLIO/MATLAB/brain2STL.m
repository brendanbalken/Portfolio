

addpath Z:\MatlabSoftwarePackages\spm12

V = spm_vol('Z:\Data_Processed\Structural_MRI\8649\Plasticity\03_cat12skullstrip\BRAIN_t1_mp2rage_sag_p3_iso_UNI_Images.nii');
Y = spm_read_vols(V);

P = double(Y>0);

[X, Y, Z] = find(P);


% where P is indexed result of binary matrix
brainMesh = delaunay([X, Y, Z]);

stlwrite(brainMesh, 'myBrain.stl', 'binary')