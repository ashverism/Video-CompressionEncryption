%As k-means clustering method updates the new centroid postions
%Similary the Training Vectors in the codebook are updated based on the
%mean of the all the vectors that are closest to it

function y = updateCodeBook(container,cb,count)

[Nc, n]=size(container);

for i= 1: Nc

        temp=zeros(1,n);
        temp(1,:)=container(i,:);

    temp = temp/count(1,i);
    if all(temp == 0)

    else
    cb(i,:)=temp(1,:);
    end

end

y=cb(:,:);

end
