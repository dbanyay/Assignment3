function [residualF, residualIntra] = residCalc(framesM,nof,dispVecs)

%**************************************************************************
%Starting with frame1 and storing it is as it is in residual1 we start by
%calculating the resisual through subtracting the original next frame and
%its prediction made through moving previous frame by
%dispVec(:,ro,co,num_of_frame)
%**************************************************************************

im_size = size(framesM(:,:,1));
residualF = zeros(im_size(1),im_size(2),nof);
residualF(:,:,1) = framesM(:,:,1);
% dispVecs = zeros(2,im_size(1)/16,im_size(2)/16,nof);

for f = 2:50
    prevF = framesM(:,:,f-1);
    currF = framesM(:,:,f);
    
    for ro = 1:9
        for co = 1:11
            rshif = dispVecs(1,ro,co,f-1);
            cshif = dispVecs(2,ro,co,f-1);
            residualF(1+(ro-1)*16:16*ro,1+(co-1)*16:16*co,f) = currF(1+(ro-1)*16:16*ro,1+(co-1)*16:16*co) - prevF(1+(ro-1)*16+rshif:(ro)*16+rshif,1+(co-1)*16+cshif:(co)*16+cshif);
        end
    end
end

end