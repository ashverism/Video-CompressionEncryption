%Returns the index of the Training Vector in the codebook cb
%which is at the least Euclidean distance from the the given
%Training Vector TV

function  y = ClosestMatch(TV,cb)

[Nc, n] = size ( cb ) ;

index = 0 ;

dist = 2 ^ 32 ;

for i=1 : Nc

    tempdist = 0 ;

    for j= 1 : n

        tempdist = tempdist + ( TV( 1 , j ) - cb( i , j ) ) ^ 2 ;

    end

    if dist > tempdist

        dist = tempdist ;

        index = i ;

    end

end
//This is the index
y = index ;

end
