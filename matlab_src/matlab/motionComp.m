function [dispVecs, blockRes] = motionComp(framesM,nof)

blockRes = zeros(16,16,99,50);
im_size = size(framesM(:,:,1));
crF = framesM(:,:,2);      %previous frame
prF = framesM(:,:,1);      %current frame
dispVecs = zeros(2,im_size(1)/16,im_size(2)/16,nof-1);    %Shows the displacement in x and y directions of the previous frame into the current frame

for f = 2:50
    bkNum = 1;
    for ro = 1:im_size(1)/16
        for co = 1:im_size(2)/16
            if((ro == 1) & (co == 1))
                mseR = zeros(11);
                for rshif = 0:10
                    for cshif = 0:10
                        mseR(rshif+1,cshif+1) = sum(sum(((crF(1+(ro-1)*16:(ro)*16,1+(co-1)*16:(co)*16) - prF(1+(ro-1)*16+rshif:(ro)*16+rshif,1+(co-1)*16+cshif:(co)*16+cshif)).^2)))/(16*16);
                    end
                end
                minimum = min(min(mseR));
                [x,y] = find(mseR==minimum);
                dispVecs(1,ro,co,f) = x(1) - 1;
                dispVecs(2,ro,co,f) = y(1) - 1;
                blockRes(:,:,bkNum,f) = prF(1+(ro-1)*16+dispVecs(1,ro,co,f):(ro)*16+dispVecs(1,ro,co,f),1+(co-1)*16+dispVecs(2,ro,co,f):(co)*16+dispVecs(2,ro,co,f));
            elseif((ro == 9) & (co == 11))
                mseR = zeros(11);
                for rshif = -10:0
                    for cshif = -10:0
                        mseR(rshif+11,cshif+11) = sum(sum(((crF(1+(ro-1)*16:(ro)*16,1+(co-1)*16:(co)*16) - prF(1+(ro-1)*16+rshif:(ro)*16+rshif,1+(co-1)*16+cshif:(co)*16+cshif)).^2)))/(16*16);
                    end
                end
                minimum = min(min(mseR));
                [x,y] = find(mseR==minimum);
                dispVecs(1,ro,co,f) = x(1) - 11;
                dispVecs(2,ro,co,f) = y(1) - 11;
                blockRes(:,:,bkNum,f) = prF(1+(ro-1)*16+dispVecs(1,ro,co,f):(ro)*16+dispVecs(1,ro,co,f),1+(co-1)*16+dispVecs(2,ro,co,f):(co)*16+dispVecs(2,ro,co,f));
            elseif((co == 1) & (ro == 9))
                mseR = zeros(11);
                for cshif = 0:10
                    for rshif = -10:0
                        mseR(rshif+11,cshif+1) = sum(sum(((crF(1+(ro-1)*16:(ro)*16,1+(co-1)*16:(co)*16) - prF(1+(ro-1)*16+rshif:(ro)*16+rshif,1+(co-1)*16+cshif:(co)*16+cshif)).^2)))/(16*16);
                    end
                end
                minimum = min(min(mseR));
                [x,y] = find(mseR==minimum);
                dispVecs(1,ro,co,f) = x(1) - 11;
                dispVecs(2,ro,co,f) = y(1) - 1;                 
                blockRes(:,:,bkNum,f) = prF(1+(ro-1)*16+dispVecs(1,ro,co,f):(ro)*16+dispVecs(1,ro,co,f),1+(co-1)*16+dispVecs(2,ro,co,f):(co)*16+dispVecs(2,ro,co,f));
            elseif((ro == 1) & (co == 11))
                mseR = zeros(11);
                for rshif = 0:10
                    for cshif = -10:0
                        mseR(rshif+1,cshif+11) = sum(sum(((crF(1+(ro-1)*16:(ro)*16,1+(co-1)*16:(co)*16) - prF(1+(ro-1)*16+rshif:(ro)*16+rshif,1+(co-1)*16+cshif:(co)*16+cshif)).^2)))/(16*16);
                    end
                end
                minimum = min(min(mseR));
                [x,y] = find(mseR==minimum);
                dispVecs(1,ro,co,f) = x(1) - 1;
                dispVecs(2,ro,co,f) = y(1) - 11;
                f
                blockRes(:,:,bkNum,f) = prF(1+(ro-1)*16+dispVecs(1,ro,co,f):(ro)*16+dispVecs(1,ro,co,f),1+(co-1)*16+dispVecs(2,ro,co,f):(co)*16+dispVecs(2,ro,co,f));
            elseif(((ro == 1) & (co ~= 1)) & ((ro == 1) & (co ~= 11)))
                mseR = zeros(11,21);
                for rshif = 0:10
                    for cshif = -10:10
                        mseR(rshif+1,cshif+11) = sum(sum(((crF(1+(ro-1)*16:(ro)*16,1+(co-1)*16:(co)*16) - prF(1+(ro-1)*16+rshif:(ro)*16+rshif,1+(co-1)*16+cshif:(co)*16+cshif)).^2)))/(16*16);
                    end
                end
                minimum = min(min(mseR));
                [x,y] = find(mseR==minimum);
                dispVecs(1,ro,co,f) = x(1) - 1;
                dispVecs(2,ro,co,f) = y(1) - 11;
                blockRes(:,:,bkNum,f) = prF(1+(ro-1)*16+dispVecs(1,ro,co,f):(ro)*16+dispVecs(1,ro,co,f),1+(co-1)*16+dispVecs(2,ro,co,f):(co)*16+dispVecs(2,ro,co,f));
            elseif(((co == 1) & (ro ~= 1)) & ((co == 1) & (ro ~= 9)))
                mseR = zeros(21,11);
                for cshif = 0:10
                    for rshif = -10:10
                        mseR(rshif+11,cshif+1) = sum(sum(((crF(1+(ro-1)*16:(ro)*16,1+(co-1)*16:(co)*16) - prF(1+(ro-1)*16+rshif:(ro)*16+rshif,1+(co-1)*16+cshif:(co)*16+cshif)).^2)))/(16*16);
                    end
                end
                minimum = min(min(mseR));
                [x,y] = find(mseR==minimum);
                dispVecs(1,ro,co,f) = x(1) - 11;
                dispVecs(2,ro,co,f) = y(1) - 1;                 
                blockRes(:,:,bkNum,f) = prF(1+(ro-1)*16+dispVecs(1,ro,co,f):(ro)*16+dispVecs(1,ro,co,f),1+(co-1)*16+dispVecs(2,ro,co,f):(co)*16+dispVecs(2,ro,co,f));
            elseif(((ro == 9) & (co ~= 1)) & ((ro == 9) & (co ~= 11)))
                mseR = zeros(11,21);
                for cshif = -10:10
                    for rshif = -10:0
                        mseR(rshif+11,cshif+11) = sum(sum(((crF(1+(ro-1)*16:(ro)*16,1+(co-1)*16:(co)*16) - prF(1+(ro-1)*16+rshif:(ro)*16+rshif,1+(co-1)*16+cshif:(co)*16+cshif)).^2)))/(16*16);
                    end
                end
                minimum = min(min(mseR));
                [x,y] = find(mseR==minimum);
                dispVecs(1,ro,co,f) = x(1) - 11;
                dispVecs(2,ro,co,f) = y(1) - 11;                 
                blockRes(:,:,bkNum,f) = prF(1+(ro-1)*16+dispVecs(1,ro,co,f):(ro)*16+dispVecs(1,ro,co,f),1+(co-1)*16+dispVecs(2,ro,co,f):(co)*16+dispVecs(2,ro,co,f));
            elseif(((co == 11) & (ro ~= 1)) & ((co == 11) & (ro ~= 9)))
                mseR = zeros(21,11);
                for cshif = -10:0
                    for rshif = -10:10
                        mseR(rshif+11,cshif+11) = sum(sum(((crF(1+(ro-1)*16:(ro)*16,1+(co-1)*16:(co)*16) - prF(1+(ro-1)*16+rshif:(ro)*16+rshif,1+(co-1)*16+cshif:(co)*16+cshif)).^2)))/(16*16);
                    end
                end
                minimum = min(min(mseR));
                [x,y] = find(mseR==minimum);
                dispVecs(1,ro,co,f) = x(1) - 11;
                dispVecs(2,ro,co,f) = y(1) - 11;                 
                blockRes(:,:,bkNum,f) = prF(1+(ro-1)*16+dispVecs(1,ro,co,f):(ro)*16+dispVecs(1,ro,co,f),1+(co-1)*16+dispVecs(2,ro,co,f):(co)*16+dispVecs(2,ro,co,f));
            else                
                mseR = zeros(21,21);
                for cshif = -10:10
                    for rshif = -10:10
                        mseR(rshif+11,cshif+11) = sum(sum(((crF(1+(ro-1)*16:(ro)*16,1+(co-1)*16:(co)*16) - prF(1+(ro-1)*16+rshif:(ro)*16+rshif,1+(co-1)*16+cshif:(co)*16+cshif)).^2)))/(16*16);
                    end
                end
                minimum = min(min(mseR));
                [x,y] = find(mseR==minimum);
                dispVecs(1,ro,co,f) = x(1) - 11;
                dispVecs(2,ro,co,f) = y(1) - 11;                                 
                blockRes(:,:,bkNum,f) = prF(1+(ro-1)*16+dispVecs(1,ro,co,f):(ro)*16+dispVecs(1,ro,co,f),1+(co-1)*16+dispVecs(2,ro,co,f):(co)*16+dispVecs(2,ro,co,f));
            end
            bkNum = bkNum + 1;
        end
    end
    if f == 50
        disp('Finished')
    else
        crF = framesM(:,:,f+1);      %current frame
        prF = framesM(:,:,f);      %previous frame
    end
    
end

end