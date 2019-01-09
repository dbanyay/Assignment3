clc
clear all
close all

%% Initialize


filename = 'foreman_qcif.yuv';
%filename = 'mother-daughter_qcif.yuv';

FPS = 30; %Number of Frames per second

num_of_frames = 50;

resolution = [176 144]; %qcif

num_of_blocks = (resolution(1)/16)*(resolution(2)/16);

vid = yuv_import_y(filename, resolution, num_of_frames);

framesM = getFrames(vid,num_of_frames); %Get the frames with dimensions (im_size(1),im_size(2),num_of_frames)
blocks16 = subdivide16(vid);  % subdivide to 16*16 blocks, work in a matrix


%% Intra-Frame Video Coder

%Take DCT of each 16 x 16 block after subdividing into 8 x 8 blocks
dctCoeffs16 = dct8x(blocks16);
% size(dctCoeffs16)

%Quantize all the coefficients using same Q
qStep = 3:6;
num_of_quant_steps = numel(qStep);

qDCT16 = quant(dctCoeffs16,qStep);

%Recovering frames in the dimesnsions equal to blocks16
idctFb = idct16x(qDCT16,qStep,num_of_blocks,num_of_frames);

%Entropy Calculator for 16 x 16 block
ent16x = entroCal(qDCT16,qStep);
% size(ent16x)

%calculating bit-rate for each quantization step
bRate = brEst(ent16x,num_of_blocks,FPS,qStep); %bit-rate in bits/second

%Calculating PSNR for each quantization step
distor = disEst(dctCoeffs16,qDCT16,num_of_frames,num_of_quant_steps); %Distortion = MSE (Original DCT^2, Recovered DCT^2)

avgd = mean(distor);

psnrEachF = psnrCalc(distor);
avgPSNR = mean(psnrEachF);

% figure(1)
% hold on
% % plot((bRate(2:6)/(1024)),(avgd(2:6)),'*-')
% plot((bRate./(1024)),(avgd),'*-')
% xlabel('bit rate in kbits per second')
% ylabel('average distortion')
% title('bit-rate Vs Distortion')

figure
hold on
% plot((bRate(2:6)/(1024)),(avgPSNR(2:6)),'*-')
plot((bRate./(1024)),(avgPSNR),'*-')
xlabel('bit rate in kbits per second')
ylabel('average PSNR in dB')
title('bit-rate Vs PSNR')

slopeBRvsPSNR = gradI(bRate,avgPSNR)

%% Conditional Replenishment Video Coder


[decisions, rep_encoded, bRate_rep] = modeSelection(qDCT16, FPS, qStep, dctCoeffs16);


distor_rep = disEst(dctCoeffs16,rep_encoded,num_of_frames,num_of_quant_steps); %Distortion = MSE (Original DCT^2, Recovered DCT^2)

avgd_rep = mean(distor_rep);

psnrEachF_rep = psnrCalc(distor_rep);
avgPSNR_rep = mean(psnrEachF_rep);

figure
% hold on;
% plot((bRate_rep(2:6)/(1024)),(avgd_rep(2:6)),'*-')
plot((bRate_rep./(1024)),(avgd_rep),'*-')
xlabel('bit rate in kbits per second')
ylabel('average distortion')
title('bit-rate Vs Distortion, Replenished')


figure
% hold on;
% plot((bRate_rep(2:6)/(1024)),(avgPSNR_rep(2:6)),'*-')
plot((bRate_rep./(1024)),(avgPSNR_rep),'*-')
xlabel('bit rate in kbits per second')
ylabel('average PSNR in dB')
title('bit-rate Vs PSNR, Replenished')


slopeBRvsPSNR_rep = gradI(bRate_rep,avgPSNR_rep)


%% Video Coder with Motion Compensation

dispVecs = motionComp(framesM,num_of_frames);

residualF = residCalc(framesM,num_of_frames,dispVecs);

% bitVec = Entropy(-10:10);

%% Residual encoding

bVec = Entropy(-10:10);
bRVec = bVec*(size(dispVecs,1)*size(dispVecs,2)*size(dispVecs,3)*29);

for i = 1:num_of_frames
   
    residualF_cell{i,1} = residualF(:,:,i);
    
end


blocks16_res = subdivide16(residualF_cell);
dctCoeffs16_res = dct8x(blocks16_res);

%Quantize all the coefficients using same Q
qDCT16_res = quant(dctCoeffs16_res,qStep);

%Entropy Calculator for 16 x 16 block

ent16x_res = entroCal(qDCT16_res,qStep);

%calculating bit-rate for each quantization step
bRate_res = brEst(ent16x_res,num_of_blocks,FPS,qStep); %bit-rate in bits/second
bRate_res = bRate_res + bVec; % add size of vectors
%Calculating PSNR for each quantization step
distor_res = disEst(dctCoeffs16_res,qDCT16_res,num_of_frames,num_of_quant_steps); %Distortion = MSE (Original DCT^2, Recovered DCT^2)

avgd_res = mean(distor_res);

psnrEachF_res = psnrCalc(distor_res);
avgPSNR_res = mean(psnrEachF_res);

% figure(1)
% % hold on;
% % plot((bRate_res(2:6)/(1024)),(avgd_res(2:6)),'*-')
% plot((bRate_res./(1024)),(avgd_res),'*-')
% xlabel('bit rate in kbits per second')
% ylabel('average distortion')
% title('bit-rate Vs Distortion, motion comp')
% 

figure(1)
hold on;
% plot((bRate_res(2:6)/(1024)),(avgPSNR_res(2:6)),'*-')
plot((bRate_res./(1024)),(avgPSNR_res),'*-')
xlabel('bit rate in kbits per second')
ylabel('average PSNR in dB')
title('bit-rate Vs PSNR, motion comp')


slopeBRvsPSNR = gradI(bRate,avgPSNR)

