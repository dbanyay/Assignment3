function decisionMatrix = modeSelection(qDCT16, FPS)
% Select encoding mode for each 16*16 block

numOfBlocks = size(qDCT16,3);
numOfFrames = size(qDCT16,4);
numOfQuantLevels = size(qDCT16,5);

decisionMatrix = zeros(numOfBlocks, numOfFrames, numOfQuantLevels);

for quant = 1 : numOfQuantLevels
    R0 = calculateRate(qDCT16(:,:,:,:,quant), FPS)+1;
   
    for frame = 2:numOfFrames
        for block = 1:numOfBlocks
                                   
            stepSize = (2^quant)^2;
            lambda = 0.2*stepSize^2; % Lagrange multiplier
            
            % intra mode
            D0 = sum(sum((qDCT16(:,:,block,frame,quant)-qDCT16(:,:,block,frame,1)).^2));           
            J0 = D0 + lambda*R0;
            
            % copy mode
            D1 = sum(sum((qDCT16(:,:,block,frame-1,quant)-qDCT16(:,:,block,frame,1)).^2));
            R1 = 1; % copy flag
            J1 = D1 + lambda*R1;

            if J0 < J1
                decisionMatrix(block,frame,quant) = 0;  % intra mode
            else
                decisionMatrix(block,frame,quant) = 1;  % copy mode
            end
        end
    end
end

end

