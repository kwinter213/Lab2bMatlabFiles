%%SVD main              Kimberly Winter
%3/5/19

%must be run after main4Channel.m to receive a proper H

%perform SVD on H
[U,S,V]=svd(H);

%generate a signal to send, and multiply V times the original sent message
%to prep
message2sendCSI=toSend2(bufferSize, message, V);

%send message
receivedMsgSVD=MIMOChannel4x4(message2sendCSI);

%I realize that I should probably change my trimming function to accomodate
%multiple dimensions, but since I'm only using this once, I'm just going
%to work around it.
trimCSIMessage1=trim(450, noiseEst1*5, 40000, receivedMsgSVD(1,:));
trimCSIMessage2=trim(450, noiseEst2*5, 40000, receivedMsgSVD(2,:));
trimCSIMessage3=trim(450, noiseEst3*5, 40000, receivedMsgSVD(3,:));
trimCSIMessage4=trim(450, noiseEst4*5, 40000, receivedMsgSVD(4,:));
trimCSIMessagetot=[trimCSIMessage1;trimCSIMessage2;trimCSIMessage3;trimCSIMessage4];

%multiply by inverse of U
SigS=inv(U)*trimCSIMessagetot;

%make every bit +/-1
normCSIMessage1=normalize(trimCSIMessagetot(1,:));
normCSIMessage2=normalize(trimCSIMessagetot(2,:));
normCSIMessage3=normalize(trimCSIMessagetot(3,:));
normCSIMessage4=normalize(trimCSIMessagetot(4,:));

%error rate
errorsx1=0;
for i=20:40:length(normCSIMessage1)
   if(normCSIMessage1(i)~= message(1,i))
       errorsx1=errorsx1+1;
   end
end

errorsx2=0;
for i=20:40:length(normCSIMessage1)
   if(normCSIMessage2(i)~= message(2,i))
       errorsx2=errorsx2+1;
   end
end

errorsx3=0;
for i=20:40:length(normCSIMessage1)
   if(normCSIMessage3(i)~= message(3,i))
       errorsx3=errorsx3+1;
   end
end

errorsx4=0;
for i=20:40:length(normCSIMessage1)
   if(normCSIMessage4(i)~= message(4,i))
       errorsx4=errorsx4+1;
   end
end

errorsx1
errorsx2
errorsx3
errorsx4
errorRateSVD=(errorsx2+errorsx1+errorsx3+errorsx4)/(4*length(normCSIMessage1));