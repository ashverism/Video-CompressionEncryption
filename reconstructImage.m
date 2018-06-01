function  [img] = reconstructImage(indexClosestMatch,codebook,p,row,col)

img = zeros (row,col) ;
img = double(img);
indexCM=1;

for i=1 : p : row
    
    for j=1 : p :col
    
        index=indexClosestMatch(1,indexCM);
        
        l=1;
       
        for k=0:p-1
        
            for t=0:p-1
           
                img(i+k,j+t)=codebook(index,l);
           
                l = l + 1;
           
            end
                    
        end
        
        indexCM=indexCM+1;
        
    end
    
end
end

