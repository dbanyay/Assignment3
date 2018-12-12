function decisionMatrix = modeSelection(blocks,qDCT16)
% Select encoding mode for each 16*16 block

numOfBlocks = size(qDCT16,3);
numOfFrames = size(qDCT16,4);
numOfQuantLevels = size(qDCT16,5);

decisionMatrix = zeros(numOfBlocks, numOfFrames, numOfQuantLevels);

for block = 1 : numOfBlocks
    for frame = 1:numOfFrames
        for quant = 1:numOfQuantLevels            
            
            stepSize = (2^quant)^2;
            lambda = 0.2*stepSize^2; % Lagrange multiplier

            D0 = immse(qDCT(:,:,block,frame,1),qDCT(:,:,block,frame,quant));
            R0 = ratematrix(1,1,1);
            R0 = R0 +1; % adding 1 bit for copy flag
            J0 = D0 + lambda*R0;

            D1 = immse(qDCT(:,:,block,frame,1),qDCT(:,:,block,frame,quant));
            R1 = 1; % copy flag
            J1 = D1 + lambda*R1;

            if J0 > J1
                decisionMatrix(block,frame,quant) = 0;  % intra mode
            else
                decisionMatrix(block,frame,quant) = 1;  % copy mode
            end
        end
    end
end

end

