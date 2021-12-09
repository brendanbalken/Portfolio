function output = displayLoc(file)

if nargin==0
    [file, folder] = uigetfile('*.csv');  %opens dialog box to get file *for importing single file
    filepath = [folder file];
else
    filepath = file;
end

if file==0
  fprintf('\nOperation cancelled...\n\n')
  return
end


locations = readtable(filepath);

% myFig = figure('NumberTitle', 'off', 'Name', 'Check Electrode Positions', 'Color', [0 0 0]);
% myAxe = axes();
figure
krios = scatter3(locations{:,2}, locations{:,3}, locations{:,4}, 150, 'filled','blue');
% pcshow(pointCloud(locations{:,2:4}), 'MarkerSize', 100);
axis vis3d
grid off
hold on
rotate3d
set(gca,  'Projection', 'perspective', 'Color', 'none','XTickLabel',[],'XTick',[],'YTickLabel',[],'YTick',[], 'ZTick', [], 'ZTickLabel', [], 'box', 'off')
% g = gifti('Z:\Data_Processed\MRI_dicomsort\sorted\MNI\surf_MNI152_T1_0.5mm_001.gii');
% head = patch(myAxe, 'Faces',g.faces,'Vertices',g.vertices);
% set(head,'SpecularExponent', 1, 'SpecularStrength', 1,'FaceColor', 'white', 'FaceAlpha', 0.1, 'FaceLighting', 'gouraud', 'DiffuseStrength', 0, 'BackFaceLighting', 'unlit')


% linkaxes([krios, head])
text(locations{:,2}, locations{:,3}, locations{:,4}, locations{:,1})



end