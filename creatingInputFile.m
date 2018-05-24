input = VideoReader('reporter.yuv');
row = input.Height;
col = input.Width;
frames = input.NumberOfFrames;
img = zeros(row, col, 3);
output = VideoWriter('reporter.avi', 'Uncompressed AVI');
output.FrameRate = input.FrameRate;
open(output);
for i=1:61
    img = read(input, i);
    img = uint8(img);
    writeVideo(output, img);
    i
end
close(output);