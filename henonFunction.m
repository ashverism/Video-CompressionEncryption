function [X, Y] = henon( x, y )
    a = 1.4;
    b = 0.3;
    rounds = 2;
    xarr = zeros(1, rounds);
    yarr = zeros(1, rounds);
    xarr = double(xarr);
    yarr = double(yarr);
    xarr(1) = x;
    yarr(1) = y;
    for i=2:rounds
        xarr(i)= 1-a*(xarr(i-1)*xarr(i-1))+yarr(i-1);
        yarr(i)= b * xarr(i-1);
    end
    X = xarr(rounds)
    Y = yarr(rounds)
end