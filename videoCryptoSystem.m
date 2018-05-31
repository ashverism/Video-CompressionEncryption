clear all;
close all;
%%Initialising variables
pVQ = 4;
nVQ = 108;
mbSize = 4;
pMotionEst = 2;
a = VideoReader('newinputsmall.avi');
col =  a.Width;
row =  a.Height;
frames = a.NumberOfFrames;
N = row * col;
downsampleFactor = 4;
Y = zeros( row, col, frames);
Y = double(Y);
Cb = zeros( row/downsampleFactor, col/downsampleFactor, frames);
Cb = double(Cb);
Cr = zeros( row/downsampleFactor, col/downsampleFactor, frames);
Cr = double(Cr);
%% Converting from RGB space to YCbCr space
for i = 1 : frames
    img = read(a,i);
    YCBCR = rgb2ycbcr(img);
    Y(:,:,i) = double(YCBCR(:,:,1));
    %%Not downsampling for testing purpose
    Cb(:,:,i) = double(imresize( YCBCR(:,:,2), 1/downsampleFactor, 'lanczos3'));
    Cr(:,:,i) = double(imresize( YCBCR(:,:,3), 1/downsampleFactor, 'lanczos3'));
end

%% takiong GoP as IBBPBBPBBPBBI
fprintf('YCbCr conversion done \n');
[yCodebooks, yIndexClosestMatch, yMotionVectorsP, yMotionVectorsB] = compress( Y, pVQ, nVQ, mbSize, pMotionEst);
fprintf('compressed Y \n');
[cbCodebooks, cbIndexClosestMatch, cbMotionVectorsP, cbMotionVectorsB] = compress( Cb, pVQ, nVQ, mbSize, pMotionEst);
fprintf('compressed Cb \n');
[crCodebooks, crIndexClosestMatch, crMotionVectorsP, crMotionVectorsB] = compress( Cr, pVQ, nVQ, mbSize, pMotionEst);
fprintf('compressed Cr \n');

%%Encrypting
[yIndexClosestMatchE, yMotionVectorsPE, yMotionVectorsBE] = encrypt(yIndexClosestMatch, yMotionVectorsP, yMotionVectorsB);
[cbIndexClosestMatchE, cbMotionVectorsPE, cbMotionVectorsBE] = encrypt(cbIndexClosestMatch, cbMotionVectorsP, cbMotionVectorsB);
[crIndexClosestMatchE, crMotionVectorsPE, crMotionVectorsBE] = encrypt(crIndexClosestMatch, crMotionVectorsP, crMotionVectorsB);
%%Encrypt Video
uncompY = decompress( yCodebooks, yIndexClosestMatchE, yMotionVectorsPE, yMotionVectorsBE, row, col, pVQ, mbSize);
fprintf('decompressed Y \n');
uncompCb = decompress( cbCodebooks, cbIndexClosestMatchE, cbMotionVectorsPE, cbMotionVectorsBE, row/downsampleFactor, col/downsampleFactor, pVQ, mbSize);
fprintf('decompressed Cb \n');
uncompCr = decompress( crCodebooks, crIndexClosestMatchE, crMotionVectorsPE, crMotionVectorsBE, row/downsampleFactor, col/downsampleFactor, pVQ, mbSize);
fprintf('decompressed Cr \n');
uncompCb = imresize(uncompCb, downsampleFactor, 'lanczos3');
fprintf('upsampled Cb \n');
uncompCr = imresize(uncompCr, downsampleFactor, 'lanczos3');
fprintf('Upsampled Cr \n');
fprintf('Ouputing begins\n');
output = VideoWriter('outputtonewsmall25encrypt.avi', 'Uncompressed AVI');
output.FrameRate = 30;
open(output);
for i = 1:frames
    img = zeros(row, col, 3);
    img(:,:,1) = uncompY(:,:,i);
    img(:,:,2) = uncompCb(:,:,i);
    img(:,:,3) = uncompCr(:,:,i);
    %imwrite(img, strcat('opseqycbcr', num2str(i), '.bmp'));
    img = uint8(img);
    outputImg = ycbcr2rgb(img);
    writeVideo(output, outputImg);
    %imwrite(outputImg, strcat('opseq', num2str(i), '.bmp'));
end
close(output);

%%Decrypting
[yIndexClosestMatchD, yMotionVectorsPD, yMotionVectorsBD] = decrypt(yIndexClosestMatchE, yMotionVectorsPE, yMotionVectorsBE);
[cbIndexClosestMatchD, cbMotionVectorsPD, cbMotionVectorsBD] = decrypt(cbIndexClosestMatchE, cbMotionVectorsPE, cbMotionVectorsBE);
[crIndexClosestMatchD, crMotionVectorsPD, crMotionVectorsBD] = decrypt(crIndexClosestMatchE, crMotionVectorsPE, crMotionVectorsBE);
%%Decrypt Video
uncompY = decompress( yCodebooks, yIndexClosestMatchD, yMotionVectorsPD, yMotionVectorsBD, row, col, pVQ, mbSize);
fprintf('decompressed Y \n');
uncompCb = decompress( cbCodebooks, cbIndexClosestMatchD, cbMotionVectorsPD, cbMotionVectorsBD, row/downsampleFactor, col/downsampleFactor, pVQ, mbSize);
fprintf('decompressed Cb \n');
uncompCr = decompress( crCodebooks, crIndexClosestMatchD, crMotionVectorsPD, crMotionVectorsBD, row/downsampleFactor, col/downsampleFactor, pVQ, mbSize);
fprintf('decompressed Cr \n');
uncompCb = imresize(uncompCb, downsampleFactor, 'lanczos3');
fprintf('upsampled Cb \n');
uncompCr = imresize(uncompCr, downsampleFactor, 'lanczos3');
fprintf('Upsampled Cr \n');
fprintf('Ouputing begins\n');
output = VideoWriter('outputtonewsmall25decrypt.avi', 'Uncompressed AVI');
output.FrameRate = 30;
open(output);
for i = 1:frames
    img = zeros(row, col, 3);
    img(:,:,1) = uncompY(:,:,i);
    img(:,:,2) = uncompCb(:,:,i);
    img(:,:,3) = uncompCr(:,:,i);
    %imwrite(img, strcat('opseqycbcr', num2str(i), '.bmp'));
    img = uint8(img);
    outputImg = ycbcr2rgb(img);
    writeVideo(output, outputImg);
    %%imwrite(outputImg, strcat('opseq', num2str(i), '.bmp'));
end
close(output);




%%original decompressed
uncompY = decompress( yCodebooks, yIndexClosestMatch, yMotionVectorsP, yMotionVectorsB, row, col, pVQ, mbSize);
fprintf('decompressed Y \n');
uncompCb = decompress( cbCodebooks, cbIndexClosestMatch, cbMotionVectorsP, cbMotionVectorsB, row/downsampleFactor, col/downsampleFactor, pVQ, mbSize);
fprintf('decompressed Cb \n');
uncompCr = decompress( crCodebooks, crIndexClosestMatch, crMotionVectorsP, crMotionVectorsB, row/downsampleFactor, col/downsampleFactor, pVQ, mbSize);
fprintf('decompressed Cr \n');
uncompCb = imresize(uncompCb, downsampleFactor, 'lanczos3');
fprintf('upsampled Cb \n');
uncompCr = imresize(uncompCr, downsampleFactor, 'lanczos3');
fprintf('Upsampled Cr \n');
fprintf('Ouputing begins\n');
output = VideoWriter('outputtonewsmall25.avi', 'Uncompressed AVI');
output.FrameRate = 30;
open(output);
for i = 1:frames
    i
    img = zeros(row, col, 3);
    img(:,:,1) = uncompY(:,:,i);
    img(:,:,2) = uncompCb(:,:,i);
    img(:,:,3) = uncompCr(:,:,i);
    %imwrite(img, strcat('opseqycbcr', num2str(i), '.bmp'));
    img = uint8(img);
    outputImg = ycbcr2rgb(img);
    writeVideo(output, outputImg);
    %%imwrite(outputImg, strcat('opseq', num2str(i), '.bmp'));
end

close(output);