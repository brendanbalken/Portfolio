%-----------------------------------------------------------------------
% Job saved on 14-Apr-2021 12:53:39 by cfg_util (rev $Rev: 7345 $)
% spm SPM - SPM12 (7771)
% cfg_basicio BasicIO - Unknown
%-----------------------------------------------------------------------

files = dir('Z:\CISS\*.nii');
files = strcat({files.folder}', '\', {files.name}');
for k=1:numel(files)
    PpID = files{k}(9:12);
    
    V = spm_vol(['Z:\CISS\' PpID '.nii']);
    Y = spm_read_vols(V);
    V.fname = ['Z:\CISS\' PpID '_inv.nii'];
    
    Y = -Y + max(Y(:));
    
    spm_write_vol(V, Y);
    error('STOP')
end
