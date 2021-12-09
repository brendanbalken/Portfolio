function runNames = checkDicoms(path, saveDinfo)
% Returns a list of protocols contained in a folder full of dicom files
% Written by BJB
% Last Modified 4/1/20
% 
% 
% 
% Input should be a string representing a path to the folder that contains
% dicom files. ex:
% checkDicoms('Z:\Data_Raw\4828\Plasticity_Grant\IMAGING\20180726_090216_4828\20180726_090216_4828\dicoms')
% This folder should contain only dicom files!




if ~exist('path', 'var')
    path = uigetdir;
%     path = fullfile(y, x);
end

if ~path
    error('No path selected.')
end


% Get scan info from DICOM header
dicoms = dir([path '/*']);

runNames = {''};
firstRun = {''};
w = 1;
prevDinfo = struct;

disp('Reading files...')
for k = 3:length(dicoms)
    if (~dicoms(k).isdir)
        dinfo = dicominfo([path '/' dicoms(k).name]);
        if (isempty(dinfo.ProtocolName))
            runName = 'other';
            dinfo.ProtocolName = 'other';
        else
            runName = strrep(strtrim(dinfo.ProtocolName),' ','_');
        end
        if max(contains(runNames,runName))
        else
            firstRun{w,1} = k;
            runNames{w,1} = runName;
            w = w + 1;
            if saveDinfo && ~isequaln(dinfo, prevDinfo)
                jsonName = [dinfo.ProtocolName '.json'];
                % Encode struct as json
                dinfo = strrep(jsonencode(dinfo), ',"', '\n"');
                dinfo = dinfo(2:end-1);
                %Open file
                jsonF = fopen(jsonName, 'w');
                % Write file
                fprintf(jsonF, dinfo);
                % Close file
                fclose(jsonF);
                prevDinfo = dinfo;
            end
        end
    end
    disp(['Reading file ' num2str(k-2) ' out of ' num2str(length(dicoms)-2)]);
end

fprintf('\n')
fprintf(2, '%s\n', runNames{:})
