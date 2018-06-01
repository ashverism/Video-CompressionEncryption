function [ codebook, indexClosestMatch1, indexClosestMatch2 ] = LBGVQ( img1, img2 , p, Nc, prevCodebook , f)
%LBG VQ using two images for creating a common codebook of size Nc and
%block size p
%   
    A = img1;
    B = img2;
    [row, col] = size(A);
    N = row * col;
    n = p * p;
    Nb = N / n;
    tSet = zeros(2*Nb,n);
    indexCM = 1;
    for i = 1 : p : row
        for j = 1 : p : col
            temp = getTV( i, j, A(:,:), n, p);
            tSet( indexCM, :) = temp( 1, :);
            indexCM = indexCM + 1;
        end
    end
    for i = 1 : p : row
        for j = 1 : p : col
            temp = getTV( i, j, B(:,:), n, p);
            tSet( indexCM, :) = temp( 1, :);
            indexCM = indexCM + 1;
        end
    end
    temp = randi( 2*Nb, 1, Nc);
    temp = double( temp );
    codebook = prevCodebook;
    if (f == 1)
        for i = 1 : Nc
            for j = 1 : n
                codebook( i, j) = tSet( temp(1,i), j);
            end
        end
    end
    x = double(1);
    distort_fact_prev = 1;
    distort_fact = 1;
    %tSet
    iterations = 0;
    while x > 0.0005
        iterations = iterations+1;
        distort_fact_prev = distort_fact;
        %%creating Nc classes
        %%Nb rows with n elements and Nc channels
        container_cb = zeros(Nc,n);
        %Maintains the upper filled limit of the container_class
        count_container = ones(1,Nc);
        %This stores the indices of the closest codevector present in codebook with
        %a particular training vector 
        indexClosestMatch1 = zeros( 1, Nb);
        for i = 1 : Nb   
            index = ClosestMatch( tSet(i,:) , codebook(: , : ) );
            indexClosestMatch1(1,i) = index;    
            container_cb( index ,: ) = container_cb( index ,: ) + tSet(i,:);
            count_container(1,index) = count_container(1,index) + 1;
        end
        indexClosestMatch2 = zeros( 1, Nb);
        for i = Nb+1 : 2*Nb   
            index = ClosestMatch( tSet(i,:) , codebook(: , : ) );    
            indexClosestMatch2(1,i-Nb) = index;    
            container_cb( index ,: ) = container_cb( index ,: ) + tSet(i,:);
            count_container(1,index) = count_container(1,index) + 1;
        end
        %This updates the codebook using the container_cb
        codebook = updateCodeBook( container_cb(:,:,:), codebook(:,:) , count_container(:,:));
        %This function updates the value of distortion factor
        distort_fact1 = distortion(codebook(:,:) , indexClosestMatch1(:,:) , tSet(1:Nb,:) ) ;
        distort_fact2 = distortion(codebook(:,:) , indexClosestMatch2(:,:) , tSet(Nb+1:2*Nb,:) ) ;
        %This calculates the converence of distortion factor  
        distort_fact = distort_fact1 + distort_fact2;
        x = abs(distort_fact_prev - distort_fact);
        x = x/distort_fact_prev;
    end
    %fprintf('IndexClosestMatch\n\n\n\n');
    %indexClosestMatch1(:, 1:100)
    %indexClosestMatch2(:, 1:100)
    fprintf('LBGVQ done\n');
    %B = uint8(reconstructImage(indexClosestMatch1,codebook,p,row, col));
    %imshow(B);
end

