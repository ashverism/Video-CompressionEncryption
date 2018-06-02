%Create the inverse Henon map
function [x, y] = henon( X, Y )
    a = 1.4;
    b = 0.3;
    rounds = 2;
    Xarr = zeros(1, rounds);
    Yarr = zeros(1, rounds);
    Xarr = double(Xarr);
    Yarr = double(Yarr);
    Xarr(1) = X;
    Yarr(1) = Y;
    for i=2:rounds
        Xarr(i) = Yarr(i-1)/b;
        i
        Yarr(i)= -1 + a*Yarr(1,i-1)*Yarr(i-1)/(b*b) + Xarr(i-1);
    end
    x = Xarr(rounds)
    y = Yarr(rounds)
end
