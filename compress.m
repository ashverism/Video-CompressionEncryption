%Implementing compression using Motion estimation
%Takes the frames as the input and generates the Motion Vectors
%Returns the Motion Vectors back to the callee and the scheme used is
%Static IBBPBBPBBPBBI...
%A dynamic code can be written and is expected to be pulled from a contributor 

function [codebooks, indexClosestMatch, motionVectorsP, motionVectorsB] = compress( imgFrames, pVQ, nVQ, mbSize, pMotionEst)

    [row, col, frames] = size(imgFrames);
    numGoP = uint8(frames/12);
    codebooks = zeros(nVQ, pVQ*pVQ, numGoP);
    codebooks = double(codebooks);
    indexClosestMatch = zeros(1, (row*col)/(pVQ*pVQ), 2*numGoP);
    indexClosestMatch = double(indexClosestMatch);
    motionVectorsP = zeros(2,(row*col)/(mbSize*mbSize),3*numGoP);
    motionVectorsP = double(motionVectorsP);
    motionVectorsB = zeros(3,(row*col)/(mbSize*mbSize),8*numGoP);
    motionVectorsB = double(motionVectorsB);
    icnt=1;
    pcnt=1;
    bcnt=1;
    cbcnt=1;
    codebook = zeros( nVQ, pVQ*pVQ);
    fprintf('compression started \n');
    for i = 1 : 12 : numGoP*12

        fprintf('Iterations\n');
        iF = i;
        p1 = i+3;
        p2 = i+6;
        p3 = i+9;
        iL = i+12;
        [codebook, indexClosestMatch1, indexClosestMatch2] = LBGVQ( imgFrames(:,:,iF), imgFrames(:,:,iL), pVQ, nVQ, codebook, i);
        iFReconstruct = uint8( reconstructImage(indexClosestMatch1,codebook,pVQ,row,col) );
        iLReconstruct = uint8( reconstructImage(indexClosestMatch2,codebook,pVQ,row,col) );
        fprintf('Motion estimation started\n\n\n');
	%imwrite(iFReconstruct, 'ifreconstruct.bmp');
	%imwrite(iLReconstruct, 'ilreconstruct.bmp');
        fprintf('Motion estimation p started\n\n\n');
        motionVectorP1 = motionEstP(iFReconstruct,imgFrames(:,:,p1),mbSize,pMotionEst);
        pFReconstruct1 = motionCompP(iFReconstruct, motionVectorP1, mbSize);
        motionVectorP2 = motionEstP(pFReconstruct1,imgFrames(:,:,p2),mbSize,pMotionEst);
        pFReconstruct2 = motionCompP(pFReconstruct1, motionVectorP2, mbSize);
        motionVectorP3 = motionEstP(pFReconstruct2,imgFrames(:,:,p3),mbSize,pMotionEst);
        pFReconstruct3 = motionCompP(pFReconstruct2, motionVectorP3, mbSize);
        %%Repeat for all the three pairs of b frames
        fprintf('Motion estimation p done\n\n\n');
        b1 = i+1;
        b2 = i+2;
        b3 = i+4;
        b4 = i+5;
        b5 = i+7;
        b6 = i+8;
        b7 = i+10;
        b8 = i+11;
        fprintf('Motion estimation b started\n\n\n');
        motionVectorB1 = motionEstB(iFReconstruct,pFReconstruct1,imgFrames(:,:,b1),mbSize,pMotionEst);
        motionVectorB2 = motionEstB(iFReconstruct,pFReconstruct1,imgFrames(:,:,b2),mbSize,pMotionEst);
        motionVectorB3 = motionEstB(pFReconstruct1,pFReconstruct2,imgFrames(:,:,b3),mbSize,pMotionEst);
        motionVectorB4 = motionEstB(pFReconstruct1,pFReconstruct2,imgFrames(:,:,b4),mbSize,pMotionEst);
        motionVectorB5 = motionEstB(pFReconstruct2,pFReconstruct3,imgFrames(:,:,b5),mbSize,pMotionEst);
        motionVectorB6 = motionEstB(pFReconstruct2,pFReconstruct3,imgFrames(:,:,b6),mbSize,pMotionEst);
        motionVectorB7 = motionEstB(pFReconstruct3,iLReconstruct,imgFrames(:,:,b7),mbSize,pMotionEst);
        motionVectorB8 = motionEstB(pFReconstruct3,iLReconstruct,imgFrames(:,:,b8),mbSize,pMotionEst);
        fprintf('Motion estimation b done\n\n\n');
        codebooks(:,:,cbcnt) = codebook(:,:);
        cbcnt = cbcnt+1;
        indexClosestMatch(:,:,icnt) = indexClosestMatch1(:,:);
        indexClosestMatch(:, :, icnt+1) = indexClosestMatch2(:,:);
        icnt = icnt + 2;
        motionVectorsP(:,:,pcnt) = motionVectorP1(:,:);
        motionVectorsP(:,:,pcnt+1) = motionVectorP2(:,:);
        motionVectorsP(:,:,pcnt+2) = motionVectorP3(:,:);
        pcnt = pcnt + 3;
        motionVectorsB(:,:,bcnt) = motionVectorB1(:,:);
        motionVectorsB(:,:,bcnt+1) = motionVectorB2(:,:);
        motionVectorsB(:,:,bcnt+2) = motionVectorB3(:,:);
        motionVectorsB(:,:,bcnt+3) = motionVectorB4(:,:);
        motionVectorsB(:,:,bcnt+4) = motionVectorB5(:,:);
        motionVectorsB(:,:,bcnt+5) = motionVectorB6(:,:);
        motionVectorsB(:,:,bcnt+6) = motionVectorB7(:,:);
        motionVectorsB(:,:,bcnt+7) = motionVectorB8(:,:);
        bcnt = bcnt + 8;
    end
end
