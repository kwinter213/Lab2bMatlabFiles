%%Kimberly Winter
%returns vectors that are either 1's or -1's

function normalVect= normalize(startVector)
normalVect=zeros(length(startVector),1);
    for i=1:length(startVector)
       if(abs(startVector(i)>0))
           normalVect(i)=1;
       else
           normalVect(i)=-1;
       end
    end
end