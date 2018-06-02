%This file is run to compute the PSNR of the reconstructed video file
%against the original video file

%Original file
original = VideoReader('OutputTest1.avi');

//Reconstructed file
compressed = VideoReader('newinputsmall.avi'); //Reconstructed file

frames = original.NumberOfFrames;
err = 0.00;
sumerr = 0.00;
sum = 0.00;
psnr = 0.00;
row = original.Height;
col = original.Width;
depth = 3;
psnr = zeros(1, frames);
psnr = double(psnr);
mse = zeros(1, frames);
mse = double(mse);
entr = zeros(1, frames);
entr = double(entr);
max = 255;
for f = 1:frames
    a = read(original, f);
    b = read(compressed, f);
    entr(1, f) = entropy(b);
    sumerr = 0;
    for i = 1:depth
        err = immse(a(:, :, i), b(:, :, i));
        sumerr = sumerr + err;
    end
    sumerr = sumerr/depth;
    mse(1, f) = sumerr;
    psnr(1, f) = 10 * log10((255*255)/sumerr);
end

%Writes three data viz. PSNR, MSE and Entropy in to spreadsheet files

xlswrite('psnrOfVideoTest1.xls', psnr);
xlswrite('mseOfVideoTest1.xls', mse);
xlswrite('entropyOfVideoTest1.xls', entr);
