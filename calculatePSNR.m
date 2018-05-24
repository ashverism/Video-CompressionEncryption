original = VideoReader('OutputTest1.avi');
compressed = VideoReader('newinputsmall.avi');

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
xlswrite('psnrOfVideoTest1.xls', psnr);
xlswrite('mseOfVideoTest1.xls', mse);
xlswrite('entropyOfVideoTest1.xls', entr);