a=VideoReader('CompressedVideo_AVQ.avi')
for img=1:a.NumberOfFrames
    b=read(a,img);
    imwrite(b,strcat('output-AVQ-',num2str(img),'.jpg'));
end
%%outp=VideoWriter('output4','Grayscale AVI');
%%outp.FrameRate=30;
%%open(outp);
%%for i=1:30
 %%   writeVideo(outp,images{i});
%%end
%%close(outp);
%%d=VideoReader('output4.avi');