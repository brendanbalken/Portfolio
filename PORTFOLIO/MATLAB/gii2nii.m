function Y = gii2nii(giftiFile, referenceNii, niiFilenameOut, voxelSize=1)

g = gifti(giftiFile);

V = spm_vol(referenceNii);
Y = spm_read_vols(V);

V.fname = niiFilenameOut;


giiPtCloud = pointCloud(g.vertices);
giiPtCloud.Location(:, 1) = giiPtCloud.Location(:, 1) - giiPtCloud.XLimits(1);
giiPtCloud.Location(:, 2) = giiPtCloud.Location(:, 2) - giiPtCloud.YLimits(1);
giiPtCloud.Location(:, 3) = giiPtCloud.Location(:, 3) - giiPtCloud.ZLimits(1);

for k=1:length(giiPtCloud.Location)
    coordinates = giiPtCloud(k, :);
    
end



spm_write_vol(V,Y);
