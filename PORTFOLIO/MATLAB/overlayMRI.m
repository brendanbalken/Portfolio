close all
clear variables
clc

PpIDs = [
1221
1791
1838
2066
2149
2624
2762
2835
3284
3315
3392
3481
3530
3670
3733
4345
4437
4951
5415
5642
5860
5938
6101
6143
6283
6875
7310
7316
7388
7591
7729
7742
7999
8397
8535
8892
9104
9170
9179
9388
9758
];

PpIDs = cellstr(num2str(PpIDs));

addpath('C:\spm12')

for xx = 1:numel(PpIDs)

    PpID = PpIDs{xx};
    close all
    pic = figure('Name', PpID);

    filepath1 = ['C:\DATA\CISS\segmented\br' PpID '.nii'];
    filepath2 = ['C:\DATA\CISS\segmented\p1br' PpID '.nii'];
    filepath3 = ['C:\DATA\CISS\segmented\p2br' PpID '.nii'];

    V1 = spm_vol(filepath1);
    Y1 = spm_read_vols(V1);

    V2 = spm_vol(filepath2);
    Y2 = spm_read_vols(V2);
    Y2 = Y2>0;
    
    V3 = spm_vol(filepath3);
    Y3 = spm_read_vols(V3);
    Y3 = Y3>0;


%     for k = 1:182
%         image1 = imrotate(squeeze(Y1(k,:,:)), 90);
%         image2 = imrotate(squeeze(Y2(k,:,:)), 90);
%         image3 = imrotate(squeeze(Y3(k,:,:)), 90);
    for k = 1:218
        image1 = imrotate(squeeze(Y1(:,k,:)), 90);
        image2 = imrotate(squeeze(Y2(:,k,:)), 90);
        image3 = imrotate(squeeze(Y3(:,k,:)), 90);

        if sum(sum(image1)) == 0
            continue
        end
        
        C = gray;
        L = size(C,1);
        Gs = round(interp1(linspace(min(image1(:)),max(image1(:)),L),1:L,image1));
        image1 = reshape(C(Gs,:),[size(Gs) 3]);
        image2 = repmat(double(image2),[1,1,3]);
        image2(:,:,2) = image2(:,:,1).*(-1);
        image2(:,:,3) = image2(:,:,1).*(-1);
        image3 = repmat(double(image3),[1,1,3]);
        image3(:,:,1) = image3(:,:,3).*(-1);
        image3(:,:,2) = image3(:,:,3).*(-1);
        compImage = image1 + image2 + image3;

        compImage(compImage>1) = 1;
        compImage(compImage<0) = 0;


        imshow(compImage, 'InitialMagnification', 1000)
    end
end

close all