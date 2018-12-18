function framesM = getFrames(vid,nof)

im_size = size(vid{1});
framesM = zeros(im_size(1),im_size(2),nof);

for i = 1:nof
    framesM(:,:,i)= vid{i};
end

end