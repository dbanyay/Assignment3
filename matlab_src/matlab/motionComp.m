function dispVecs = motionComp(framesM,nof)

im_size = size(framesM(:,:,1));
prevF = framesM(:,:,1);      %previous frame
currF = framesM(:,:,2);      %current frame
dispVecs = zeros(2,im_size(1)/16,im_size(2)/16,nof-1);    %Shows the displacement in x and y directions of the previous frame into the current frame

for f = 1:49
    for ro = 1:im_size(1)/16
        for co = 1:im_size(2)/16
            if((ro == 1) & (co == 1))
                mseR = zeros(11);
                for rshif = 0:10
                    for cshif = 0:10
                        mseR(rshif+1,cshif+1) = sum(sum(((prevF(1+(ro-1)*16:(ro)*16,1+(co-1)*16:(co)*16) - currF(1+(ro-1)*16+rshif:(ro)*16+rshif,1+(co-1)*16+cshif:(co)*16+cshif)).^2)))/(16*16);
                    end
                end
                minimum = min(min(mseR));
                [x,y] = find(mseR==minimum);
                dispVecs(1,ro,co,f) = x(1) - 1;
                dispVecs(2,ro,co,f) = y(1) - 1;                
            elseif((ro == 9) & (co == 11))
                mseR = zeros(11);
                for rshif = -10:0
                    for cshif = -10:0
                        mseR(rshif+11,cshif+11) = sum(sum(((prevF(1+(ro-1)*16:(ro)*16,1+(co-1)*16:(co)*16) - currF(1+(ro-1)*16+rshif:(ro)*16+rshif,1+(co-1)*16+cshif:(co)*16+cshif)).^2)))/(16*16);
                    end
                end
                minimum = min(min(mseR));
                [x,y] = find(mseR==minimum);
                dispVecs(1,ro,co,f) = x(1) - 11;
                dispVecs(2,ro,co,f) = y(1) - 11;
            elseif((co == 1) & (ro == 9))
                mseR = zeros(11);
                for cshif = 0:10
                    for rshif = -10:0
                        mseR(rshif+11,cshif+1) = sum(sum(((prevF(1+(ro-1)*16:(ro)*16,1+(co-1)*16:(co)*16) - currF(1+(ro-1)*16+rshif:(ro)*16+rshif,1+(co-1)*16+cshif:(co)*16+cshif)).^2)))/(16*16);
                    end
                end
                minimum = min(min(mseR));
                [x,y] = find(mseR==minimum);
                dispVecs(1,ro,co,f) = x(1) - 11;
                dispVecs(2,ro,co,f) = y(1) - 1;                 
            elseif((ro == 1) & (co == 11))
                mseR = zeros(11);
                for rshif = 0:10
                    for cshif = -10:0
                        mseR(rshif+1,cshif+11) = sum(sum(((prevF(1+(ro-1)*16:(ro)*16,1+(co-1)*16:(co)*16) - currF(1+(ro-1)*16+rshif:(ro)*16+rshif,1+(co-1)*16+cshif:(co)*16+cshif)).^2)))/(16*16);
                    end
                end
                minimum = min(min(mseR));
                [x,y] = find(mseR==minimum);
                dispVecs(1,ro,co,f) = x(1) - 1;
                dispVecs(2,ro,co,f) = y(1) - 11;
            elseif(((ro == 1) & (co ~= 1)) & ((ro == 1) & (co ~= 11)))
                mseR = zeros(11,21);
                for rshif = 0:10
                    for cshif = -10:10
                        mseR(rshif+1,cshif+11) = sum(sum(((prevF(1+(ro-1)*16:(ro)*16,1+(co-1)*16:(co)*16) - currF(1+(ro-1)*16+rshif:(ro)*16+rshif,1+(co-1)*16+cshif:(co)*16+cshif)).^2)))/(16*16);
                    end
                end
                minimum = min(min(mseR));
                [x,y] = find(mseR==minimum);
                dispVecs(1,ro,co,f) = x(1) - 1;
                dispVecs(2,ro,co,f) = y(1) - 11; 
            elseif(((co == 1) & (ro ~= 1)) & ((co == 1) & (ro ~= 9)))
                mseR = zeros(21,11);
                for cshif = 0:10
                    for rshif = -10:10
                        mseR(rshif+11,cshif+1) = sum(sum(((prevF(1+(ro-1)*16:(ro)*16,1+(co-1)*16:(co)*16) - currF(1+(ro-1)*16+rshif:(ro)*16+rshif,1+(co-1)*16+cshif:(co)*16+cshif)).^2)))/(16*16);
                    end
                end
                minimum = min(min(mseR));
                [x,y] = find(mseR==minimum);
                dispVecs(1,ro,co,f) = x(1) - 11;
                dispVecs(2,ro,co,f) = y(1) - 1;                 
            elseif(((ro == 9) & (co ~= 1)) & ((ro == 9) & (co ~= 11)))
                mseR = zeros(11,21);
                for cshif = -10:10
                    for rshif = -10:0
                        mseR(rshif+11,cshif+11) = sum(sum(((prevF(1+(ro-1)*16:(ro)*16,1+(co-1)*16:(co)*16) - currF(1+(ro-1)*16+rshif:(ro)*16+rshif,1+(co-1)*16+cshif:(co)*16+cshif)).^2)))/(16*16);
                    end
                end
                minimum = min(min(mseR));
                [x,y] = find(mseR==minimum);
                dispVecs(1,ro,co,f) = x(1) - 11;
                dispVecs(2,ro,co,f) = y(1) - 11;                 
            elseif(((co == 11) & (ro ~= 1)) & ((co == 11) & (ro ~= 9)))
                mseR = zeros(21,11);
                for cshif = -10:0
                    for rshif = -10:10
                        mseR(rshif+11,cshif+11) = sum(sum(((prevF(1+(ro-1)*16:(ro)*16,1+(co-1)*16:(co)*16) - currF(1+(ro-1)*16+rshif:(ro)*16+rshif,1+(co-1)*16+cshif:(co)*16+cshif)).^2)))/(16*16);
                    end
                end
                minimum = min(min(mseR));
                [x,y] = find(mseR==minimum);
                dispVecs(1,ro,co,f) = x(1) - 11;
                dispVecs(2,ro,co,f) = y(1) - 11;                 
            else                
                mseR = zeros(21,21);
                for cshif = -10:10
                    for rshif = -10:10
                        mseR(rshif+11,cshif+11) = sum(sum(((prevF(1+(ro-1)*16:(ro)*16,1+(co-1)*16:(co)*16) - currF(1+(ro-1)*16+rshif:(ro)*16+rshif,1+(co-1)*16+cshif:(co)*16+cshif)).^2)))/(16*16);
                    end
                end
                minimum = min(min(mseR));
                [x,y] = find(mseR==minimum);
                dispVecs(1,ro,co,f) = x(1) - 11;
                dispVecs(2,ro,co,f) = y(1) - 11;                                 
            end
        end
    end
    prevF = framesM(:,:,f);      %current frame
    currF = framesM(:,:,f+1);      %predicted frame
    
end

% X1 = unique(dispVecs(1,:,:,:))
% X2 = unique(dispVecs(2,:,:,:))

end