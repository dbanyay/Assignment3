function distor = disEst(dctCoeffs16, qDCT16,noF,noQS)

for i = 1:noF
    for j = 1:noQS
        distor(i,j) = sum(sum(sum((dctCoeffs16(:,:,:,i) - qDCT16(:,:,:,i,j)).^2)))./(16*16*size(qDCT16,3));
    end
end

end