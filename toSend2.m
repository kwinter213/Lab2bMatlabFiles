%%Kimberly Winter               3/5/19
%generates a message to send, given knowledge of the channel


function CSI2send=toSend2(padding,message, V)

    CSI2send=zeros(4,2*padding+length(message));
    Vmessage=V*message;
    CSI2send(:,padding+1:padding+size(message,2))=Vmessage;
    
end