%Initial project code for LBG Algorithm implementation
%Using Vector Quantization
clc;

A=imread('lena.bmp');


[row, col]=size(A);

N=row*col;

p=8;

n=p*p;

Nb=N/n;

Nc=64;

tSet=zeros(Nb,n);

indexCM=1;

%temp = zeros(1,n);

for i= 1 : p : row

    for j=1 : p : col

        temp=getTV(i,j,A(:,:),n,p);

        for l = 1 : n

            tSet(indexCM,l)=temp(1,l);

        end

        indexCM=indexCM+1;

    end

end

temp=randi(Nb,1,Nc);

temp=double(temp);

codebook=zeros(Nc,n);

indexCM=1;

for i = 1 : Nc

    for j=1 : n

        codebook(i,j)=tSet( temp(1,i), j);

    end

end


x=double(1);
distort_fact_prev = 1 ;
distort_fact=1 ;

%tSet
iterations = 0;


while x > 0.0005
    iterations = iterations+1;
    distort_fact_prev=distort_fact;
%%creating Nc classes
%%Nb rows with n elements and Nc channels

container_cb=zeros(Nc,n);

%Maintains the upper filled limit of the container_class

count_container=ones(1,Nc);

%This stores the indices of the closest codevector present in codebook with
%a particular training vector

indexClosestMatch=zeros(1,Nb);

for i= 1 : Nb

    index = ClosestMatch( tSet(i,:) , codebook(: , : ) );

    indexClosestMatch(1,i)=index;

    container_cb( index ,: ) =container_cb( index ,: ) + tSet(i,:);

    count_container(1,index) = count_container(1,index) + 1;
end
%This updates the codebook using the container_cb

codebook=updateCodeBook(container_cb(:,:,:) , codebook(:,:) , count_container(:,:));

%This function updates the value of distortion factor

distort_fact=distortion(codebook(:,:) , indexClosestMatch(:,:) , tSet(:,:) ) ;

%This calculates the converence of distortion factor

x=abs(distort_fact_prev - distort_fact);

x=x/distort_fact_prev

end
%%creates the compressed image using codebook and indexClosestMatch\

createCompressedImage(indexClosestMatch,codebook,A,p);
