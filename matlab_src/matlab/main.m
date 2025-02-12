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

figure(1)
hold on
% plot((bRate(2:6)/(1024)),(avgPSNR(2:6)),'*-')
plot((bRate./(1024)),(avgPSNR),'*-')
xlabel('bit rate in kbits per second')
ylabel('average PSNR in dB')
title('bit-rate Vs PSNR')

slopeBRvsPSNR = gradI(bRate,avgPSNR)

%% Conditional Replenishment Video Coder


[decisions, rep_encoded, bRate_rep, dict] = modeSelection(qDCT16, FPS, qStep, dctCoeffs16);


distor_rep = disEst(dctCoeffs16,rep_encoded,num_of_frames,num_of_quant_steps); %Distortion = MSE (Original DCT^2, Recovered DCT^2)

avgd_rep = mean(distor_rep);

psnrEachF_rep = psnrCalc(distor_rep);
avgPSNR_rep = mean(psnrEachF_rep);

figure(1)
hold on;
% plot((bRate_rep(2:6)/(1024)),(avgPSNR_rep(2:6)),'*-')
plot((bRate_rep./(1024)),(avgPSNR_rep),'*-')
xlabel('bit rate in kbits per second')
ylabel('average PSNR in dB')
title('bit-rate Vs PSNR, Replenished')

values = zeros(4,2);
for i = 1:4
    zeros = length(decisions(decisions(:,:,i) == 0));
    ones = length(decisions(decisions(:,:,i) == 1));
    values(i,1) = zeros;
    values(i,2) = ones;
end

figure
bar(values,'stacked')
legend('Intra mode','Copy mode')
xticks([1 2 3 4])
xticklabels({'2^3','2^4','2^5','2^6'})
title('Comparing Intra and Copy mode coded blocks')

slopeBRvsPSNR_rep = gradI(bRate_rep,avgPSNR_rep)


%% Video Coder with Motion Compensation

[dispVecs, blockRes] = motionComp(framesM,num_of_frames);
residualF = residCalc(framesM,num_of_frames,dispVecs);



% bitVec = Entropy(-10:10);

%% Residual encoding

% bVec = Entropy(-10:10);
% bRVec = bVec*(size(dispVecs,1)*size(dispVecs,2)*size(dispVecs,3)*29);

for i = 1:num_of_frames   
    residualF_cell{i,1} = residualF(:,:,i);    
end


blocks16_res = subdivide16(residualF_cell);
dctCoeffs16_res = dct8x(blocks16_res);

%Quantize all the coefficients using same Q
qDCT16_res = quant(dctCoeffs16_res,qStep);


[decisions_res, res_encoded, bRate_res, distMC] = modeSelectionMotion(qDCT16, FPS, qStep, dctCoeffs16, blocks16, dctCoeffs16_res, qDCT16_res, dispVecs, dict, blockRes);
%Entropy Calculator for 16 x 16 block

% distor_res = disEst(dctCoeffs16,res_encoded,num_of_frames,num_of_quant_steps); %Distortion = MSE (Original DCT^2, Recovered DCT^2)
for qunt = 1: 4
    for fr = 1:50
        distor_res(fr,qunt) = mean(distMC(:,fr,qunt));
    end
end

avgd_res = mean(distor_res);

psnrEachF_res = psnrCalc(distor_res);
avgPSNR_res = mean(psnrEachF_res);


figure(1)
hold on;
% plot((bRate_res(2:6)/(1024)),(avgPSNR_res(2:6)),'*-')
plot((bRate_res./(1024)),(avgPSNR_res),'*-')
xlabel('bit rate in kbits per second')
ylabel('average PSNR in dB')
title('bit-rate Vs PSNR, motion comp')

for i = 1:4
    zeros = length(decisions_res(decisions_res(:,:,i) == 0));
    ones = length(decisions_res(decisions_res(:,:,i) == 1));
    twos = length(decisions_res(decisions_res(:,:,i) == 2));
    values_r(i,1) = zeros;
    values_r(i,2) = ones;
    values_r(i,3) = twos;
end

figure

bar(values_r,'stacked')
legend('Intra mode','Copy mode', 'Motion vector')
xticks([1 2 3 4])
xticklabels({'2^3','2^4','2^5','2^6'})
title('Comparing Intra, Copy mode and Motion vector coded blocks')
slopeBRvsPSNR = gradI(bRate,avgPSNR)