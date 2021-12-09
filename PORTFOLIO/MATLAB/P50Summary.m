%% Just hit run!
clear variables
clc







outFile = 'Z:\Data_Processed\P50_Grant\P50Summary.xlsx';



search = [dir('Z:\Data_Raw\*\P50\DPOAE\*.DAT').folder];
if ~isempty(search)
    has_OAE = unique(extractBetween(search, 'Data_Raw\', '\'));
else
    has_OAE = {};
end

search = [dir('Z:\Data_Raw\*\P50\FM\*.txt').folder];
if ~isempty(search)
    has_FM = unique(extractBetween(search, 'Data_Raw\', '\'));
else
    has_FM = {};
end


search = [dir('Z:\Data_Raw\*\P50\CM\*080CM1.cdt').folder];
if ~isempty(search)
    has_CM = unique(extractBetween(search, 'Data_Raw\', '\'));
else
    has_CM = {};
end


search = [dir('Z:\Data_Raw\*\P50\CAP\*80_2.cdt').folder];
if ~isempty(search)
    has_CAP = unique(extractBetween(search, 'Data_Raw\', '\'));
else
    has_CAP = {};
end


search = [dir('Z:\Data_Processed\P50_Grant\P50_CM\*\*CM*\*_p50_*CM*_peaks.csv').folder];
if ~isempty(search)
    finished_CM = unique(extractBetween(search, 'P50_CM\', '\'));
else
    finished_CM = {};
end


search = [dir('Z:\Data_Processed\P50_Grant\P50_CAPio\P50_clickCAPs\*\click\IOfunction150\*timeseries.docx').folder];
if ~isempty(search)
    finished_CAP = unique(extractBetween(search, 'P50_clickCAPs\', '\'));
else
    finished_CAP = {};
end


needs_CM_Run = setdiff(has_CM, finished_CM);
needs_CAP_Run = setdiff(has_CAP, finished_CAP);

T = array2table(zeros(200, 6));
T.Properties.VariableNames = {'has_OAE', 'has_FM', 'has_CM', 'has_CAP', 'finished_CM', 'finished_CAP'};


T.has_OAE(1:numel(has_OAE)) = cellfun(@str2double, has_OAE);
T.has_FM(1:numel(has_FM)) = cellfun(@str2double, has_FM);
T.has_CM(1:numel(has_CM)) = cellfun(@str2double, has_CM);
T.has_CAP(1:numel(has_CAP)) = cellfun(@str2double, has_CAP);
T.finished_CM(1:numel(finished_CM)) = cellfun(@str2double, finished_CM);
T.finished_CAP(1:numel(finished_CAP)) = cellfun(@str2double, finished_CAP);

if exist(outFile, 'file')
    fileattrib(outFile, '+w')
end

for i=1:width(T), T.(i)(T.(i)==0) = nan; end

blanksheet = cell2table(cell(500, 20));
writetable(blanksheet, outFile, 'WriteVariableNames', false) % clear sheet
writetable(T, outFile, 'Sheet', 'Summary')
fileattrib(outFile, '-w')



fprintf('Done!\n')






