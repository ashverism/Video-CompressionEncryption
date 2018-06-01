function imgComp = motionCompB(imgI, imgP, motionVect, mbSize)

[row, col] = size(imgI);


% we start off from the top left of the image
% we will walk in steps of mbSize
% for every marcoblock that we look at we will read the motion vector
% and put that macroblock from refernce image in the compensated image

mbCount = 1;
for i = 1:mbSize:row-mbSize+1
    for j = 1:mbSize:col-mbSize+1
        
        % dy is row(vertical) index
        % dx is col(horizontal) index
        % this means we are scanning in order
        dy = motionVect(2,mbCount);
        dx = motionVect(3,mbCount);
        refBlkVer = i + dy;
        refBlkHor = j + dx;
        if(motionVect(1,mbCount) == 1)
            if( refBlkVer <1 || refBlkVer + mbSize -1 > row || refBlkHor < 1 || refBlkHor+mbSize-1 > col )
               imageComp(i:i+mbSize-1,j:j+mbSize-1) = imgI(i:i+mbSize-1,j:j+mbSize-1);
            else
                imageComp(i:i+mbSize-1,j:j+mbSize-1) = imgI(refBlkVer:refBlkVer+mbSize-1, refBlkHor:refBlkHor+mbSize-1);
            end
        else
            if( refBlkVer <1 || refBlkVer + mbSize -1 > row || refBlkHor < 1 || refBlkHor+mbSize-1 > col )
                imageComp(i:i+mbSize-1,j:j+mbSize-1) = imgP(i:i+mbSize-1,j:j+mbSize-1);
            else
                imageComp(i:i+mbSize-1,j:j+mbSize-1) = imgP(refBlkVer:refBlkVer+mbSize-1, refBlkHor:refBlkHor+mbSize-1);
            end
        end
        mbCount = mbCount + 1;
    end
end

imgComp = imageComp;