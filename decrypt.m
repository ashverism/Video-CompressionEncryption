function [ indexClosestMatchE, pMotionVectorsE, bMotionVectorsE ] = decrypt(indexClosestMatch, pMotionVectors, bMotionVectors)
   [row, col, depth] = size(indexClosestMatch);    
   S = random_row(col);
   indexClosestMatchE = zeros(row,col,depth); 
   for i = 1 : depth
       for j = 1 : col
            indexClosestMatchE(1,S(j),i) = indexClosestMatch(1,j,i);
       end
   end
   [row, col, depth] = size(pMotionVectors);
   S2 = random_row(row);
   pMotionVectorsE = zeros(row,col,depth);
   for i = 1 : depth
       for j = 1 : row
            pMotionVectorsE(S2(j),:,i) = pMotionVectors(j,:,i);
       end
   end
   [row, col, depth] = size(bMotionVectors);
   bMotionVectorsE = zeros(row,col,depth);
   S3 = random_row(row);
   for i = 1 : depth
       for j = 1 : row
            bMotionVectorsE(S3(j),:,i) = bMotionVectors(j,:,i);
       end
   end 
end

