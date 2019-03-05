%%Kimberly Winter
%trim data based off of estimated start, finish, and noise

function trimmedData= trim(estimatedStart, estimatedNoise, lengthOfHeader, original)

dataStart=0;

    for i = estimatedStart:estimatedStart+2000
        if(abs(original(i))>estimatedNoise && dataStart==0)
            dataStart=i;
            break
        end
    end
    trimmedData=original(dataStart:dataStart+lengthOfHeader-1);
end