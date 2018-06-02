%Utility function to compare the print the PSNR of two different video files
% frame vise frame
function psnrarr = printPSNR(str1,str2)
new = VideoReader(str1);
old = VideoReader(str2);
newFrame = new.NumberOfFrames;
oldFrame = old.NumberOfFrames;
if( newFrame ~= oldFrame || new.Height ~= old.Height || new.Width ~= old.Width)
    print "Error";
end
h = new.Height;
w = new.Width;
area = h*w;
mse = zeros(newFrame, 1);
peakval = zeros(newFrame,1);
mse = double(mse);
psnrarr = zeros(newFrame, 1);
psnrarr = double(psnrarr);
for i=1:newFrame
    mata = read(new, i);
    matb = read(old, i);
    hpsnr=vision.PSNR;
    psnrarr(i,1)=step(hpsnr,mata,matb);
end
end
