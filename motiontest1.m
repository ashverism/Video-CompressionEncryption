clear all;
close all;
a = VideoReader('testvideo.avi');
row = a.Height;
col = a.Width;
N = row*col;
n = 3;  %%Breadth of Codebook
Nc = 128;   %%Length of CodeBook
Nb = N;      %%Number of training vectors
ifSize = 5; %%Number of Frames in GoP
frameRate = a.FrameRate;
sumFrames = a.NumberOfFrames;
indexVideo = zeros(row,col,sumFrames);     %% index closest match in a 3d array
numberOfCodebook = ceil(sumFrames/ifSize); %% Taking the count of codebook
codebookIterator = 1; 
compiledCodebook = zeros(Nc,n,numberOfCodebook); %% All codebook will be stored

%% Codebook formation for each GoP

for ifn = 1 : ifSize : sumFrames
    tSet = zeros(Nb,n);    %% training vector 
    iframe = read(a,ifn);
  
    for i = 1 : row
        for j = 1 : col
                tSet((i-1)*col+j,:) = iframe(i,j,:);
        end
    end
    
    temp = randi(N,1,Nc); %% randomly selecting a training vectors for inserting in codebook
%%    temp = double(temp);  %% converting to double for better codebook formation
    codebook = zeros(Nc,n);
    indexCM = 1;
    
    %% codebook initialization 
    for i = 1 : Nc
        codebook(i,:) = tSet( temp(1,i), :);
    end
    
    x = double(1);
    distort_fact_prev = 1 ;
    distort_fact = 1 ;
    iterations = 0;
    indexClosestMatch=zeros(1,Nb); %% index matching
    
    %% Clustering and Convergence
    while x > 0.05
        
        iterations = iterations+1;
        distort_fact_prev = distort_fact;
        
        %%creating Nc classes
        %%Nb rows with n elements and Nc channels
        
        container_cb = zeros(Nc,n);
        
        %Maintains the upper filled limit of the container_class
        count_container = ones(1,Nc);
        
        %This stores the indices of the closest codevector present in codebook with
        %a particular training vector 
        for i = 1 : Nb
            index = ClosestMatch( tSet(i,:) , codebook(: , : ) );
            indexClosestMatch(1,i) = index;
            container_cb( index ,: ) = container_cb( index ,: ) + tSet(i,:);
            count_container(1,index) = count_container(1,index) + 1;
        end
        
        %This updates the codebook using the container_cb
        codebook = updateCodeBook(container_cb(:,:,:) , codebook(:,:) , count_container(:,:));
        
        %This function updates the value of distortion factor
        distort_fact = distortion(codebook(:,:) , indexClosestMatch(:,:) , tSet(:,:) ) ;
        
        %This calculates the converence of distortion factor  
        x = abs(distort_fact_prev - distort_fact);
        x = x/distort_fact_prev;
    end
    
    %%Storing all indexClosestMatch
    for i = 1 : row
            for j = 1: col
                indexVideo(i,j,ifn)=indexClosestMatch(1,(i-1)*col+j);
            end
    end
    
    totFrames = ifSize-1;
    
    if ifn + ifSize > sumFrames
        totFrames = sumFrames-ifn;
    end
    
    for p = 1 : totFrames
        
        tempTSet = zeros(N,n);
        pframe = read(a,ifn+p);
        
        for i = 1 : row
            for j = 1 : col
                 tempTSet((i-1)*col+j,:)=pframe(i,j,:);
            end
        end
        
        for i = 1 : row
            for j = 1 : col
                index = ClosestMatch( tempTSet((i-1)*col+j,:) , codebook(: , : ) );
                indexVideo(i,j,ifn+p) = index;
            end            
        end
        
    end
    
    compiledCodebook(:, :, codebookIterator) = codebook(:,:);
    codebookIterator = codebookIterator+1;
    codebook
end

save('indexedVideo.mat', 'indexVideo');
save('codebookAll.mat', 'compiledCodebook');

%% Motion Estmation on index video

mbSize = 8; %% Macro block Size
p = 15;  %% Search parameter

numberOfMacroBlocks = (row*col)/(mbSize*mbSize);
motionVectorsAll = zeros(2,numberOfMacroBlocks,2*numberOfCodebook); %% Storing all Motion Vectors
computationsAll = zeros(2*numberOfCodebook);
motionVectIterator = 1;
iFrameAll = zeros(row,col,numberOfCodebook); %%Storing I frames 

for i = 1 : ifSize : sumFrames
    
	iFrame = indexVideo(:,:,i);
	iFrameAll(: , : , (motionVectIterator+1)/2 ) = iFrame(:,:);
	pFrame1 = indexVideo(:,:,i+2);
	pFrame2 = indexVideo(:,:,i+4);
	[motionVectorsAll(:,:,motionVectIterator), computationsAll(motionVectIterator)] = motionEstES(pFrame1,iFrame,mbSize,p);
    [motionVectorsAll(:,:,motionVectIterator+1), computationsAll(motionVectIterator)] = motionEstES(pFrame2,pFrame1,mbSize,p);
    motionVectIterator = motionVectIterator+2;
    
end

save('motionVectors.mat', 'motionVectorsAll');
save('ComputationsAll.mat', 'computationsAll');
halfOfMotionVectorsAll = motionVectorsAll/2;
halfOfMotionVectorsAll = round(halfOfMotionVectorsAll);
motionVectorsAll
%% Compensating index Video

compensatedVideo = zeros(row,col,sumFrames);
motionVectIterator = 1;

for i = 1 : ifSize : sumFrames 
	iFrame = iFrameAll( : , : , uint8((motionVectIterator+1)/2) );
	pFrame1 = motionComp(iFrame, motionVectorsAll(: , : ,motionVectIterator), mbSize);
	pFrame2 = motionComp(iFrame, motionVectorsAll(: , : ,motionVectIterator + 1), mbSize);
    
	bFrame1 = motionComp(iFrame, halfOfMotionVectorsAll(: , : ,motionVectIterator), mbSize);
	bFrame2 = motionComp(iFrame, halfOfMotionVectorsAll(: , : ,motionVectIterator + 1), mbSize);
    
	compensatedVideo( : , : , i) = iFrame( : , : );
	compensatedVideo( : , : , i+1) = bFrame1( : , : );
	compensatedVideo( : , : , i+2) = pFrame1( : , : );
	compensatedVideo( : , : , i+3) = bFrame2( : , : );
	compensatedVideo( : , : , i+4) = pFrame2( : , : );
	motionVectIterator = motionVectIterator + 2;
end

%% Recostructing original Video using Codebook

codebookIterator = 1;

compressedRGBVideo = VideoWriter('Estimated2.avi', 'Uncompressed AVI');
compressedRGBVideo.FrameRate = frameRate;
open(compressedRGBVideo);

for fr = 1 : ifSize : sumFrames
		
        codebook = compiledCodebook( : , : , codebookIterator);
       	
       	for gopFrame = fr : fr+ifSize-1 
       		indexMatch = compensatedVideo(: , : ,gopFrame);
       		frame = zeros(row,col,3);
       		
            for i = 1:row
       			for j = 1:col
       				frame(i,j,:)=codebook(indexMatch(i,j),:);
       			end
            end
            
            frame = uint8(frame);
    		writeVideo(compressedRGBVideo,frame);
        
        end
        codebookIterator = codebookIterator + 1; 
end

close(compressedRGBVideo);