
    clc;
    clear all;
    close all;
    M = imread('lena1.bmp');
    figure,imshow(M); 
    rounds = 1;
    [row col]=size(M);
    M_New = M;
    N = row;
    while (rounds > 0)
    x(1) = 0.61;
    y(1)= 0.15;
    a = 1.4;
    b = 0.3;
    i = 1;

    for i = 1:row   
%           for j = 1:col
             x(i+1)= 1+y(i)-a*(x(i))^2;
             y(i+1)= b*x(i);
             c(i)= x(i) ;
             d(i)= y(i) ;
%           end
    end
    c_index = vertcat(c,1:512);
    sort_c_index = sortrows(c_index,1);
    sort_c_index = sortrows(c_index,2);
    final_sort_c_index = transpose(sort_c_index);
    D = sortrows( final_sort_c_index);
    D_Index=D(:,2);
    
    d_index = vertcat(d,1:512);
    sort_d_index = sortrows(d_index,1);
    sort_d_index = sortrows(d_index,2);
    final_sort_d_index = transpose(sort_d_index);
    DD = sortrows( final_sort_d_index);
    DD_Index = DD(:,2);
    
% % % % % % % % % % % %     shuffling

    
for i= 1 : row
		for j = 1 : col
			        M_New1(i,j) = M_New(D_Index(i),j);	                
        end
end
     M_New1 = M_New;
    
for i= 1 : row
		for j= 1 : col
			        M_New1(i,j) = M_New(i,DD_Index(j));          
        end
end
% figure,imshow (M_New1);

%%%%%%%%%     BITPLANE DECOMPOSITION
cd = double(M_New1); 
%imshow(cd/255);
c0 = mod(cd,2);
%   figure,imshow(c0);
%  imwrite(c0,'c01.png');
c1 = mod(floor(cd/2),2);
% figure,imshow(c1);
%  imwrite(c1,'c11.png');
c2 =  mod(floor(cd/4),2);
c3 =  mod(floor(cd/8),2);
c4 =  mod(floor(cd/16),2);
c5 =  mod(floor(cd/32),2);
c6 =  mod(floor(cd/64),2);
c7 =  mod(floor(cd/128),2);
% figure,imshow(c2);
% % imwrite(c2,'c21.png');
% figure,imshow(c3);
% % imwrite(c3,'c31.png');
% figure,imshow(c4);
% % imwrite(c4,'c41.png');
% figure,imshow(c5);
% % imwrite(c5,'c51.png');
% figure,imshow(c6);
% % imwrite(c6,'c61.png');
% figure,imshow(c7);
% imwrite(c7,'c71.png');

%%%%%%%%%%%%%%% key matrix generation
N = row;
xx(1)= 0.62 ;
yy(1)= 0.14 ;
a = 1.075789 ;
b = 0.341734 ;

for i=2:N
    %for j = 1:N
    xx(i)= 1+yy(i-1)-a*(xx(i-1))^2;
    yy(i)= b*xx(i-1);   
end


l=1;
bb=1;
 
for i = 1:row
    for j= 1:col
        t(bb,l)= xx(i)+yy(j);
            if(j>=512)
               bb=bb+1;
               l=1;
            else
            l=l+1;
            end     
    end
end
%normalize the key 
Z1 = t - min(t(:));
Z1 = Z1 ./ max(Z1(:));

key = mat2gray(Z1,[0.0 1.0]);
key = mat2gray(Z1);

w = key;
% figure,imshow(w);
% figure,imshow(w);

%%%%% binary edge planes
bw1 = edge(w,'log',rand);
%subplot(2,2,2);
% figure,imshow(bw1);
bw2 = edge(w,'canny',rand);
%zsubplot(2,2,4);
% figure,imshow(bw2);
bw3 = edge(w,'canny',rand);
%figure,subplot(2,2,3);
% figure,imshow(bw3);
bw4 = edge(w,'sobel',rand);
%figure,subplot(2,2,3);
% figure,imshow(bw4);
bw5 = edge(w,'log',rand);
%zsubplot(2,2,4);
% figure,imshow(bw5);
bw6 = edge(w,'canny',rand);
%zsubplot(2,2,4);
% figure,imshow(bw6);
bw7 = edge(w,'sobel',rand);
%zsubplot(2,2,4);
% figure,imshow(bw7);
bw8 = edge(w,'log',rand);
%zsubplot(2,2,4);
% figure,imshow(bw8);
 

%%%% bitxor of edge plane and bitplanes%%%%
e0 = bitxor(c0,bw1);
% figure,imshow(e0);
e1 = bitxor(c1,bw2);
% figure,imshow(e1);
e2 = bitxor(c2,bw3);
% figure,imshow(e2);
e3 = bitxor(c3,bw4);
% figure,imshow(e3);
e4 = bitxor(c4,bw5);
% figure,imshow(e4);
e5 = bitxor(c5,bw6);
% figure,imshow(e5);
e6 = bitxor(c6,bw7);
% figure,imshow(e6);
e7 = bitxor(c7,bw8);
% figure,imshow(e7);
e11= 2*(2*(2*(2*(2*(2*(2*e7+e6)+e5)+e4)+e3)+e2)+e1)+e0;
% figure,imshow(uint8(e11));
% imwrite(uint8(e11),'e13.png');


rounds = rounds - 1;

    end   
    % imwrite(e11,'e13.bmp',uint8);
 imhist(uint8(e11));
 nn = entropy(uint8(e11));
 display(nn);
% % % % % % % % % % % % % % decryption
c00 = bitxor(e0,bw1);
figure,imshow(c00);
c01 = bitxor(e1,bw2);
figure,imshow(c01);
c02 = bitxor(e2,bw3);
figure,imshow(c02);
c03 = bitxor(e3,bw4);
figure,imshow(c03);
c04 = bitxor(e4,bw5);
figure,imshow(c04);
c05= bitxor(e5,bw6);
figure,imshow(c00);
c06 = bitxor(e6,bw7);
figure,imshow(c06);
c07 = bitxor(e7,bw8);
figure,imshow(c07);
%cc=128*c07+64*c06+32*c05+16*c04+8*c03+4*c02+2*c01+c00;
cc= 2*(2*(2*(2*(2*(2*(2*c07+c06)+c05)+c04)+c03)+c02)+c01)+c00;
imshow(uint8(cc));
[row col] = size(cc);

for i= 1 : row :-1:1
		for j= 1 : col
		 cc(i,j) = M_New(i,DD_Index(j));          
        end
end

for i= 1 : row
		for j = 1 : col :-1:1
		 cc(i,j) = M_New(D_Index(i),j);	                
        end
end
figure,imshow(M_New);

%  %%%%%%% correlation coffecient
x1 = M(:,1:end-1,1);  
y1 = M(:,2:end,1);
hori_xy = corr2(x1,y1);
disp(hori_xy);
x11 = e11(:,1:end-1,1);  
y11 = e11(:,2:end,1);
hen_xy = corr2(x11,y11);
disp(hen_xy);


%%%%%vertical
x2 = M(1:end-1,:,1);  
y2 = M(2:end,:,1);
vori_xy = corr2(x2,y2);
disp(vori_xy);
x22 = e11(1:end-1,:,1); 
y22 = e11(2:end,:,1);
ven_xy = corr2(x22,y22);
disp(ven_xy);

% % % %diagonal
x3 = M(1:end-1,1:end-1,1);  
y3 = M(2:end,2:end,1);
dori_xy = corr2(x3,y3);
disp(dori_xy);
x33 = e11(1:end-1,1:end-1,1);  
y33 = e11(2:end,2:end,1);
den_xy = corr2(x33,y33);
disp(den_xy);


 
% % % % % % %  to calculate cipher text attack
m1 =imread('ency.bmp');
m2 = imread('ency1.bmp');
% m1(3,3)=231;
[r c]=size(m1);
sum=0;
for i=1:r
    for j=1:c
sum=sum+abs(m1(i,j)-m2(i,j));
    end
end
ucai=((sum/256)/r*c)*100;
ucai
D=ones(r,c);

for i=1:r
    for j=1:c
        if(m1(i,j)==m2(i,j))
          D(i,j)=0;
        end
    end
end
                                                     
sum2=0;
for i=1:r
    for j=1:c
sum2=sum2+D(i,j);
    end
end
npcr1 =sum2*100/(r*c);
disp(npcr1);
% % % % % % % % % % % % % % % %  PSNR
% peaksnr = psnr(,ency1);

% 
m1 =imread('ency1.bmp');
m2 = imread('ency.bmp');
% m1(3,3)=231;
[r c]=size(m1);
sum=0;
for i=1:r
    for j=1:c
sum=sum+abs(m1(i,j)-m2(i,j));
    end
end
ucai=((sum/256)/r*c)*100;
ucai


for i=1:r
    for j=1:c
        if(m1(i,j)== m2(i,j))
         sum = sum+1;
        end
    end
end
                                                     
sum= sum /[r*c];
n = sum*100;
disp(n)
m1 =imread('ency.bmp');
m2 = imread('e13.png');

[r c]=size(m1);
sum=0;
for i=1:r
    for j=1:c
sum=sum+abs(m1(i,j)-m2(i,j));
    end
end
ucai=((sum/256)/r*c)*100;
ucai
D=ones(r,c);

for i=1:r
    for j=1:c
        if(m1(i,j)==m2(i,j))
          D(i,j)=0;
        end
    end
end
                                                     
sum2=0;
for i=1:r
    for j=1:c
sum2=sum2+D(i,j);
    end
end
npcr1 =sum2*100/(r*c);
disp(npcr1);

