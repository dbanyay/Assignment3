function [decisionMatrix, res_encoded, entropy16,distFinal] = modeSelectionMotion(qDCT16, FPS, qStep, unQuantized16, blocks16, dctCoeffs16_res, qDCT16_res, dispVecs, dicts, resblocks)
distFinal = zeros()% Select encoding mode for each 16*16 block

numOfBlocks = size(qDCT16,3);
numOfFrames = size(qDCT16,4);
numOfQuantLevels = size(qDCT16,5);

distFinal = zeros(numOfBlocks,numOfFrames,numOfQuantLevels);
decisionMatrix = zeros(numOfBlocks, numOfFrames, numOfQuantLevels);
res_encoded = zeros(size(qDCT16));
res_encoded(:,:,:,1,:) = qDCT16(:,:,:,1,:);
entropy16 = zeros(1,size(qDCT16,5));


for quant = 1:numOfQuantLevels

    dict = dicts(quant);
    dict = dict{1};
    resdict = getDictValues(qDCT16_res(:,:,:,:,quant));

    frame = 1;
    for block = 1:numOfBlocks
        R0 = calculateBlockRate(dict(block,:,:), qDCT16(:,:,block,frame,quant))+1/(16*16);   
        decisionMatrix(block,frame,quant) = 0;  % intra mode
        res_encoded(:,:,block,frame,quant) = qDCT16(:,:,block,frame,quant);
        entropy16(quant) = entropy16(quant) + R0*16*16;
        D0 = (idct(qDCT16(:,:,block,frame,quant))-idct(unQuantized16(:,:,block,frame))).^2;
        D0 = mean(D0(:));
        distFinal(block,frame,quant) = D0;

    end
   
    for frame = 2:numOfFrames

        for block = 1:numOfBlocks

            lambda = 0.2*2^(qStep(quant))^2; % Lagrange multiplier
            
            % intra mode
            D0 = (idct(qDCT16(:,:,block,frame,quant))-idct(unQuantized16(:,:,block,frame))).^2;
            D0 = mean(D0(:));
            R0 = calculateBlockRate(dict(block,:,:), qDCT16(:,:,block,frame,quant))+2/(16*16);
            J0 = D0 + lambda*R0;
            
            
            D1 = (idct(qDCT16(:,:,block,frame-1,quant))-idct(unQuantized16(:,:,block,frame))).^2;
            D1 = mean(D1(:));
            R1 = 2/(16*16); % copy flag
            J1 = D1 + lambda*R1;
 
            
            % motion vector mode
            curblock = idct2(res_encoded(:,:,block,frame,quant))+ resblocks(:,:,block,frame);
            dRe = ((qDCT16_res(:,:,block,frame,quant) - dctCoeffs16_res(:,:,block,frame)).^2);
            dMC = (blocks16(:,:,block,frame) - resblocks(:,:,block,frame)).^2;
            D2 = dMC + dRe;
%           D2 = (curblock-blocks16(:,:,block,frame)).^2;
            D2 = mean(D2(:));
            R2 = calculateBlockRate(resdict(block,:,:), qDCT16_res(:,:,block,frame,quant))+2/(16*16)+ 2*Entropy(-10:10)/(16*16);
            J2 = D2 + lambda*R2;


            if J0 < J1 && J0 < J2
                decisionMatrix(block,frame,quant) = 0;  % intra mode
                res_encoded(:,:,block,frame,quant) = qDCT16(:,:,block,frame,quant);
                entropy16(quant) = entropy16(quant) + R0*16*16;
                distFinal(block,frame,quant) = D0;
            elseif J1 < J0 && J1 < J2
                decisionMatrix(block,frame,quant) = 1;  % copy mode
                res_encoded(:,:,block,frame,quant) = qDCT16(:,:,block,frame-1,quant);
                entropy16(quant) = entropy16(quant) + R1*16*16;
                distFinal(block,frame,quant) = D1;
            else
                decisionMatrix(block,frame,quant) = 2;  % motion vector mode
                res_encoded(:,:,block,frame,quant) = dct(curblock);
                entropy16(quant) = entropy16(quant) + R2*16*16;
                distFinal(block,frame,quant) = D2;
            end
        end
    end
end
entropy16 = entropy16/numOfFrames*FPS;
end

