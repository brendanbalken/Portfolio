# -*- coding: utf-8 -*-
"""

MRI Preprocessing Pipeline


Created on Fri Jun 25 08:25:28 2021

@author: Brendan Balken
"""

# %% Important modules
# from matplotlib.pyplot import * # import all functions etc from the submodule "pyplot"
# from matplotlib.widgets import Button # allows you to make interactive plots
from glob import glob # import the main "glob" function from the "glob" module
# import mne # import mne (similar to eeglab)
# import dipy # like spm
# from dipy.io.image import load_nifti, load_nifti_data # for loading nii
# from dipy.viz import window, actor, ui # for mri visualization, display
import nibabel as nb # mri thing
# from deepbrain import Extractor # brain extraction (requires tensorflow==1.15)
from scipy import signal

import numpy as np # import numpy under the alias "np" (common practice)
# import pandas as pd
# from math import * # import all functions etc from "math" module
import json # work with json

# import os # import os module
# import sys # import sys module
from shutil import copy # import VERY useful shell commands
from os.path import exists, split # more VERY useful methods
from os import mkdir

# from numba import njit, jit # for performance

# %% Find all PpIDs matching filter

PpID = '[0-9][0-9][0-9][0-9]'
grant = '*'

kneePt = 'auto' # set to 'auto' to use histogram properties
smoothingKernel = 8
thresholdFr = 0.60

folders = glob(f'Z:\\Data_Processed\\MRI_dicomsort\\sorted\\{PpID}\\{grant}')

scans = []

for folder in folders:
    parts = folder.split('\\')
    PpID = parts[-2]
    grant = parts[-1]
    scans.append([PpID, grant])



# %% Sort

for scan in scans:
    PpID = scan[0]
    grant = scan[1]
    rawDir = f'Z:\\Data_Processed\\MRI_dicomsort\\sorted\\{PpID}\\{grant}\\t1_mp2rage_sag_p3_iso\\'
    mriDir = f'Z:\\Data_Processed\\MRI_dicomsort\\sorted\\{PpID}\\{grant}\mri\\'
    if not exists(mriDir):
        mkdir(mriDir)
    
    jsons = glob(f'{rawDir}*.json');
    
    for headerPath in jsons:
        with open(headerPath) as f:
            header = json.load(f)
        seriesType = header['SeriesDescription']
        niiName = split(headerPath)[-1].replace('.json', '.nii')
        
        if not seriesType.find('t1_mp2rage_sag_p3_iso') == -1:
            copy(f'{rawDir}{niiName}', f'{mriDir}{seriesType}.nii')
            copy(f'{rawDir}{split(headerPath)[-1]}', f'{mriDir}{seriesType}.json')
    
    if len(glob(f'{mriDir}*'))==0:
        continue
    
    INV1 = glob(f'{mriDir}*INV1.nii')[0];
    INV2 = glob(f'{mriDir}*INV2.nii')[0];
    UNI = glob(f'{mriDir}*UNI_Images.nii')[0];
    
    INV1 = nb.load(INV1)
    INV2 = nb.load(INV2)
    UNI = nb.load(UNI)
    
    data_INV1 = np.array(INV1.get_fdata())
    data_INV2 = np.array(INV2.get_fdata())
    data_UNI = np.array(UNI.get_fdata())
    
    data_diff = data_INV1*abs(data_INV1.max()/data_INV2.max()) - data_INV2
    
    y, x = np.histogram(data_diff, bins=100)
    x = x[1:]
    
    peaks = y[signal.find_peaks(y)[0]]
    
    peaks.sort()
    
    peak1 = np.where(y==peaks[-1])[0][0]
    
    peak2 = np.where(y==peaks[-2])[0][0]
    
    
    th = (x[peak2]-x[peak1])/2
    
    
    data_diff[data_diff>th] = 0
    data_diff[data_diff<th] = 1
    
    head = data_UNI*data_diff
    
    head = nb.Nifti1Image(head, UNI.affine, UNI.header)
    nb.save(head, f'{mriDir}fancy.nii')
    
    # data = np.array(INV2.get_fdata())
    
    # new_data = data.copy()
    
    
    # if kneePt=='auto':
    #     y, x = np.histogram(data, bins=100)
    #     x = x[1:]
    #     kn = KneeLocator(x, y, curve='convex', direction='decreasing')
    #     kneePt = kn.find_knee()[0]
    
    # new_data[data>=kneePt]=1
    # new_data[data<kneePt]=0
    
    
    # # first build the smoothing kernel
    # sigma = smoothingKernel     # width of kernel
    # x, y, z = data.shape
    # x = np.arange(-x/2, x/2, 1)
    # y = np.arange(-y/2, y/2, 1)
    # z = np.arange(-z/2, z/2, 1)
    
    
    # # x = np.arange(-3,4,1)   # coordinate arrays -- make sure they contain 0!
    # # y = np.arange(-3,4,1)
    # # z = np.arange(-3,4,1)
    # xx, yy, zz = np.meshgrid(x, y, z)
    # kernel = np.exp(-(xx**2 + yy**2 + zz**2)/(2*sigma**2))
    
    # # smooth using kernel
    # new_data = signal.convolve(new_data, kernel, mode='same', method='auto')
    
    # head_mask = nb.Nifti1Image(new_data, INV2.affine, INV2.header)
    # nb.save(head_mask, 'smooth_head_mask.nii')
    
    # threshold = new_data.max()*thresholdFr
    
    # # threshold smoothed head mask
    # new_new_data = new_data.copy()
    # new_new_data[new_data>=threshold]=1
    # new_new_data[new_data<threshold]=0
    
    # head_mask = nb.Nifti1Image(new_new_data, INV2.affine, INV2.header)
    # nb.save(head_mask, 'head_mask.nii')
    
    
    # UNI_data = np.array(UNI.get_fdata())
    
    # UNI_data = UNI_data*new_new_data
    
    # head = nb.Nifti1Image(UNI_data, UNI.affine, UNI.header)
    # nb.save(head, 'head.nii')
    
    
# %%





files = glob('Z:\\Data_Processed\\MRI_dicomsort\\sorted\\*\\*\\mri\\mri\p0fancy.nii')

for file in files:
    scan = nb.load(file)
    data = np.array(scan.get_fdata())
    data[data>0] = 1
    brainmask = nb.Nifti1Image(data, scan.affine, scan.header)
    nb.save(brainmask, file.replace('p0fancy', 'brainmask'))







# im1 = nb.load('Z:\\Scripts\\WIP\\c1masked.nii')
# data1 = np.array(im1.get_fdata())

# im2 = nb.load('Z:\\Scripts\\WIP\\c2masked.nii')
# data2 = np.array(im2.get_fdata())

# data3 = (data1+data2)>0

# # Fill holes:
# from scipy.ndimage.morphology import binary_fill_holes
# data3 = binary_fill_holes(data3)

# im3 = nb.Nifti1Image(data3, im1.affine, im1.header)
# nb.save(im3, 'Z:\\Scripts\\WIP\\brainmask.nii')


# y, x = np.histogram(data, bins=100)
# x = x[1:]
# plot(x, y)

# kn = KneeLocator(x, y, curve='convex', direction='increasing')

# kn = kn.find_knee()[0]
















