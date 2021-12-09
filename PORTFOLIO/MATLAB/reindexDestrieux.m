clear variables
close all
clc

addpath('C:\spm12')
filepath = 'Z:\Brendan\NOISE_VBM\TEMPLATE\destrieux.nii';

V = spm_vol(filepath);
Y = spm_read_vols(V);


%% no prefix - lower

indices = [
0
2
4
5
7
8
10
11
12
13
14
15
16
17
18
24
26
28
30
31
41
43
44
46
47
49
50
51
52
53
54
58
60
62
63
77
85
];

X = Y.*0;

for k=1:numel(indices)
    index = indices(k);
    X = X + (Y==index).*index;
end

V.fname = 'Z:\Brendan\NOISE_VBM\TEMPLATE\destrieux_A.nii';
spm_write_vol(V, X);


%% no prefix - higher

indices = [
251
252
253
254
255
];

X = Y.*0;

for k=1:numel(indices)
    index = indices(k);
    X = X + (Y==index).*index;
end

V.fname = 'Z:\Brendan\NOISE_VBM\TEMPLATE\destrieux_B.nii';
spm_write_vol(V, X);


%% 111

indices = [
11101
11102
11103
11104
11105
11106
11107
11108
11109
11110
11111
11112
11113
11114
11115
11116
11117
11118
11119
11120
11121
11122
11123
11124
11125
11126
11127
11128
11129
11130
11131
11132
11133
11134
11135
11136
11137
11138
11139
11140
11141
11142
11143
11144
11145
11146
11147
11148
11149
11150
11151
11152
11153
11154
11155
11156
11157
11158
11159
11160
11161
11162
11163
11164
11165
11166
11167
11168
11169
11170
11171
11172
11173
11174
11175
];

X = Y.*0;

for k=1:numel(indices)
    index = indices(k);
    X = X + (Y==index).*(index-11100);
end

V.fname = 'Z:\Brendan\NOISE_VBM\TEMPLATE\destrieux_111.nii';
spm_write_vol(V, X);




%% 121

indices = [
12101
12102
12103
12104
12105
12106
12107
12108
12109
12110
12111
12112
12113
12114
12115
12116
12117
12118
12119
12120
12121
12122
12123
12124
12125
12126
12127
12128
12129
12130
12131
12132
12133
12134
12135
12136
12137
12138
12139
12140
12141
12142
12143
12144
12145
12146
12147
12148
12149
12150
12151
12152
12153
12154
12155
12156
12157
12158
12159
12160
12161
12162
12163
12164
12165
12166
12167
12168
12169
12170
12171
12172
12173
12174
12175
];

X = Y.*0;

for k=1:numel(indices)
    index = indices(k);
    X = X + (Y==index).*(index-12100);
end

V.fname = 'Z:\Brendan\NOISE_VBM\TEMPLATE\destrieux_121.nii';
spm_write_vol(V, X);

