function bRate = brEst(ent16x,nob,nofps)

size(ent16x)
for i = 1:10
    bRate(i) = (sum(sum(ent16x(:,:,i))))*(nob*nofps);
end

end