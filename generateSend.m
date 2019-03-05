%%generating send data
%Kimberly Winter                        3/1/19

function toSend=generateSend(buffer, header1, header2, header3, header4, message)
    toSend=zeros(4, buffer*6+ length(header1)*4 + size(message, 2));
    
    %add headers to final message
    toSend(1, buffer+1:length(header1)+buffer)=header1;
    toSend(2, length(header1)+2*buffer+1:2*length(header1)+2*buffer)=header2;
    toSend(3, 2*length(header1)+3*buffer+1:3*length(header1)+3*buffer)=header3;
    toSend(4, 3*length(header1)+4*buffer+1:4*length(header1)+4*buffer)=header4;

    %add final message
    for i=1:4
        toSend(i, 4*length(header1)+buffer*5+1:4*length(header1)+buffer*5+size(message,2))=message(i,:);
    end
end