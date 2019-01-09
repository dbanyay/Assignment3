function occurance = calculateRate(block16,FPS)
% Calculate rate for a 16x16 block


occurance = tabulate(block16(:));   % calculate pixel occurances

occurance(:,3) = occurance(:,3)/100; % probabilities

% R = sum(-log2(P));
% 
% R = R/size(block16,3);  % rate for a single image
% 
% R = R/size(block16,2);  % rate for a single block
% 
% R = R*FPS;             % rate for a single block per sec


end

