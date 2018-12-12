clc
clear all
close all


%% Initialize

filename = 'foreman_qcif/foreman_qcif.yuv';
%filename = 'mother_daugther_qcif/mother_daugther_qcif.yuv';

num_of_frames = 50;

resolution = [176 144]; %qcif

vid = yuv_import_y(filename, resolution, num_of_frames);

blocks16 = subdivide16(vid);  % subdivide to 16*16 blocks, work in a matrix

%% Intra-Frame Video Coder


%Divide the video into blocks of 16 x 16

%Take DCT of each 16 x 16 block after subdividing into 8 x x blocks

dctCoeffs16 = dct8x(tImg);



%Quantize all the coefficients using same Q




%% Conditional Replenishment Video Coder

decisions = modeSelection(blocks16);

%% Video Coder with Motion Compensation