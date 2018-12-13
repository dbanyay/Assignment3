function distor = disEst(dctCoeffs16, qDCT16)

for i = 1:50
    for j = 1:10    
        distor(i,j) = sum(sum(sum((dctCoeffs16(:,:,:,i) - qDCT16(:,:,:,i,j)).^2)))./(16*16*size(qDCT16,3));
    end
end

end