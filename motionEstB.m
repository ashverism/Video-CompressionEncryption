function [motionVect] = motionEstB(imgB, imgP, imgI, mbSize, p)

[row, col] = size(imgB);
vectors = zeros(3,row*col/mbSize^2);
costsP = ones(2*p + 1, 2*p + 1) * 65537;
costsI = ones(2*p + 1, 2*p + 1) * 65537;

% we start off from the top left of the image
% we will walk in steps of mbSize
% for every marcoblock that we look at we will look for
% a close match p pixels on the left, right, top and bottom of it
mbCount = 1;
for i = 1 : mbSize : row-mbSize+1
    for j = 1 : mbSize : col-mbSize+1
        
        % the exhaustive search starts here
        % we will evaluate cost for  (2p + 1) blocks vertically
        % and (2p + 1) blocks horizontaly
        % m is row(vertical) index
        % n is col(horizontal) index
        % this means we are scanning in raster order
        
        for m = -p : p        
            for n = -p : p
                refBlkVer = i + m*mbSize;   % row/Vert co-ordinate for ref block
                refBlkHor = j + n*mbSize;   % col/Horizontal co-ordinate
                if ( refBlkVer < 1 || refBlkVer+mbSize-1 > row ...
                        || refBlkHor < 1 || refBlkHor+mbSize-1 > col)
                    continue;
                end
                if ( m*m + n*n > p*p )
                    continue;
                end
                costsI(m+p+1,n+p+1) = costFuncMAD(imgB(i:i+mbSize-1,j:j+mbSize-1), ...
                     imgI(refBlkVer:refBlkVer+mbSize-1, refBlkHor:refBlkHor+mbSize-1), mbSize);
                costsP(m+p+1,n+p+1) = costFuncMAD(imgB(i:i+mbSize-1,j:j+mbSize-1), ...
                     imgP(refBlkVer:refBlkVer+mbSize-1, refBlkHor:refBlkHor+mbSize-1), mbSize);
            end
        end
        
        % Now we find the vector where the cost is minimum
        % and store it ... this is what will be passed back.
        
        [dxP, dyP, minP] = minCost(costsP); % finds which macroblock in imgI gave us min Cost
        [dxI, dyI, minI] = minCost(costsI);
        if (minP<minI)
            vectors(1,mbCount) = 2;
            vectors(2,mbCount) = dyP-p-1;    % row co-ordinate for the vector
            vectors(3,mbCount) = dxP-p-1;    % col co-ordinate for the vector
        else
            vectors(1,mbCount) = 1;
            vectors(2,mbCount) = dyI-p-1;    % row co-ordinate for the vector
            vectors(3,mbCount) = dxI-p-1;    % col co-ordinate for the vector
        end
        mbCount = mbCount + 1;
        costsI = ones(2*p + 1, 2*p +1) * 65537;
        costsP = ones(2*p + 1, 2*p +1) * 65537;
    end
end
motionVect = vectors;
                    