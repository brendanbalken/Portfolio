# -*- coding: utf-8 -*-
"""
Python Reference

A reference sheet for Python functions and modules I commonly use.
Along with example snippets showing various relevant processes.
(Importing data, plotting data, writing out data, etc)

"""

# %% Important modules
from matplotlib.pyplot import * # import all functions etc from the submodule "pyplot"
from matplotlib.widgets import Button # allows you to make interactive plots
from glob import glob # import the main "glob" function from the "glob" module
import mne # import mne (similar to eeglab)
import dipy # like spm
from dipy.io.image import load_nifti, load_nifti_data # for loading nii
from dipy.viz import window, actor, ui # for mri visualization, display
import nibabel as nb # mri thing
from deepbrain import Extractor # brain extraction (requires tensorflow==1.15)

import numpy as np # import numpy under the alias "np" (common practice)
import pandas as pd
from math import * # import all functions etc from "math" module

import os # import os module
import sys # import sys module
from shutil import copy, move, which, disk_usage, rmtree, copytree # import VERY useful shell commands
from os.path import exists, isfile, isdir, split, join # more VERY useful methods
from os import rename, mkdir, remove

from numba import njit, jit # for performance

# %% Notes:
    # This script is just a reference so in many places you will see a the
    # first item taken from an array ("[0]") - this is arbitrary and simply
    # because we don't need to use the whole list.
    
    # "glob" is an awesome module very similar to "dir" in matlab. You can use
    # it to find files that match a pattern with wildcards or list the contents
    # of one or more directories.
    
    # "matplotlib" is a module that contains functions that mimic matlab's plotting functions.
    
    # Nipy requires a max numpy version of 1.17 and Visual C++ Build Tools
    # (http://go.microsoft.com/fwlink/?LinkId=691126&fixForIE=.exe)
    
    # Dipy requires installation of fury (pip install fury)
    # Fury is a Python library available for scientific visualization.
    # - The library is available via PyPi or Anaconda package system
    # - https://fury.gl/

# %% Read data

# Read raw data from Curry 8 using MNE:
rawCurryData = glob('Z:\\Data_Raw\\1791\\Plasticity_Grant\\Aim1\\N1P2_IO\\*.cdt')[0]
EEG = mne.io.read_raw_curry(rawCurryData)

# Read data from excel sheet:
excelSheet = glob('Z:\\Data_Compiled\\Data - GABA\\*.xlsx')[0]
GABA = pd.read_excel(excelSheet)

# Read data from text file (or csv):
textFile = glob('Z:\\Data_Processed\\Plasticity_Grant\\Aim_1\\PlasticityCAP_IO\\1221\\*\*\\*CAPtimeseries*.txt')[0]
timeseries = pd.read_csv(textFile)

# %% Plot data
# Create empty figure
figure(num=1, figsize=(8, 6), dpi=140, facecolor='w', edgecolor='k')

# Create subplot instance 1 of 3
ax1 = subplot(3, 1, 1, xlabel='time (ms)', ylabel='Amp', title='CAP_IO')
plot(timeseries.times, timeseries.CAP_capio_1kHz110tone) # plot first line (tone1)
plot(timeseries.times, timeseries.CAP_capio_1kHz110tone2) # plot 2nd line (tone2)
ax1.legend(['tone1', 'tone2']) # create legend

# Create subplot instance 2 of 3
ax2 = subplot(3, 1, 2, xlabel='time(ms)', ylabel='Amp')
plot(timeseries.times, timeseries.CAP_capio_1kHz100tone)
plot(timeseries.times, timeseries.CAP_capio_1kHz100tone2)
ax2.legend(['tone1', 'tone2'])

# Create subplot instance 3 of 3
ax3 = subplot(3, 1, 3, xlabel='time(ms)', ylabel='Amp')
plot(timeseries.times, timeseries.CAP_capio_1kHz90tone)
plot(timeseries.times, timeseries.CAP_capio_1kHz90tone2)
ax3.legend(['tone1', 'tone2'])

# Create an output directory if none exists
if not exists('Z:\\Brendan\\sandbox\\'):
    mkdir('Z:\\Brendan\\sandbox\\')

# Save out current figure
savefig('Z:\\Brendan\\sandbox\\temp.png')
close('all') # close all figures

# %% Write data
# Pandas has many great super cool ways to write data. Please see examples below!

timeseries.to_clipboard() # Can paste the data anywhere now including excel!!

# Write DataFrame to CSV, Excel, or Pickle
# (A pickle is basically the python equivalent of a .mat file I like it because
# pickles are tasty and it reminds me of tasty pickles!)
timeseries.to_csv('Z:\\Brendan\\sandbox\\temp.csv', index=False) # index=False suppresses printing of row numbers
timeseries.to_excel('Z:\\Brendan\\sandbox\\temp.xlsx', index=False)
timeseries.to_pickle('Z:\\Brendan\\sandbox\\temp.pkl') # to read this back in simply use pd.read_pickle




# %% MRI DATA

image = nipy.load_image('Z:\\Data_Processed\\MRI_dicomsort\\sorted\\7729\\Plasticity\\mri\\MP2Rage_cleaned_7729.nii')
data = image.get_data()
affine = image.affine
dims = image.shape



fig, ax = subplots()
subplots_adjust(bottom=0.2)
l = imshow(data[:,:,0], cmap='gray')


class Index:
    ind = 0
    @jit
    def next(self, event):
        self.ind += 1
        l.set_data(data[:,:,self.ind])
        
    @jit
    def prev(self, event):
        self.ind -= 1
        l.set_data(data[:,:,self.ind])

callback = Index()
axprev = axes([0.7, 0.05, 0.1, 0.075])
axnext = axes([0.81, 0.05, 0.1, 0.075])
bnext = Button(axnext, 'Next')
bnext.on_clicked(callback.next)
bprev = Button(axprev, 'Previous')
bprev.on_clicked(callback.prev)


# %% Copying batch of files
# TONS of useful methods in this section!!! See summary below:
    # Filtering of lists and set comparison.
    # List comprehension with logical statement (powerful tool)
    # Check file sizes
    # Check disk space
    # Create DataFrames (like Matlab's tables)
    # View extended printout of DataFrames
    # Get user input
    # String formatting
    # Get fileparts from path (important partner to glob)
    # Throw custom errors
    # Use of "exists" and "isdir" methods

# Search for files matching this pattern and copy them to the destination
files = glob('G:\\*\\EEG\\clickFFR\\*')
destination = 'Z:\\clickFFR\\PpID\\TemporalGrant\\'

# Manually exclude files from batch copy based on indices in list
exclude = ['G:\\7742\\EEG\\clickFFR\\ClickFFR_bad',
           'G:\\4437 - Copy\\EEG\\clickFFR\\4437_ClickFFR.ceo',
           'G:\\4437 - Copy\\EEG\\clickFFR\\4437_ClickFFR.dat',
           'G:\\4437 - Copy\\EEG\\clickFFR\\4437_ClickFFR.dap',
           'G:\\4437 - Copy\\EEG\\clickFFR\\4437_ClickFFR.rs3',
           'G:\\9179\\EEG\\clickFFR\\partial_dontuse',
           'G:\\6819\\EEG\\clickFFR\\6819_ClickFFRbad.ceo',
           'G:\\6819\\EEG\\clickFFR\\6819_ClickFFRbad.dat',
           'G:\\6819\\EEG\\clickFFR\\6819_ClickFFRbad.rs3',
           'G:\\6819\\EEG\\clickFFR\\6819_ClickFFRbad.dap'
           ]


# VERY USEFUL LINE OF CODE!!!
# Filters list, but more importantly it combines list comprehension with logical
# statement! Here is the syntax for doing it in general:
# [f(x) if condition else g(x) for x in sequence]
# [f(x) for x in sequence if condition]
files[:] = [file for file in files if not file in exclude]

# Check total size of the batch of files
get_size = 0
for file in files:
    get_size += os.path.getsize(file)

# Check total free space in destination
space = disk_usage(destination).free

# Summarize all pertinent information about pending transfer into a dataframe
summary = pd.DataFrame(data={'NumFiles (GB)': len(files), 'TotalSize': get_size/1e9, 'Destination': destination, 'SpaceInDestination': space/1e9}, index=[1])

# Create a dataframe to view list of files with indices
filesPD = pd.DataFrame(files)

# Display the file list and summary info
with pd.option_context('display.max_rows', None, 'display.max_columns', None):  # more options can be specified also
    print(filesPD)
    print(summary)

# Ask the user to confirm the operation
print('\nThe files you are attempting to copy total to {} GB. Are you sure you wish to proceed??'.format(round(get_size/1e9, 2)))
proceed = input("[Y/N] >> ")

# Unless they opted yes, abort
if not proceed.upper()=='Y':
    raise(BaseException('User aborted'))

# If destination does not have enough free space, abort
if space < get_size:
    raise(BaseException('Not enough free space!!'))

# Copy files
for file in files:
    if isdir(file):
        continue
    folder, filename = split(file)
    if exists('{}\\{}'.format(destination, filename)):
        continue
    else:
        copy(file, destination)


# %% Set comparision (like cell comparision in Matlab)

a = [5,
     'this',
     2,
     8,
     'cars',
     9]

b = [4,
     5,
     'this',
     'that',
     'the other']


# These are the elements the two lists have in common:
overlap = set(a).intersection(b)

# These are the elements missing from list B:
missing = set(a).difference(b)

# Values that are unique between both lists (overlap removed)
unique = set(a).symmetric_difference(b)

# Is superset or subset:
set(a).issubset(set(b))
set(a).issuperset(set(b))

# Combine two sets using union:
all_set = set(a).union(set(b))

# Sidebar: Combine two lists simply using extend
all_list = a.extend(b)

# %% String manipulation (WIP)

x = 'this, that, the other'
x = x.replace('the other', 'and the other')
x = x.split(', ')

x = '{}\\{}'.format('Z:\\Brendan', 'file.txt')

# %% Classes
# Example class for reference
# Class will be a participant


class Participant:
    # Defin the __init__ function (this is the constructer that initializes an
    # instance of the class. It should include all prerequisites for the class
    #  and any processes that you need to run when the instance is created)
    def __init__(self, PpID):
        self.PpID = PpID
    
    # Define a method
    def PpIDasNumber(self):
        return int(self.PpID)




# %% Batch File/Folder Creation, Renaming, deleting

baseDir = 'Z:\\Brendan\\sandbox\\####\\subfolder'
PpIDs = ['1221', '7729', '8345']
for PpID in PpIDs:
    os.makedirs(baseDir.replace('####', PpID))

folders = glob('Z:\\Brendan\\sandbox\\*\\subfolder')
oldName = 'subfolder'
newName = 'IMAGING'
for folder in folders:
    rename(folder, folder.replace(oldName, newName))

folders = glob('Z:\\Brendan\\sandbox\\*')
for folder in folders:
    if isdir(folder):
        rmtree(folder)

files = glob('Z:\\Brendan\\sandbox\\temp*')
for file in files:
    remove(file)



# %% "Deepbrain" brain extraction

files = glob('Z:\\Data_Processed\\MRI_dicomsort\\sorted\\*\\*\\mri\\MNI_[0-9][0-9][0-9][0-9]_MP2Rage_cleaned.nii')

percent = 0.50

head = 'Z:\\Data_Processed\\MRI_dicomsort\\sorted\\1221\\Plasticity\\mri\\MNI_clean_t1_mp2rage_sag_p3_iso_UNI_Images.nii'

print(head)
img = nb.load(head)
ext = Extractor()
prob = ext.run(img.get_fdata())

mask = prob>percent
mask = np.where(mask==False, 0, mask)
mask = np.where(mask==True, 1, mask)
mask_img = nb.Nifti1Image(mask, img.affine, img.header)
brain_img = nb.Nifti1Image(mask*img.get_fdata(), img.affine, img.header)
nb.save(mask_img, 'brainmask.nii')
nb.save(brain_img, 'brain.nii')


# %% temp

import numpy as np
import nibabel as nb


def get_nbhd(pt, checked, dims):
    nbhd = []

    if (pt[0] > 0) and not checked[pt[0]-1, pt[1], pt[2]]:
        nbhd.append((pt[0]-1, pt[1], pt[2]))
    if (pt[1] > 0) and not checked[pt[0], pt[1]-1, pt[2]]:
        nbhd.append((pt[0], pt[1]-1, pt[2]))
    if (pt[2] > 0) and not checked[pt[0], pt[1], pt[2]-1]:
        nbhd.append((pt[0], pt[1], pt[2]-1))

    if (pt[0] < dims[0]-1) and not checked[pt[0]+1, pt[1], pt[2]]:
        nbhd.append((pt[0]+1, pt[1], pt[2]))
    if (pt[1] < dims[1]-1) and not checked[pt[0], pt[1]+1, pt[2]]:
        nbhd.append((pt[0], pt[1]+1, pt[2]))
    if (pt[2] < dims[2]-1) and not checked[pt[0], pt[1], pt[2]+1]:
        nbhd.append((pt[0], pt[1], pt[2]+1))

    return nbhd

file = 'Z:\\Data_Processed\\MRI_dicomsort\\sorted\\7729\\Plasticity\\mri\\qT1_t1_mp2rage_sag_p3_iso_UNI_Images.nii'

def grow(img, seed, t):
    """
    img: ndarray, ndim=3
        An image volume.
    
    seed: tuple, len=3
        Region growing starts from this point.
    t: int
        The image neighborhood radius for the inclusion criteria.
    """
    seg = np.zeros(img.shape, dtype=np.bool)
    checked = np.zeros_like(seg)
 
    seg[seed] = True
    checked[seed] = True
    needs_check = get_nbhd(seed, checked, img.shape)
 
    while len(needs_check) > 0:
        pt = needs_check.pop()
 
        # Its possible that the point was already checked and was
        # put in the needs_check stack multiple times.
        if checked[pt]: continue
 
        checked[pt] = True
 
        # Handle borders.
        imin = max(pt[0]-t, 0)
        imax = min(pt[0]+t, img.shape[0]-1)
        jmin = max(pt[1]-t, 0)
        jmax = min(pt[1]+t, img.shape[1]-1)
        kmin = max(pt[2]-t, 0)
        kmax = min(pt[2]+t, img.shape[2]-1)
 
        if img[pt] >= img[imin:imax+1, jmin:jmax+1, kmin:kmax+1].mean():
            # Include the voxel in the segmentation and
            # add its neighbors to be checked.
            seg[pt] = True
            needs_check += get_nbhd(pt, checked, img.shape)
 
    return seg

head = nb.load(file)
img = np.array(head.get_fdata())
seed = (96, 91, 52)
segmentation = grow(img, seed, 5)

head = nb.Nifti1Image(segmentation, head.affine, head.header)
nb.save(head, 'temp.nii')


# %%
import nibabel as nb
import numpy as np
import cv2
from matplotlib import pyplot as plt
from PIL import Image as im

file = 'Z:\\Data_Processed\\MRI_dicomsort\\sorted\\1221\\Plasticity\\mri\\negative_MNI_qT1_t1_mp2rage_sag_p3_iso_UNI_Images.nii'

# img = cv2.imread('die.png')
img = np.array(nb.load(file).get_fdata())



for frame in np.arange(0, img.shape[0]-1, 1):
    image = im.fromarray(img[frame, :, :])
    
    dst = cv2.fastNlMeansDenoisingColored(img[frame, :, :],None,10,10,7,21)
    
    plt.subplot(121),plt.imshow(image)
    plt.subplot(122),plt.imshow(dst)
    plt.show()

# %% Compile to exe

# From command line (as admin)
#cd "C:\Users\Harris Lab\Desktop"
#ScriptToCompile="C:\Users\Harris Lab\Desktop\myScript.py"
#pyinstaller --noconfirm --onefile --windowed %ScriptToCompile%

# Note: this takes 5ever. Also make sure you cd so it doesn't end up in System32


# %% Find regular expression in string

PpIDs = []

files = glob(r"Z:\Brendan\PLV_VBM\SANDBOX\*.nii")

from re import search
regExpr = '[0-9][0-9][0-9][0-9]'

for file in files:
    PpID = search(regExpr, file).group(0)
    PpIDs.append(PpID)

PpIDs = set(PpIDs)



# %%

from bm3d import bm3d
import numpy as np
import nibabel as nb

file = 'Z:\\Data_Processed\\MRI_dicomsort\\sorted\\1221\\Plasticity\\mri\\negative_MNI_qT1_t1_mp2rage_sag_p3_iso_UNI_Images.nii'
img = np.array(nb.load(file).get_fdata())
head = nb.load(file)

brian = bm3d(img, sigma_psd=0.50)

brian = brian>0.5

head = nb.Nifti1Image(brian, head.affine, head.header)
nb.save(head, 'Z:\\Data_Processed\\MRI_dicomsort\\sorted\\1221\\Plasticity\\mri\\temp.nii')



