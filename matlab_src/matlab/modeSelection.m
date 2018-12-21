function [decisionMatrix, replenishment_encoded, entropy16] = modeSelection(qDCT16, FPS)
% Select encoding mode for each 16*16 block

numOfBlocks = size(qDCT16,3);
numOfFrames = size(qDCT16,4);
numOfQuantLevels = size(qDCT16,5);

decisionMatrix = zeros(numOfBlocks, numOfFrames, numOfQuantLevels);
replenishment_encoded = zeros(size(qDCT16));
replenishment_encoded(:,:,:,1,:) = qDCT16(:,:,:,1,:);
entropy16 = zeros(1,size(qDCT16,5));


for quant = 1 : numOfQuantLevels
    R0 = calculateRate(qDCT16(:,:,:,:,quant), FPS)+1;
   
    for frame = 2:numOfFrames
        for block = 1:numOfBlocks
                                   
            stepSize = (2^quant)^2;
            lambda = 0.2*stepSize^2; % Lagrange multiplier
            
            % intra mode
            D0 = sum(sum((qDCT16(:,:,block,frame,quant)^2-qDCT16(:,:,block,frame,1)^2).^2));           
            J0 = D0 + lambda*R0;
            
            % copy mode
            D1 = sum(sum((qDCT16(:,:,block,frame-1,quant)^2-qDCT16(:,:,block,frame,1)^2).^2));
            R1 = 1; % copy flag
            J1 = D1 + lambda*R1;

            if J0 < J1
                decisionMatrix(block,frame,quant) = 0;  % intra mode
                replenishment_encoded(:,:,block,frame,quant) = qDCT16(:,:,block,frame,quant);
                entropy16(quant) = entropy16(quant) + Entropy(reshape(qDCT16(:,:,block,frame,quant),1,[]));
            else
                decisionMatrix(block,frame,quant) = 1;  % copy mode
                replenishment_encoded(:,:,block,frame,quant) = qDCT16(:,:,block,frame-1,quant);
                entropy16(quant) = entropy16(quant) + 1;
            end
        end
    end
end

end

