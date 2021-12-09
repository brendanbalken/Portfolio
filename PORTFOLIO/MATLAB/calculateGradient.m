clear variables
close all
clc

addpath Z:\MatlabSoftwarePackages\spm12


%% Import
V = spm_vol('Z:\Brendan\qT1_t1_mp2rage_sag_p3_iso_UNI_Images.nii');
Y = spm_read_vols(V);
width = 1;



%% Calculate gradient
% [dX, dY, dZ] = gradient(Y);
% 
% dXY = dX .* (abs(dX)>abs(dY)) + dY .* (abs(dX)<abs(dY));
% 
% dXYZ = dXY .* (abs(dXY)>abs(dZ)) + dZ .* (abs(dXY)<abs(dZ));
% 

x = histogram(Y);
[~, y] = max(x.Values);
thresh = x.BinEdges(y);
close gcf


Y(Y<thresh) = NaN;

dXYZ = myGradient(Y, width);


% Y_W = Y;
% Y_region = Y;

% [x, y, z] = size(dXYZ);

% for x=1:x
%     Y(x, :, :) = filter2(fspecial('average',3),reshape(dXYZ(x, :, :), y, z));
%     Y_W(x, :, :) = wiener2(reshape(dXYZ(x, :, :), y, z), [2, 2]);
% end


fname = 'Z:\Brendan\t1_mp2rage_sag_p3_iso_INV2.nii';
inv2= spm_vol(fname);
inv2_fdata = spm_read_vols(inv2);
inv2_fdata = inv2_fdata<75;
inv2.fname = 'Z:\Brendan\noise_mask.nii';

[x, y, z] = size(inv2_fdata);

% for x=1:x
% %     inv2_fdata(x, :, :) = filter2(fspecial('average',3),reshape(inv2_fdata(x, :, :), y, z));
%     inv2_fdata(x, :, :) = wiener2(reshape(inv2_fdata(x, :, :), y, z), [2, 2]);
% end


noise_mask = (-inv2_fdata + max(max(max(inv2_fdata))));


spm_write_vol(inv2, noise_mask);



V.fname = 'Z:\Brendan\gradient_XYZ_abs.nii';
dXYZ = abs(dXYZ);
spm_write_vol(V, dXYZ);


% Region growing using clusters (2 or 3 clusters)







function dXYZ = myGradient(Y, resolution)

[dX, dY, dZ] = gradient(Y, resolution);

dXY = dX .* (abs(dX)>abs(dY)) + dY .* (abs(dX)<abs(dY));

dXYZ = dXY .* (abs(dXY)>abs(dZ)) + dZ .* (abs(dXY)<abs(dZ));


end









% % 
% % abiubauva
% % 
% % 
% % dataThresh = 50;
% % V = spm_vol('Z:\Brendan\gradient_XYZ_abs.nii');
% % [~, XYZmm] = spm_read_vols(V);
% % Y = Y_W;
% % [dimX, dimY, dimZ] = size(Y);
% % Y = Y.*(Y>dataThresh);
% % Y(Y<=0) = NaN;
% % XYZmm = XYZmm';
% % XYZmm(isnan(Y), :) = [];
% % Y = Y(~isnan(Y));
% % ptCloud = pointCloud(XYZmm, 'Intensity', Y(:));
% % pcshow(ptCloud)
% % 
% % minDistance = 0.5;
% % [labels,numClusters] = pcsegdist(ptCloud,minDistance);
% % 
% % pcshow(ptCloud.Location,labels)
% % colormap(hsv(numClusters))
% % title('Point Cloud Clusters')
% % 
% % 
% % %% Background Remove
% % % Threshold INV2 in mricron to get background mask, apply to gradient
% % % Create difference image (unison) between image from previous step and INV2
% % % Smooth this difference image
% % % Take smooth skull mask we just made and brain mask from cat12 output and "i1>200 * i2==0"
% % 
% % 
% % %% Edge extraction
% % % 
% % % [x, y, z] = size(dXYZ);
% % % 
% % % COORD = dXYZ.*0;
% % % 
% % % 
% % % 
% % % for x=1:x
% % %     Y(x, :, :) = filter2(fspecial('average',3),reshape(Y(x, :, :), y, z));
% % %     Y_W(x, :, :) = wiener2(reshape(Y(x, :, :), y, z), [5, 5]);
% % %     for y=1:y
% % %         for z=1:z
% % %             COORD(x, y, z, 1:3) = [x, y, z];
% % %         end
% % %     end
% % % end
% % % 
% % % X = COORD(:, :, :, 1);
% % % Y = COORD(:, :, :, 2);
% % % Z = COORD(:, :, :, 3);
% % % 
% % % V = dXYZ;
% % % 
% % % isovalue = 1;
% % % fv = isosurface(X,Y,Z,V,isovalue);
% % % pcshow(pointCloud(fv.vertices));