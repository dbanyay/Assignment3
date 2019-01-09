function [qDCT16] = quant(dctCoeffs16,qStep)

for i = 1:numel(qStep)
%     qDCT16(:,:,:,:,i) = qStep(i)*floor((dctCoeffs16/qStep(i)) + (1/2));
    qDCT16(:,:,:,:,i) = (2^qStep(i))*round(dctCoeffs16/(2^qStep(i)));
end
end