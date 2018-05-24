% image compression sunny kumar maurya

function X=compress_img(z)
%Converting image into ntsc mode dividing the image into luminosity and
%chrominance planes
    luv=rgb2ntsc(z);
    
%Extracting the lumnious plane
    L=luv(:,:,1);
    
%Taking single value decomposition of the plane
    [U D V]=svd(L);
    
    A=zeros(size(L));
    [M N]=size(L)
    temp=M/4;
%Using temp fourier coeffecients to reconstruct the image
    for j=1:temp
        
%Applying the Moore-Penrose inverse to reconstruct
    A=A+D(j,j)*U(:,j)*V(:,j)';
    end

%Storing the new luminous plane in the compressed ntsc planes
    luv2(:,:,1)=A;
    luv2(:,:,2)=luv(:,:,2);
    luv2(:,:,3)=luv(:,:,3);
    
%Converting back to rgb
    X=ntsc2rgb(luv2);
end