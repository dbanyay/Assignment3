function psnrEachF = psnrCalc(d)

psnrEachF = 10.*log10((255^2)./d);

end