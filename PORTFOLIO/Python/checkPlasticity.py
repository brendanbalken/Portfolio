# -*- coding: utf-8 -*-
"""
Created on Mon Aug 16 10:42:45 2021

@author: Harris Lab
"""

from glob import glob
import pandas as pd


tasks = ['CAP_IO', 'N1P2_IO', 'SlowPresentation', 'AuditoryTetanization', 'VisualTetanization']

summary = pd.DataFrame(data=None, columns=tasks)

for task in tasks:
    PpIDs = []
    blank = ['' for x in range(0, 200)]
    summary[task] = blank
    if task == 'AuditoryTetanization':
        files = glob(f'Z:/Data_Raw/*/Plasticity_Grant/*/{task}/*/*.cdt')
    else:
        files = glob(f'Z:/Data_Raw/*/Plasticity_Grant/*/{task}/*.cdt')
        
    for file in files:
        PpIDs.append(file[12:16])
    PpIDs = list(set(PpIDs))
    blank[0:len(PpIDs)] = PpIDs
    summary[task] = blank

summary.to_clipboard()