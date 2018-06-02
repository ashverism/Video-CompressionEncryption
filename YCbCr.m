%Get the frames Y, Cb, Cr frames from the RGB image img
function [ y, cb, cr ] = YCbCr( img )
% returns y cb cr
%   https://msdn.microsoft.com/en-us/library/windows/desktop/bb530104(v=vs.85).aspx
    [row, col, depth] = size(img);
    y = zeros(row,col);
    y = double(y);
    cb = zeros(row,col);
    cb = double(cb);
    cr = zeros(row,col);
    cr = double(cr);
    img = double(img);
    img = img/255;
    for i = 1 : row
        for j = 1 : col
            r = img(i,j,1);
            g = img(i,j,2);
            b = img(i,j,3);
            y1 = 0.299*r + 0.587*g + 0.114*b;
            pb = (0.5/(1-0.114))*(b-y1);
            pr = (0.5/(1-0.299))*(r-y1);
            y(i,j) = 16 + 219*y1;
            cb(i,j) = 128 + 224*pb;
            cr(i,j) = 128 + 224*pr;
        end
    end
end
