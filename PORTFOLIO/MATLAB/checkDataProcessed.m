% Run checkDataRaw.m
addpath Z:\Data_Raw
checkDataRaw

% Initialize
clc
clear variables

%% Set parameters

filename = 'Z:\Data_Processed\Plasticity_Grant\Processed_Summary.xlsx'; % where to save excel sheet

tasks = {
    'CAP_IO'
    'N1P2_IO'
    'AuditoryTetanization1kHz'
    'AuditoryTetanization4kHz'
    'VisualTetanization'
    'Structural_MRI'
};

paths = {
    'Z:\Data_Processed\Plasticity_Grant\Aim_1\PlasticityN1P2_IO\####'
    'Z:\Data_Processed\Plasticity_Grant\Aim_1\PlasticityCAP_IO\####'
    'Z:\Data_Processed\Plasticity_Grant\Aim_2\Auditory_Tetanization\Tetanize_1kHz\####'
    'Z:\Data_Processed\Plasticity_Grant\Aim_2\Auditory_Tetanization\Tetanize_4kHz\####'
    'Z:\Data_Processed\Plasticity_Grant\Aim_2\Visual_Tetanization\####'
    'Z:\Data_Processed\Structural_MRI\####'
};

PpIDsToIgnore = {
    '0000'
    '9999'
};





%% Automatic from here

T = cell2table(cell(1,numel(tasks)));
T.Properties.VariableNames = tasks;

if exist(filename, 'file')
    fileattrib(filename, '+w') % make writable
end

[fid, msg] = fopen(filename,'a');


if fid==-1 && exist(filename, 'file')
    fprintf(2, 'Summary sheet located here:\n%s\n', 'Z:\Data_Processed\Plasticity_Grant\Summary.xlsx')
    error('Summary sheet is open! Close it to run this script!')
else
    fclose(fid);
end

NEED_TO_RUN = array2table(nan(100, numel(tasks)));
NEED_TO_RUN.Properties.VariableNames = tasks;



for X=1:numel(tasks)
    
    task = tasks{X};
    path = paths{X};
    
    excludeFromNEED2BERUN = readtable('Z:\Data_Processed\Plasticity_Grant\manuallyMarkedComplete.xlsx', 'Sheet', task);
    
    cd Z:\Data_Raw % to get list of all PpIDs
    
    FOLDERS = dir(); % List all items in this directory
    FOLDERS = FOLDERS([FOLDERS.isdir]); % Remove non-folder items from list
    
    FOLDERS(strcmp({FOLDERS.name}, '.')) = []; % Delete the "." (present dir) entry from list
    FOLDERS(strcmp({FOLDERS.name}, '..')) = []; % Delete the ".." (parent dir) entry from list
    
    FOLDERS = {FOLDERS.name}'; % Transpose list into a more readable orientation
    
    digits = regexp(FOLDERS, '\d\d\d\d'); % Filter list looking for any folders named something with 4 numerical digits (ex: 7729 or 1234)
    
    PpIDs = FOLDERS(~cellfun(@isempty, digits)); % Pull out non-empty list entries. This is our paripant ID list!
    
    % Initialize
    w = 1;
    
    if strcmp(task, 'CAP_IO')
        headers = {'PpID', 'CleanData'};
    elseif strcmp(task, 'Structural_MRI')
        headers = {'PpID', 'raw','T1est_clean','cat12skullstrip','reslicetoMNI','cat12segmentation'};
    else
        headers = {'PpID', 'Step1_ICA', 'Step2_TF', 'Step3_ERP'};
    end
    
    temp_table = array2table(nan(numel(PpIDs), 1));
    temp_table.Properties.VariableNames = {'PpID'}; % to avoid stupid matlab error
    PpIDs_processed = [temp_table, cell2table(cell(numel(PpIDs), numel(headers)-1))];
    PpIDs_processed.Properties.VariableNames = headers;
    
    
    
    for k=1:length(PpIDs)
        PpID = PpIDs{k};
        if ismember(PpID, PpIDsToIgnore)
            continue
        end
        
        taskFolder = strrep(path, '####', PpID);
        if exist(taskFolder, 'dir') || exist(strrep(path, '####', ['Tetanize_1kHz\' PpID]), 'dir') || exist(strrep(path, '####', ['Tetanize_4kHz\' PpID]), 'dir')
            folderCheck = dir(taskFolder);
            folderCheck(strcmp({folderCheck.name}, '.')) = [];
            folderCheck(strcmp({folderCheck.name}, '..')) = [];
            if ~isempty(folderCheck)
                PpIDs_processed.PpID(w) = str2double(PpID);
                switch task
                    case 'CAP_IO'
                        numBlocks = 3; % (stims not blocks)
                        timeseries_output = dir(strrep('Z:\Data_Processed\Plasticity_Grant\Aim_1\PlasticityCAP_IO\####\*\*timeseries.docx', '####', PpID));
                    case 'N1P2_IO'
                        numBlocks = 12;
                        ICA_output = dir(strrep('Z:\Data_Processed\Plasticity_Grant\Aim_1\PlasticityN1P2_IO\####\CleanedDataOnly_bothfreqs\*cleaned.set', '####', PpID));
                        TF_output = dir(strrep('Z:\Data_Processed\Plasticity_Grant\Aim_1\PlasticityN1P2_IO\####\*\*\*TFanalysis_cleaned.set', '####', PpID));
                        ERP_output = dir(strrep('Z:\Data_Processed\Plasticity_Grant\Aim_1\PlasticityN1P2_IO\####\*\*\*ERPanalysis_cleaned.set', '####', PpID));
                    case 'AuditoryTetanization1kHz'
                        numBlocks = 4;
                        ICA_output = [dir(strrep('Z:\Data_Processed\Plasticity_Grant\Aim_2\Auditory_Tetanization\Tetanize_1kHz\####\*Pre*CleanData.set', '####', PpID));
                            dir(strrep('Z:\Data_Processed\Plasticity_Grant\Aim_2\Auditory_Tetanization\Tetanize_1kHz\####\*Post*CleanData.set', '####', PpID))];
                        TF_output = [dir(strrep('Z:\Data_Processed\Plasticity_Grant\Aim_2\Auditory_Tetanization\Tetanize_1kHz\####\*Pre*TF_Epochs.set', '####', PpID));
                            dir(strrep('Z:\Data_Processed\Plasticity_Grant\Aim_2\Auditory_Tetanization\Tetanize_1kHz\####\*Post*TF_Epochs.set', '####', PpID))];
                        ERP_output = [dir(strrep('Z:\Data_Processed\Plasticity_Grant\Aim_2\Auditory_Tetanization\Tetanize_1kHz\####\*Pre*ERP_Epochs.set', '####', PpID));
                            dir(strrep('Z:\Data_Processed\Plasticity_Grant\Aim_2\Auditory_Tetanization\Tetanize_1kHz\####\*Post*ERP_Epochs.set', '####', PpID))];
                    case 'AuditoryTetanization4kHz'
                        numBlocks = 4;
                        ICA_output = [dir(strrep('Z:\Data_Processed\Plasticity_Grant\Aim_2\Auditory_Tetanization\Tetanize_4kHz\####\*Pre*CleanData.set', '####', PpID));
                            dir(strrep('Z:\Data_Processed\Plasticity_Grant\Aim_2\Auditory_Tetanization\Tetanize_4kHz\####\*Post*CleanData.set', '####', PpID))];
                        TF_output = [dir(strrep('Z:\Data_Processed\Plasticity_Grant\Aim_2\Auditory_Tetanization\Tetanize_4kHz\####\*Pre*TF_Epochs.set', '####', PpID));
                            dir(strrep('Z:\Data_Processed\Plasticity_Grant\Aim_2\Auditory_Tetanization\Tetanize_4kHz\####\*Post*TF_Epochs.set', '####', PpID))];
                        ERP_output = [dir(strrep('Z:\Data_Processed\Plasticity_Grant\Aim_2\Auditory_Tetanization\Tetanize_4kHz\####\*Pre*ERP_Epochs.set', '####', PpID));
                            dir(strrep('Z:\Data_Processed\Plasticity_Grant\Aim_2\Auditory_Tetanization\Tetanize_4kHz\####\*Post*ERP_Epochs.set', '####', PpID))];
                    case 'VisualTetanization'
                        numBlocks = 4;
                        ICA_output = [dir(strrep('Z:\Data_Processed\Plasticity_Grant\Aim_2\Visual_Tetanization\####\*Pre*CleanData.set', '####', PpID));
                            dir(strrep('Z:\Data_Processed\Plasticity_Grant\Aim_2\Visual_Tetanization\####\*Post*CleanData.set', '####', PpID))];
                        TF_output = [dir(strrep('Z:\Data_Processed\Plasticity_Grant\Aim_2\Visual_Tetanization\####\*Pre*TF_Epochs.set', '####', PpID));
                            dir(strrep('Z:\Data_Processed\Plasticity_Grant\Aim_2\Visual_Tetanization\####\*Post*TF_Epochs.set', '####', PpID))];
                        ERP_output = [dir(strrep('Z:\Data_Processed\Plasticity_Grant\Aim_2\Visual_Tetanization\####\*Pre*ERP_Epochs.set', '####', PpID));
                            dir(strrep('Z:\Data_Processed\Plasticity_Grant\Aim_2\Visual_Tetanization\####\*Post*ERP_Epochs.set', '####', PpID))];
                    case 'Structural_MRI'
                        numSteps = 5;
                        raw_output = dir(strrep('Z:\Data_Processed\Structural_MRI\####\Plasticity\01_raw\t1_mp2rage_sag_p3_iso_UNI_Images.nii', '####', PpID));
                        clean_output = dir(strrep('Z:\Data_Processed\Structural_MRI\####\Plasticity\02_T1est_clean\clean_t1_mp2rage_sag_p3_iso_UNI_Images.nii', '####', PpID));
                        bet_output = dir(strrep('Z:\Data_Processed\Structural_MRI\####\Plasticity\03_cat12skullstrip\BRAIN_t1_mp2rage_sag_p3_iso_UNI_Images.nii', '####', PpID));
                        reslice_output = dir(strrep('Z:\Data_Processed\Structural_MRI\####\Plasticity\04_reslicetoMNI\MNI_clean_t1_mp2rage_sag_p3_iso_UNI_Images.nii', '####', PpID));
                        segment_output = dir(strrep('Z:\Data_Processed\Structural_MRI\####\Plasticity\05_cat12segmentation\iy_MNI_BRAIN_clean_t1_mp2rage_sag_p3_iso_UNI_Images.nii', '####', PpID));
                    otherwise
                        error('Unknown task entry!')
                end
                
                if strcmp(task, 'CAP_IO')
                    
                    % Put names of blocks
                    if (numel(timeseries_output) >= numBlocks)
                        PpIDs_processed.CleanData{w} = 'DONE';
                    else
                        PpIDs_processed.CleanData{w} = strjoin({timeseries_output.name}', newline);
                    end
                    
                elseif strcmp(task, 'Structural_MRI')
                                        
                    content = {'', 'DONE'};
                    
                    % Put names of steps
                    
                    PpIDs_processed.raw{w} = content{~isempty(raw_output)+1};
                    PpIDs_processed.T1est_clean{w} = content{~isempty(clean_output)+1};
                    PpIDs_processed.cat12skullstrip{w} = content{~isempty(bet_output)+1};
                    PpIDs_processed.reslicetoMNI{w} = content{~isempty(reslice_output)+1};
                    PpIDs_processed.cat12segmentation{w} = content{~isempty(segment_output)+1};
                    
                    
                else
                    % Put names of blocks
                    if (numel(ICA_output) == numBlocks) || (strcmp(task, 'N1P2_IO') && numel(ICA_output)==numBlocks/2)
                        PpIDs_processed.Step1_ICA{w} = 'DONE';
                    else
                        PpIDs_processed.Step1_ICA{w} = strjoin({ICA_output.name}', newline);
                    end
                    
                    if numel(TF_output) == numBlocks
                        PpIDs_processed.Step2_TF{w} = 'DONE';
                    else
                        PpIDs_processed.Step2_TF{w} = strjoin({TF_output.name}', newline);
                    end
                    
                    if numel(ERP_output) == numBlocks
                        PpIDs_processed.Step3_ERP{w} = 'DONE';
                    else
                        PpIDs_processed.Step3_ERP{w} = strjoin({ERP_output.name}', newline);
                    end
                end
                w = w + 1;
            end
        end
        
    end
    
    if strcmpi(task(1:end-4), 'AuditoryTetanization')
        HAS_DATA = readtable('Z:\Data_Raw\Raw_Summary.xlsx', 'Sheet', 'PpIDLists').(task(1:end-4));
    elseif strcmpi(task, 'Structural_MRI')
        x = readtable('Z:\Data_Raw\Raw_Summary.xlsx', 'Sheet', 'PpIDLists').Plasticity_MRI;
        HAS_DATA = [x; readtable('Z:\Data_Raw\Raw_Summary.xlsx', 'Sheet', 'PpIDLists').P50_MRI];
    else
        HAS_DATA = readtable('Z:\Data_Raw\Raw_Summary.xlsx', 'Sheet', 'PpIDLists').(task);
    end
    
    HAS_DATA = unique(HAS_DATA);
    
    PpIDs_started = PpIDs_processed.PpID;
    HAS_DATA = cellfun(@str2double, HAS_DATA);
    
    NEED2BERUN = HAS_DATA(~ismember(HAS_DATA, PpIDs_started));
    
    NEED2BERUN = NEED2BERUN(~ismember(NEED2BERUN, excludeFromNEED2BERUN.IGNORE));
    
    NEED_TO_RUN.(task)(1:numel(NEED2BERUN)) = NEED2BERUN;
    writetable(PpIDs_processed, filename, 'Sheet', task)
    
    
end

writetable(NEED_TO_RUN, filename, 'Sheet', 'NEED_TO_RUN')

fileattrib(filename, '-w') % make read-only
