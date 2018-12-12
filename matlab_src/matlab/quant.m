function [qDCT16] = quant(dctCoeffs16,qStep)

for i = 1:numel(qStep)
    qDCT16(:,:,:,:,i) = qStep(i)*floor((dctCoeffs16/qStep(i)) + (1/2));
end
end