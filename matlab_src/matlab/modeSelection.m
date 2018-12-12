function decisionMatrix = modeSelection(qDCT16, bRate, FPS)
% Select encoding mode for each 16*16 block

numOfBlocks = size(qDCT16,3);
numOfFrames = size(qDCT16,4);
numOfQuantLevels = size(qDCT16,5);

decisionMatrix = zeros(numOfBlocks, numOfFrames, numOfQuantLevels);

for block = 1 : numOfBlocks
    for frame = 2:numOfFrames
        for quant = 1:numOfQuantLevels
                                   
            stepSize = (2^quant)^2;
            lambda = 0.2*stepSize^2; % Lagrange multiplier
            
            % intra mode
            D0 = immse(qDCT16(:,:,block,frame,1),qDCT16(:,:,block,frame,quant));
            R0 = bRate(quant)/numOfBlocks/FPS;
            R0 = R0 +1; % adding 1 bit for copy flag
            J0 = D0 + lambda*R0;
            
            % copy mode
            D1 = immse(qDCT16(:,:,block,frame-1,quant),qDCT16(:,:,block,frame,1));
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

