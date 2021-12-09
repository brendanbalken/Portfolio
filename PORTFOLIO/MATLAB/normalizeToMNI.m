function success = normalizeToMNI(inputIM, MATfile)

try
    outputIM = strrep(inputIM, '.nii', '_MNI.nii');

    copyfile(inputIM, outputIM)

    load(MATfile)

    M = mni.affine; % the matrix from the file
    Nii = nifti(inputIM);
    Nii.mat = M;
    Nii.mat_intent = 4;
    create(Nii);

    success = 1;
catch ME
    fprintf(2, 'Failed!\n')
    success = 0;
    
end