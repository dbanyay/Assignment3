clear all
close all


%% Initialize

filename = 'foreman_qcif/foreman_qcif.yuv';
%filename = 'mother_daugther_qcif/mother_daugther_qcif.yuv';

num_of_frames = 50;

resolution = [176 144]; %qcif

vid = yuv_import_y(filename, resolution, num_of_frames);



%% Intra-Frame Video Coder


%% Conditional Replenishment Video Coder

%% Video Coder with Motion Compensation