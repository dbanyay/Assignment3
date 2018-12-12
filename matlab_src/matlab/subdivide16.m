function blocks16 = subdivide16(vid)
% Subdivide video frames into 16*16 blocks

imsize = size(vid{1});

blocks16 = zeros(16,16,imsize(1)/16*imsize(2)/16, size(vid,1));

rowblocks = imsize(1)/16;
colblocks = imsize(2)/16;

for frame =  1:1:size(vid,1)
    
    for row = 1:rowblocks
        for col = 1:colblocks
            
            block = (row-1)*colblocks + col;
            blocks16(:,:,block,frame) = vid{frame}((row-1)*16+1:row*16,(col-1)*16+1:col*16);               
            
        end
    end

end

