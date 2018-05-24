function y = distortion(cb,indexClosestMatch,tset)

sol=double(0);

[Nb, n]=size(tset);
sum=0;
for i=1:Nb

    for j=1:n
    
        sum = sum + ( cb( indexClosestMatch( 1, i ), j ) - tset( i, j ) )^2;
    
    end
    
end

sol = sum/(Nb*n);

y = sol;

end

