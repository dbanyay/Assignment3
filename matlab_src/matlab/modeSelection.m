function [decisionMatrix, replenishment_encoded, entropy16] = modeSelection(qDCT16, FPS, qStep, unQuantized16)
% Select encoding mode for each 16*16 block

numOfBlocks = size(qDCT16,3);
numOfFrames = size(qDCT16,4);
numOfQuantLevels = size(qDCT16,5);

decisionMatrix = zeros(numOfBlocks, numOfFrames, numOfQuantLevels);
replenishment_encoded = zeros(size(qDCT16));
replenishment_encoded(:,:,:,1,:) = qDCT16(:,:,:,1,:);
entropy16 = zeros(1,size(qDCT16,5));


for quant = 1:numOfQuantLevels
    occurance = calculateRate(qDCT16(:,:,:,:,quant), FPS);
   
    for frame = 2:numOfFrames
        for block = 1:numOfBlocks

            lambda = 0.2*2^(qStep(quant))^2; % Lagrange multiplier
            
            % intra mode
            D0 = (qDCT16(:,:,block,frame,quant)-unQuantized16(:,:,block,frame)).^2;
            D0 = mean(D0(:));
            R0 = calculateBlockRate(occurance, qDCT16(:,:,block,frame,quant))+1;
            J0 = D0 + lambda*R0;
            
            % copy mode
            D1 = (qDCT16(:,:,block,frame-1,quant)-unQuantized16(:,:,block,frame)).^2;
            D1 = mean(D1(:));
            R1 = 1/(16*16); % copy flag
            J1 = D1 + lambda*R1;

            if J0 < J1
                decisionMatrix(block,frame,quant) = 0;  % intra mode
                replenishment_encoded(:,:,block,frame,quant) = qDCT16(:,:,block,frame,quant);
                entropy16(quant) = entropy16(quant) + R0*16*16;
            else
                decisionMatrix(block,frame,quant) = 1;  % copy mode
                replenishment_encoded(:,:,block,frame,quant) = qDCT16(:,:,block,frame-1,quant);
                entropy16(quant) = entropy16(quant) + R1*16*16;
            end
        end
    end
end


end

