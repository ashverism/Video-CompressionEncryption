%Creating an uncompressed RGB sub-video dataset
%out of an original compressed lenghty video

a = VideoReader('testvideo.mp4');
outp = VideoWriter('extractedtestvideo.avi', 'Uncompressed AVI');
outp.FrameRate = 30;
open(outp);
for i = 91:210
    frame = read(a, i);
    frame = uint8(frame);
    writeVideo(outp,frame);
end
close(outp);
