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

