%%4 Channel MIMO Main
%Kimberly Winter                                3/1/19

pulseW=40; %pulse width (renamed to not get confused with other function
headerSize=50;
messageLength=1000; %Length of message
bufferSize=500; %number of zeros between signals

%generate 4 random headers of length headerSize
header1=pulseWidth(generateRand(headerSize), pulseW);
header2=pulseWidth(generateRand(headerSize), pulseW);
header3=pulseWidth(generateRand(headerSize), pulseW);
header4=pulseWidth(generateRand(headerSize), pulseW);

%generates message of messageLength for 4 Mimo Channels
message=[pulseWidth(generateRand(messageLength),pulseW),pulseWidth(generateRand(messageLength),pulseW),pulseWidth(generateRand(messageLength),pulseW),pulseWidth(generateRand(messageLength),pulseW)]';

toSend=generateSend(bufferSize, header1, header2, header3, header4, message);

receivedMsg=MIMOChannel4x4(toSend);

%noise estimations
noiseEst1=mean(abs(receivedMsg(1,1:50)));
noiseEst2=mean(abs(receivedMsg(2,1:50)));
noiseEst3=mean(abs(receivedMsg(3,1:50)));
noiseEst4=mean(abs(receivedMsg(4,1:50)));

%%trim

%header 1, receivers 1-4
receivedHeader11=trim(1, noiseEst1*5, length(header1), receivedMsg(1,:));
receivedHeader21=trim(1, noiseEst2*5, length(header1), receivedMsg(2,:));
receivedHeader31=trim(1, noiseEst3*5, length(header1), receivedMsg(3,:));
receivedHeader41=trim(1, noiseEst4*5, length(header1), receivedMsg(4,:));

%header 2, receivers 1-4
receivedHeader12=trim(bufferSize*1.5+length(header1), noiseEst1*10, length(header2), receivedMsg(1,:));
receivedHeader22=trim(bufferSize*1.5+length(header1), noiseEst2*10, length(header2), receivedMsg(2,:));
receivedHeader32=trim(bufferSize*1.5+length(header1), noiseEst3*10, length(header2), receivedMsg(3,:));
receivedHeader42=trim(bufferSize*1.5+length(header1), noiseEst4*10, length(header2), receivedMsg(4,:));

%header 3, receivers 1-4
receivedHeader13=trim(bufferSize*2.5+2*length(header1), noiseEst1*10, length(header3), receivedMsg(1,:));
receivedHeader23=trim(bufferSize*2.5+2*length(header1), noiseEst2*10, length(header3), receivedMsg(2,:));
receivedHeader33=trim(bufferSize*2.5+2*length(header1), noiseEst3*10, length(header3), receivedMsg(3,:));
receivedHeader43=trim(bufferSize*2.5+2*length(header1), noiseEst4*10, length(header3), receivedMsg(4,:));

%header 4, receivers 1-4
receivedHeader14=trim(bufferSize*3.5+3*length(header1), noiseEst1*10, length(header4), receivedMsg(1,:));
receivedHeader24=trim(bufferSize*3.5+3*length(header1), noiseEst2*10, length(header4), receivedMsg(2,:));
receivedHeader34=trim(bufferSize*3.5+3*length(header1), noiseEst3*10, length(header4), receivedMsg(3,:));
receivedHeader44=trim(bufferSize*3.5+3*length(header1), noiseEst4*10, length(header4), receivedMsg(4,:));

%messages, receivers 1-4
message1=trim(bufferSize*4.5+4*length(header1), noiseEst1*10, messageLength*40, receivedMsg(1,:));
message2=trim(bufferSize*4.5+4*length(header1), noiseEst2*10, messageLength*40, receivedMsg(2,:));
message3=trim(bufferSize*4.5+4*length(header1), noiseEst3*10, messageLength*40, receivedMsg(3,:));
message4=trim(bufferSize*4.5+4*length(header1), noiseEst4*10, messageLength*40, receivedMsg(4,:));

%make H's
H11=mean(receivedHeader11.'./header1);
H12=mean(receivedHeader12.'./header2);
H13=mean(receivedHeader13.'./header3);
H14=mean(receivedHeader14.'./header4);
H21=mean(receivedHeader21.'./header1);
H22=mean(receivedHeader22.'./header2);
H23=mean(receivedHeader23.'./header3);
H24=mean(receivedHeader24.'./header4);
H31=mean(receivedHeader31.'./header1);
H32=mean(receivedHeader32.'./header2);
H33=mean(receivedHeader33.'./header3);
H34=mean(receivedHeader34.'./header4);
H41=mean(receivedHeader41.'./header1);
H42=mean(receivedHeader42.'./header2);
H43=mean(receivedHeader43.'./header3);
H44=mean(receivedHeader44.'./header4);

%Make W
H=[H11, H12, H13, H14;H21, H22, H23, H24;H31, H32, H33, H34;H41, H42, H43, H44];

W=inv(H);

%multiply
final=W*[message1;message2;message3;message4];

%translate to 1's and -1's
normalX1=normalize(final(1,:));
normalX2=normalize(final(2,:));
normalX3=normalize(final(3,:));
normalX4=normalize(final(4,:));

%error rate
errorsx1=0;
totalcount=0;
for i=20:40:length(normalX1)
   if(normalX1(i)~= message(1,i))
       errorsx1=errorsx1+1;
   end
   totalcount=totalcount+1;
end

errorsx2=0;
for i=20:40:length(normalX2)
   if(normalX2(i)~= message(2,i))
       errorsx2=errorsx2+1;
   end
   totalcount=totalcount+1;
end

errorsx3=0;
for i=20:40:length(normalX3)
   if(normalX3(i)~= message(3,i))
       errorsx3=errorsx3+1;
   end
   totalcount=totalcount+1;
end

errorsx4=0;
for i=20:40:length(normalX4)
   if(normalX4(i)~= message(4,i))
       errorsx4=errorsx4+1;
   end
   totalcount=totalcount+1;
end

totalcount
errorRateZeroForcing=(errorsx2+errorsx1+errorsx3+errorsx4)/(4*length(normalX2))