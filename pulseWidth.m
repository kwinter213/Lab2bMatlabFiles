%%Kimberly Winter                   3/1/19
%take a random sequence of numbers and add repetitions of length pulseWidth

function final=pulseWidth(vec,pulseWidth)

final=zeros(pulseWidth*length(vec),1);

    for k=1:length(vec)    
        for i=1:pulseWidth
            final((k-1)*pulseWidth+i)=vec(k);
        end
    end
end