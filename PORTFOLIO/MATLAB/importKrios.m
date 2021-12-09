%% Initialize
clear variables
clc

% Optionally, define eeglab path here
% eeglabPath = 'C:\Users\Kelly Harris\Desktop\eeglab14_1_2b\eeglab14_1_2b';

%% Choose data file and krios file
[datFile, datFolder] = uigetfile('.cdt');
[kriosFile, kriosFolder] = uigetfile([datFolder '.csv']);

if ~exist('eeglabPath', 'var') && (~exist('eeglab', 'file') || ~exist('loadcurry', 'file'))
    warndlg('eeglab not found in path, please select the folder containing an installation of eeglab')
    eeglabPath = uigetdir();
    addpath(eeglabPath)
end

%% Import Data
% LOAD EEGLAB
EEG = eeglab;

% READ CURRY DATA FILE
EEG = loadcurry(fullfile(datFolder, datFile));

kriosCSV = fullfile(kriosFolder, kriosFile);

% IMPORT LOCATIONS
chanlocs = readtable(kriosCSV);
chanlocs.Properties.VariableNames = {'labels', 'X', 'Y', 'Z'};

%% Apply coordinates to EEG structure
% this can theoretically be done by importing the file and not using a for
% loop, but EEGLAB has severe limitations in that functionality and it
% turns out this is actually the most robust way to do this :,(
for k=1:height(chanlocs)
    cell2compare = cell(size({EEG.chanlocs.labels}'));
    cell2compare(:) = chanlocs.labels(k);
    idxcheck = cellfun(@strcmpi,cell2compare,{EEG.chanlocs.labels}');
    if sum(idxcheck == 1)
        channum = find(ismember({EEG.chanlocs.labels}', chanlocs.labels{k}));
        EEG = pop_chanedit(EEG, 'changefield', {channum 'X', chanlocs.X(k)});
        EEG = pop_chanedit(EEG, 'changefield', {channum 'Y', chanlocs.Y(k)});
        EEG = pop_chanedit(EEG, 'changefield', {channum 'Z', chanlocs.Z(k)});
    end
end

% Check validity of dataset
EEG = eeg_checkset(EEG);

%% Plot and check point cloud
labels = { EEG.chanlocs.labels }';
labels(cellfun('isempty', {EEG.chanlocs.X})) = [];
plotchans3d([ [ EEG.chanlocs.X ]' [ EEG.chanlocs.Y ]' [ EEG.chanlocs.Z ]'], labels)
