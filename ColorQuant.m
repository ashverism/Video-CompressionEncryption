a=VideoReader('test.mp4');
N=a.Height*a.Width;
n=3;  %%Breadth of Codebook
Nc=128;   %%Length of CodeBook
Nb=N;      %%Number of training vectors
ifsize=9;
outp=VideoWriter('NewVideo2.mp4','MPEG-4');
outp.FrameRate=30;
open(outp);
SumFrames=120;%%a.NumberOfFrames;
for ifn=1:ifsize:SumFrames
    tSet=zeros(N,n);    
    iframe=read(a,ifn);
    for i=1:a.Height
        for j=1:a.Width
            for k=1:3
                tSet((i-1)*(a.Width)+j,k)=iframe(i,j,k);
            end
        end
    end
    temp=randi(N,1,Nc);
    temp=double(temp);
    codebook=zeros(Nc,n);
    indexCM=1;
    for i = 1 : Nc
        codebook(i,:)=tSet( temp(1,i), :);
    end
    x=double(1);
    distort_fact_prev = 1 ;
    distort_fact=1 ;
    %tSet
    iterations = 0;
    indexClosestMatch=zeros(1,Nb);
    while x > 0.05
        iterations = iterations+1;
        distort_fact_prev=distort_fact;
        %%creating Nc classes
        %%Nb rows with n elements and Nc channels
        container_cb=zeros(Nc,n);
        %Maintains the upper filled limit of the container_class
        count_container=ones(1,Nc);
        %This stores the indices of the closest codevector present in codebook with
        %a particular training vector 
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
        x=x/distort_fact_prev;
    end
    indexClosestMatchFinal=zeros(ifsize,Nb);
    indexClosestMatchFinal(1,:)=indexClosestMatch(:,:);
    totFrames=8;
    if ifn+9>SumFrames
        totFrames=SumFrames-ifn;
    end
    for p=1:totFrames
        tempTSet=zeros(N,n);
        pframe=read(a,ifn+p);
        for i=1:a.Height
           for j=1:a.Width
                for k=1:3
                    tempTSet((i-1)*(a.Width)+j,k)=pframe(i,j,k);
                end
            end
        end
        for i= 1 : Nb
            index = ClosestMatch( tempTSet(i,:) , codebook(: , : ) );
            indexClosestMatchFinal(1+p,i)=index;
        end
    end
    %%dlmwrite(strcat('CbAVQ1',int2str(Nc),'.dat'),codebook);
    %%dlmwrite(strcat('idxClosestMatchAVQ1-',int2str(Nc),'.dat'),indexClosestMatch);
    
    for fr=1:totFrames+1
        iframe=zeros(a.height,a.width,3);
        l=1;
        for i=1:a.height
            for j=1:a.width
                for k=1:3
                    iframe(i,j,k)=codebook(indexClosestMatchFinal(fr,l),k);
                end
                l=l+1;
            end
        end
        iframe=uint8(iframe);
        writeVideo(outp,iframe);    
    end 
    fprintf('frames: %i - %i\n', ifn,ifn+8);
end
close(outp);