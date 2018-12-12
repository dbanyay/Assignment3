function ent16x = entroCal(qDCT16)
%Input is of size [brows=16 bcols=16 nob=99 nof=50 noQS=10]
%Output is of size [brows=16 bcols=16 noQS=10]

for i = 1:10                        %qStep
    for j = 1:16                    %bcol
        for k = 1:16                %brow
            a = (qDCT16(k,j,:,:,i));
            vec = reshape(a,1,[]);
            ent16x(k,j,i) = Entropy(vec);
        end
    end
end
end