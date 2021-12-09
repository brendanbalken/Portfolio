clc
clear variables

filename = 'Z:\Data_Raw\Summary.xlsx'; % where to save excel sheet

tasks = {
    'CAP_IO'
    'N1P2_IO'
    'AuditoryTetanization'
    'VisualTetanization'
    'MRI'
};

paths = {
    'Z:\Data_Raw\####\Plasticity_Grant\Aim1\CAP_IO'
    'Z:\Data_Raw\####\Plasticity_Grant\Aim1\N1P2_IO'
    'Z:\Data_Raw\####\Plasticity_Grant\Aim2\AuditoryTetanization'
    'Z:\Data_Raw\####\Plasticity_Grant\Aim2\VisualTetanization'
    'Z:\Data_Raw\####\Plasticity_Grant\IMAGING_DATA'
    };

T = cell2table(cell(1,numel(tasks)));
T.Properties.VariableNames = tasks;

for X=1:numel(paths)
    
    task = tasks{X};
    path = paths{X};

    cd Z:\Data_Raw\

    FOLDERS = dir(); % List all items in this directory
    FOLDERS = FOLDERS([FOLDERS.isdir]); % Remove non-folder items from list

    FOLDERS(strcmp({FOLDERS.name}, '.')) = []; % Delete the "." (present dir) entry from list
    FOLDERS(strcmp({FOLDERS.name}, '..')) = []; % Delete the ".." (parent dir) entry from list

    FOLDERS = {FOLDERS.name}'; % Transpose list into a more readable orientation

    digits = regexp(FOLDERS, '\d\d\d\d'); % Filter list looking for any folders named something with 4 numerical digits (ex: 7729 0r 1234)

    PpIDs = FOLDERS(~cellfun(@isempty, digits)); % Pull out non-empty list entries. This is our participant ID list!

    % Initialize
    w = 1;
    PpIDs_with_task = cell(1,200);

    for k=1:length(PpIDs)
        PpID = PpIDs{k};
        taskFolder = strrep(path, '####', PpID);
        if exist(taskFolder, 'dir')
            folderCheck = dir(taskFolder);
            folderCheck(strcmp({folderCheck.name}, '.')) = [];
            folderCheck(strcmp({folderCheck.name}, '..')) = [];
            if ~isempty(folderCheck)
                PpIDs_with_task{w,1} = PpID;
                w = w + 1;
            end
        end
    end
    
    PpIDs_with_task = PpIDs_with_task(1:w-1);

    T.(task)(1:numel(PpIDs_with_task)) = PpIDs_with_task;

end

PpIDList = table2cell(T);
PpIDList = PpIDList(~cellfun(@isempty,PpIDList));

PpIDList = unique(PpIDList);

T_alt =  cell2table(cell(numel(PpIDList),numel(tasks)));
T_alt.Properties.VariableNames = tasks;
T_alt.Properties.RowNames = PpIDList;


for k=1:numel(tasks)
    task = tasks{k};
    missing = setdiff(PpIDList, T.(task)(~cellfun(@isempty,T.(task))));

    T_alt.(task)(missing) = repmat({'0'}, numel(T_alt.(task)(missing)),1);
    T_alt.(task)(cellfun(@isempty,T_alt.(task))) = repmat({'X'}, numel(T_alt.(task)(cellfun(@isempty,T_alt.(task)))), 1);
    T_alt.(task)(ismember(T_alt.(task), '0')) = {''};
end 

writetable(T, filename, 'Sheet', 'PpIDLists')
writetable(T_alt, filename, 'Sheet', 'CheckList','WriteRowNames',true)

disp(T);