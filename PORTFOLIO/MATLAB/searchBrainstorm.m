% Mass select files from Brainstorm based on search pattern
% Author BJB
% Written 8/28/20
% Last Modified 8/28/20
clear variables
clc

addpath(genpath('Z:\Scripts\Plasticity_Scripts\SourceAnalysis'))

if isempty(which('brainstorm'))
    addpath('Z:\MatlabSoftwarePackages\brainstorm3')
end

if ~brainstorm('status')
    brainstorm('nogui')
end



task = 'AuditoryTetanization1kHz';
% Options Include:
% AuditoryTetanization1kHz
% AuditoryTetanization4kHz
% N1P2_IO
% VisualTetanization


% condition = 'Pre1_1kHz';
% Options Include:
% Pre1_1kHz
% Pre2_1kHz
% Post1_1kHz
% Post2_1kHz
% Pre1_4kHz
% Pre2_4kHz
% Post1_4kHz
% Post2_4kHz







%% Automatic from here!

groups = {'sFiles', 'sFiles1', 'sFiles2'};
group = listdlg('PromptString', 'Which group are you selecting?',...
'SelectionMode', 'single',...
'ListSize', [200 200],...
'ListString', groups);
group = groups{group};

if ~exist('task', 'var')
    tasks = {'AuditoryTetanization1kHz', 'AuditoryTetanization4kHz', 'N1P2_IO', 'VisualTetanization'};
    task = listdlg('PromptString', 'Please select a task',...
        'SelectionMode', 'single',...
        'ListSize', [200 200],...
        'ListString', tasks);
    task = tasks{task};
end

if ~exist('condition', 'var')
    conditions = {'Pre1_1kHz', 'Pre2_1kHz', 'Post1_1kHz', 'Post2_1kHz', 'Pre1_4kHz', 'Pre2_4kHz', 'Post1_4kHz', 'Post2_4kHz'};
    condition = listdlg('PromptString', 'Please select condition (hold ctrl to select multiple)',...
        'SelectionMode', 'multiple',...
        'ListSize', [200 200],...
        'ListString', conditions);
    conditions = conditions(condition);
end



sFiles = dir([source_path('Brainstorm DB') '\Group_analysis\' task '\results*.mat']);
sFiles = strcat(['Group_analysis/' task '/'], {sFiles.name}');

for k = 1:numel(conditions)
    condition = conditions{k};
    % Process: Select files using search query
    found = bst_process('CallProcess', 'process_select_search', sFiles, [], ...
        'search',     ['(([name CONTAINS "' condition '"]))'], ...
        'includebad', 1);
    if ~exist('selected', 'var')
        selected = found;
    else
        selected(end+1:end+numel(found)) = found;
    end
end


sFiles = {selected.FileName}';
lastLine = sFiles(end);
sFiles = sFiles(1:end-1);

a = sprintf([group ' = {...']);
b = sprintf('\n\t''%s'', ...', sFiles{:});
c = sprintf('\n\t''%s''};', lastLine{:});
list = [a b c];

clipboard('copy',list)


