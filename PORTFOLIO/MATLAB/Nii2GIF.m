clear variables
close all
clc

brain = 'Z:\Brendan\My MRI\7729_t1.nii';

gifName = {'Z:\Recruitmenttalk\brain1.gif', 'Z:\Recruitmenttalk\brain2.gif'};

delay = 0;

V = spm_vol(brain);
Y = spm_read_vols(V);

padding = zeros(32, 240, 256);
Y = [padding; Y; padding];

[dimX, dimY, dimZ] = size(Y);

side = figure('NumberTitle', 'off', 'Name', 'Side to Side', 'Color', [0 0 0]);

for k=1:dimX
    image = rot90(reshape(Y(k,:,:), dimY, dimZ));
    imshow(image, [5, 287])
    drawnow
    frame = getframe(findobj('Type', 'figure', 'Name', 'Side to Side'));
    im = frame2im(frame);
    [imind,cm] = rgb2ind(im,256);
    if k == 1
        imwrite(imind,cm,gifName{1},'gif', 'DelayTime', delay, 'Loopcount',inf);
    else
        imwrite(imind,cm,gifName{1},'gif','DelayTime', delay, 'WriteMode','append');
    end
end

close(side)

front = figure('NumberTitle', 'off', 'Name', 'Front to Back', 'Color', [0 0 0]);


for k=dimY:-1:1
    image = rot90(reshape(Y(:,k,:), dimX, dimZ));
    imshow(image, [5, 287])
    drawnow
    frame = getframe(findobj('Type', 'figure', 'Name', 'Front to Back'));
    im = frame2im(frame);
    [imind,cm] = rgb2ind(im,256);
    if k == dimY
        imwrite(imind,cm,gifName{2},'gif', 'DelayTime', delay, 'Loopcount',inf);
    else
        imwrite(imind,cm,gifName{2},'gif','DelayTime', delay,'WriteMode','append');
    end
end

close(front)

