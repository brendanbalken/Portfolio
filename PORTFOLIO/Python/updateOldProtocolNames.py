from glob import glob
from os import rename
from os.path import split, exists



old_B0s = glob("Z:/Data_Processed/MRI_dicomsort/sorted/*/*/DKI_B0_2.5mm")
old_DKIs = glob("Z:/Data_Processed/MRI_dicomsort/sorted/*/*/DKI1_2.5mm")
old_t1s = glob(r"Z:\Data_Processed\MRI_dicomsort\sorted\*\*\t1_mp2rage_sag_p3_iso\mp2rage_p3*")


for old_DKI in old_DKIs:
    contents = glob(f"{old_DKI}\\*")
    for file in contents:
        if '.nii' in file and not exists(file.replace('DKI1_2.5mm.nii', 'DKI_2.5mm_64dir_50slices.nii')):
            rename(file, file.replace('DKI1_2.5mm.nii', 'DKI_2.5mm_64dir_50slices.nii'))
            print(file.replace('DKI1_2.5mm.nii', 'DKI_2.5mm_64dir_50slices.nii'))
        elif '.json' in file or '.b' in file and not exists(file.replace('DKI1_2.5mm.', 'DKI_2.5mm_64dir_50slices.')):
            rename(file, file.replace('DKI1_2.5mm.', 'DKI_2.5mm_64dir_50slices.'))
            print(file.replace('DKI1_2.5mm.', 'DKI_2.5mm_64dir_50slices.'))
    rename(old_DKI, old_DKI.replace('DKI1_2.5mm', 'DKI_2.5mm_64dir_50slices'))
    print(old_DKI.replace('DKI1_2.5mm', 'DKI_2.5mm_64dir_50slices'))





# for old_t1 in old_t1s:
    # contents = glob(f"{old_t1}\\*")
    # for file in contents:
        # print(file)
        # folder, fname = split(file)
        # if not '.' in fname:
            # continue
        # fname, ext = fname.split('.')
        # letter = fname[-1]
        # if letter == '.':
            # letter = ''
        # if '.nii' in file and not exists(file.replace(f'{fname}.{ext}', f't1_mp2rage_sag_p3_iso{letter}.{ext}')):
            # rename(file, file.replace(f'{fname}.{ext}', f't1_mp2rage_sag_p3_iso{letter}.{ext}'))
            # print(file.replace(f'{fname}.{ext}', f't1_mp2rage_sag_p3_iso{letter}.{ext}'))
        # elif '.json' in file and not exists(file.replace(f'{fname}.{ext}', f't1_mp2rage_sag_p3_iso{letter}.{ext}')):
            # rename(file, file.replace(f'{fname}.{ext}', f't1_mp2rage_sag_p3_iso{letter}.{ext}'))
            # print(file.replace(f'{fname}.{ext}', f't1_mp2rage_sag_p3_iso{letter}.{ext}'))
    # rename(old_t1, old_t1.replace('mp2rage_p3', 't1_mp2rage_sag_p3_iso'))
    # print(old_t1.replace('mp2rage_p3', 't1_mp2rage_sag_p3_iso'))


print('Done!')
input()