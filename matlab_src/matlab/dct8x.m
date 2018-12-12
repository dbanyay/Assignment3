function [dct4x8] = dct8x(vid16x)

%Subdivides each 16 x 16 block into 4 8x8 blocks and takes dct

nof = size(vid16x,4);                  %number of frames
nob = size(vid16x,3);                  %number of 16x16 block in each frame
dct4x8 = zeros(size(vid16x));

for k = 1:nof
    for j = 1:nob
        for ir = 1:2
            for ic = 1:2
                dct4x8(1+8*(ir-1):8*(ir),1+8*(ic-1):8*(ic),j,k) = dct2(vid16x(1+8*(ir-1):8*(ir),1+8*(ic-1):8*(ic),j,k));
            end
        end
    end
end

end