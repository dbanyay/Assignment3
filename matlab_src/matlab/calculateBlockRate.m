function R = calculateBlockRate(occurance,block)

elements = block(:);
info = 0;
for i = 1:length(elements)
    value = elements(i);
    index = find(occurance(:,1) == value);
    prob = occurance(index,3);
    info = info-log2(prob);
end
R = info/(16*16);
end

