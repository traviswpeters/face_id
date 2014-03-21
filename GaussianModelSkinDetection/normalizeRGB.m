function rgb = normalizeRGB(R, G, B)
R=double(R);
G=double(G);
B=double(B);

sumRGB = R+G+B;

if(sumRGB==0)
    r = 0;
    g = 0;
    b = 0;
else
    r = R./(sumRGB);
    g = G./(sumRGB);
    b = B./(sumRGB);
end

rgb = [r; g; b];