function [ opVideo ] = decompress( codebooks, indexClosestMatch, motionVectorsP, motionVectorsB, row, col, pVQ, mbSize)
%UNTITLED11 Summary of this function goes here
%   Detailed explanation goes here
    [nVQ, x, numGoP] = size(codebooks);
    opVideo = zeros(row,col,numGoP*12+1);
    opVideo = double(opVideo);
    for i = 1 : numGoP
        iFrame1 = uint8(reconstructImage(indexClosestMatch(:,:,i*2-1),codebooks(:,:,i),pVQ,row,col));
        iFrame2 = uint8(reconstructImage(indexClosestMatch(:,:,i*2),codebooks(:,:,i),pVQ,row,col));
        pFrame1 = motionCompP(iFrame1, motionVectorsP(:,:,i*3-2), mbSize);
        pFrame2 = motionCompP(pFrame1, motionVectorsP(:,:,i*3-1), mbSize);
        pFrame3 = motionCompP(pFrame2, motionVectorsP(:,:,i*3), mbSize);
        bFrame1 = motionCompB(iFrame1, pFrame1, motionVectorsB(:,:,i*8-7), mbSize);
        bFrame2 = motionCompB(iFrame1, pFrame1, motionVectorsB(:,:,i*8-6), mbSize);
        bFrame3 = motionCompB(pFrame1, pFrame2, motionVectorsB(:,:,i*8-5), mbSize);
        bFrame4 = motionCompB(pFrame1, pFrame2, motionVectorsB(:,:,i*8-4), mbSize);
        bFrame5 = motionCompB(pFrame2, pFrame3, motionVectorsB(:,:,i*8-3), mbSize);
        bFrame6 = motionCompB(pFrame2, pFrame3, motionVectorsB(:,:,i*8-2), mbSize);
        bFrame7 = motionCompB(pFrame3, iFrame2, motionVectorsB(:,:,i*8-1), mbSize);
        bFrame8 = motionCompB(pFrame3, iFrame2, motionVectorsB(:,:,i*8), mbSize);
        opVideo(:,:,i*12-11) = iFrame1(:,:);
        opVideo(:,:,i*12-10) = bFrame1(:,:);
        opVideo(:,:,i*12-9) = bFrame2(:,:);
        opVideo(:,:,i*12-8) = pFrame1(:,:);
        opVideo(:,:,i*12-7) = bFrame3(:,:);
        opVideo(:,:,i*12-6) = bFrame4(:,:);
        opVideo(:,:,i*12-5) = pFrame2(:,:);
        opVideo(:,:,i*12-4) = bFrame5(:,:);
        opVideo(:,:,i*12-3) = bFrame6(:,:);
        opVideo(:,:,i*12-2) = pFrame3(:,:);
        opVideo(:,:,i*12-1) = bFrame7(:,:);
        opVideo(:,:,i*12) = bFrame8(:,:);
        opVideo(:,:,i*12+1) = iFrame2(:,:);
    end
end

