function bRate = brEst(ent16x,nob,nofps,qStep)

for i = 1:(numel(qStep))
    bRate(i) = (sum(sum(ent16x(:,:,i)))).*(nob*nofps);
end

end