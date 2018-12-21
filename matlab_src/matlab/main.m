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

%Take DCT of each 16 x 16 block after subdividing into 8 x x blocks
dctCoeffs16 = dct8x(blocks16);

%Quantize all the coefficients using same Q
qStep = 3:6;
num_of_quant_steps = 4;

qDCT16 = quant(dctCoeffs16,qStep);

%Recovering frames in the dimesnsions equal to blocks16
idctFb = idct16x(qDCT16,qStep,num_of_blocks,num_of_frames);

%Entropy Calculator for 16 x 16 block

ent16x = entroCal(qDCT16,qStep);

%calculating bit-rate for each quantization step
bRate = brEst(ent16x,num_of_blocks,FPS,qStep); %bit-rate in bits/second

%Calculating PSNR for each quantization step
distor = disEst(blocks16,idctFb,num_of_frames,num_of_quant_steps); %Distortion = MSE (Original Image, Recovered Image)
distor = disEst(dctCoeffs16,qDCT16,num_of_frames,num_of_quant_steps); %Distortion = MSE (Original DCT^2, Recovered DCT^2)

avgd = mean(distor);

psnrEachF = psnrCalc(distor);
avgPSNR = mean(psnrEachF);

figure()
% plot((bRate(3:5)/(1024)),(avgd(3:5)),'*-')
plot((bRate./(1024)),(avgd),'*-')
xlabel('bit rate in kbits per second')
ylabel('average distortion')
title('bit-rate Vs Distortion')

figure()
% plot((bRate(3:5)/(1024)),(avgPSNR(3:5)),'*-')
plot((bRate./(1024)),(avgPSNR),'*-')
xlabel('bit rate in kbits per second')
ylabel('average PSNR in dB')
title('bit-rate Vs PSNR')

slopeBRvsPSNR = gradI(bRate,avgPSNR)

%% Conditional Replenishment Video Coder


[decisions, rep_encoded, bRate_rep] = modeSelection(qDCT16, FPS);
bRate_rep(1) = bRate(1);

distor_rep = disEst(dctCoeffs16,rep_encoded,num_of_frames,num_of_quant_steps); %Distortion = MSE (Original DCT^2, Recovered DCT^2)

avgd_rep = mean(distor_rep);

psnrEachF_rep = psnrCalc(distor_rep);
avgPSNR_rep = mean(psnrEachF_rep);

figure()
plot((bRate(3:5)/(1024)),(avgd(3:5)),'*-')
%plot((bRate_rep./(1024)),(avgd_rep),'*-')
xlabel('bit rate in kbits per second')
ylabel('average distortion')
title('bit-rate Vs Distortion, Replenished')

figure()
plot((bRate(3:5)/(1024)),(avgPSNR(3:5)),'*-')
%plot((bRate_rep./(1024)),(avgPSNR_rep),'*-')
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

