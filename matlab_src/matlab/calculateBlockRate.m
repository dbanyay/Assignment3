function R = calculateBlockRate(dict,block)



info = 0;
for row = 1:16
    for col = 1:16
    value = block(row,col);
    occurance = cell2mat(dict(1,row,col));
    index = find(occurance(:,1) == value);
    prob = occurance(index,3);
    info = info-log2(prob);
    end
end
R = info/(16*16);
end

