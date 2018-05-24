function [keyArr] = generateKey(cVQ)
	n = 10523;
	a = 1.4;
    b = 0.3;
    rounds = cVQ;
    xarr = zeros(1, rounds);
    yarr = zeros(1, rounds);
    xarr = double(xarr);
    yarr = double(yarr);
    xarr(1) = 0.63;
    yarr(1) = 0.15;
    for i=2:rounds
        xarr(i)= 1-a*(xarr(i-1)*xarr(i-1))+yarr(i-1);
        yarr(i)= b * xarr(i-1);
    end
    keyArr = zeros(1,rounds);
    for i = 1:rounds
    	keyArr(i) = mod( abs( round( n*xarr(i) ) ), cVQ );
    end
end