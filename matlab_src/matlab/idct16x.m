function idctFb = idct16x(qDCT16)

nob = 99;
nof = 50;
qSteps = 10;

for q = 1:qSteps
    for f = 1:nof
        for b = 1:nob
            for i = 1:2
                for j = 1:2
                    idctFb(1+(i-1)*8:8*i,1+(j-1)*8:8*j,nob,nof,q) = idct2(qDCT16(1+(i-1)*8:8*i,1+(j-1)*8:8*j,nob,nof,q));
                end
            end
        end
    end
end

end