%Redcap Importer
%Authors LBK BJB
%created 5/22/19
%This takes excel spreadsheets and attempts to modify variable names so
%they are redcap 'friendly', save them out as a csv, and update the data
%dictionary with new variable (column headers)

% If you'd like to import multiple files, just comment out the lines that
% say *for importing single file and uncomment all the lines that say *for
% importing multiple files. Also note that all these files must be in the
% same directory

close all; clear variables;  clc

%% Choose Plasticity or Temporal grant excel file
[file, path] = uigetfile('*.*');  %opens dialog box to get file *for importing single file
% [file, path] = uigetfile('*.*',  'All Files (*.*)','MultiSelect','on'); % *for importing multiple files (must be in the same directory)

% for xx=1:length(file) % *for importing multiple files
file_path = strcat(path,file); %sets up absolute path to file *for importing single file
% file_path = strcat(path,file{xx}); % *for importing multiple files

%% Read in excel sheet

[~,sheet_name]=xlsfinfo(file_path); % reads sheet names in workbook

for k=1:numel(sheet_name) % for each sheet in the workbook
    clear data
    clear cols
    data = readtable(file_path,'sheet',sheet_name{k}); % read this sheet from the workbook

%% Makes variable names fancy for redcap
data.Properties.VariableNames = lower(data.Properties.VariableNames); %specifies naming and changes capitals to lowercase
data.Properties.VariableNames{1} = 'record_id'; % make the first cell "record_id". This absolutely has to be the case for redcap. Do not change.

%% Write CSV
csv_name = extractBefore(file,'.'); %removes extention from file name
cd(path)
writetable(data,strcat(csv_name,'_',sheet_name{k},'.csv')) %writes data as csv (for this sheet from the workbook

%% Read in data dictionary
dictionary_path = extractBefore(file_path,'Newdata'); %path to data dictionary
grant_type = extractBetween(file_path,'Z:\Redcap\','\Newdata'); %specifies plasticity or temporal data dictionary

switch grant_type{1}
    case 'Plasticity'
        dictionary_name='plasticitydatadictionary.csv';
       datadictionary = readtable(strcat(dictionary_path,dictionary_name));
    case 'Temporal'
        dictionary_name='temporaldatadictionary.csv';
       datadictionary = readtable(strcat(dictionary_path,dictionary_name));
    otherwise
        disp('wtf')
end


%% Put variables into data dictionary

headers = data.Properties.VariableNames'; %transpose headers
headers = headers(2:end);
formname = csv_name;
fieldtype = 'text';

formname = cellstr(repelem(formname,length(headers),1)); %specifies form name for datadictionary
fieldtype = cellstr(repelem(fieldtype,length(headers),1));

 % creates an array containing all the new variables and their redcap stuff
 % in the format to fit into the data dictionary (recap's definition of all
 % variables in its database)
cols(:,1) = headers;
cols(:,2) = formname;
cols(:,4) = fieldtype;
[row y] = size(datadictionary);

redcap_headers = datadictionary.Properties.VariableNames; % pull the headers out of the data dictionary table and save them for later

datadictionary = table2cell(datadictionary); % turnn the data dictionary table into a cell array

datadictionary(row+1:(row+length(headers)),1:4) = cols; % place our new variables at the end of the data dictionary

T = cell2table(datadictionary); % turn back into table

T.Properties.VariableNames = redcap_headers; % put the headers back in

%% Rewrite dictionary
% This needs to be the path to the "Imported" folder for stuff that has
%  been imported into redcap. Matlab will automatically place the files in
% their once they are in the data dictionary. Please note that if you encounter
% problems in redcap and are unable to import the data, you should consider
% coming back here and taking the data out of the "Imported" folder.
imported_path = strcat('Z:\Redcap\',grant_type{1},'\Imported\');

cd(strcat('Z:\Redcap\',grant_type{1})) % move to the directory where the data dictionary is located

writetable(T,dictionary_name) %rewrite the data dictionary as csv with updated variables

movefile(strcat(path,csv_name,'_',sheet_name{k},'.csv'), imported_path) % move the csv containing the data from this sheet of the workbook into the "imported" folder

end

%% Move file into imported folder now that it's been imported

movefile(file_path, imported_path)

% end % *for importing multiple files
disp('Database Updated!')
