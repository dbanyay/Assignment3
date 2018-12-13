function slope = gradI(bRate,avgPSNR)

a = bRate;
b = sort(a);

[c, ia, ib] = intersect(a,b);

x1 = a(ia(length(ia)));
y1 = avgPSNR(ia(length(ia)));
x2 = a(ia(length(ia)-1));
y2 = avgPSNR(ia(length(ia)-1));

slope = (y2 - y1) / (x2 - x1);

end