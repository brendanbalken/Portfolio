% Localizer 3.0
% Brendan Balken - last edit 11/01/19

addpath(genpath('Z:\Scripts\Plasticity_Scripts\Source_Reconstruction\'))
clear variables
close all
clc


    %% Import landmarks and fiducials
%     Reference:
    ref = 'C:\Users\Kelly Harris\Desktop\3315_4kHzAuditoryTetanization2.csv';
%     Point cloud to be changed:
    points = 'C:\Users\Kelly Harris\Desktop\3315_4kHzAuditoryTetanization.csv';
    
    locations1 = table2cell(readtable(ref));
    locations2 = table2cell(readtable(points));
    
    locations1array = cell2mat(locations1(:,2:4));
    locations2array = cell2mat(locations2(:,2:4));
    
    chanNames1 = locations1(:,1);
    chanLocs1(1:4,1) = [{'NAS'}; {'LPA'}; {'RPA'}; {'OZ'}];
    chanLocs1(1,2:4) = locations1(ismember(chanNames1,'Nas'),2:4);
    chanLocs1(2,2:4) = locations1(ismember(chanNames1,'LPA'),2:4);
    chanLocs1(3,2:4) = locations1(ismember(chanNames1,'RPA'),2:4);
    chanLocs1(4,2:4) = locations1(ismember(chanNames1,'OZ'),2:4);
    fids1 = chanLocs1(1:4,2:4);
    
    chanNames2 = locations2(:,1);
    chanLocs2(1:4,1) = [{'NAS'}; {'LPA'}; {'RPA'}; {'OZ'}];
    chanLocs2(1,2:4) = locations2(ismember(chanNames2,'Nas'),2:4);
    chanLocs2(2,2:4) = locations2(ismember(chanNames2,'LPA'),2:4);
    chanLocs2(3,2:4) = locations2(ismember(chanNames2,'RPA'),2:4);
    chanLocs2(4,2:4) = locations2(ismember(chanNames2,'OZ'),2:4);
    fids2 = chanLocs2(1:4,2:4);
    
    fids1 = cell2mat(fids1);
    fids2 = cell2mat(fids2);
    
    locations1 = pointCloud(cell2mat(locations1(:,2:4)));
    locations2 = pointCloud(cell2mat(locations2(:,2:4)));
    
    
     %% Turn fiducials into point cloud to make them easier to manipulate
    fids2 = pointCloud(fids2);

    %% Define guess matrix for localizing
    x0 = [0,0,0,1,0,0,0]; % [dx, dy, dz, scale, Mx, My, Mz]

    %% Minimize/optimize error of fit
    % (positions will be transformed, scaled, and rotated until rms of distances of fiducials from landmarks are minimized)
    options = optimset('MaxFunEvals',10000);

    for i=1:15 % run the minimzer 5 times, each time setting the previous estimation as the guess for the next
    [Min,fval,exitflag,output] = fminsearch(@(x) fid_rms(fids1,fids2,x), x0, options);
    
    x0 = Min; % set the guess vector to the previous estimation
    end
    
    loc_adj = transform(locations2, Min); % create a matrix with the adjusted (transformed) locations/coordinates
    
    dx = 0;

    % plot the point clouds together for comparison (fiducials should line up
    % with corresponding landmarks and point cloud should look unwarped
    scatter3(locations1array(:,1),locations1array(:,2),locations1array(:,3),'filled','green')
    hold on
    scatter3(loc_adj(:,1),loc_adj(:,2),loc_adj(:,3),'red')
    grid off
    axis equal % set axes equal so that plot is to scale (very important)
    
    
    
    writecell([chanNames2, num2cell(loc_adj)], strrep(points, '.csv', '_registered.csv'), 'FileType', 'spreadsheet')
    

