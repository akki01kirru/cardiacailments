clc;
clear all;
close all;

[filename,pathname] = uigetfile('*.*','Select the ECG signal');
filewithpath = strcat(pathname,filename);
Fs = input('Enter the sampling Rate:');
i = input('Enter the row to be considered 1 or 2:');

%Reading ECG signal
ecg = load(filename);
%ecg = ecg1(1,:);
ecgsig1 = (ecg.val)./200;   %Normalize Gain
ecgsig = ecgsig1(i,1:65536);
t = 1:length(ecgsig);  %No.of samples
tx = t./Fs;  %Getting time vector

delay=6;
f1=5; %cuttoff low frequency to get rid of baseline wander
f2=15; %cuttoff frequency to discard high frequency noise
Wn=[f1 f2]*2/Fs; % cutt off based on Fs
N = 3; % order of 3 less processing
[a,b] = butter(N,Wn); %bandpass filtering
ecg_h = filtfilt(a,b,ecgsig);
ecg_h = ecg_h/ max( abs(ecg_h));
figure
%ax(3)=subplot(323);
plot(tx,ecg_h);
axis tight;
title('Band Pass Filtered');
grid on
%4-level undecimated DWT using sym4
wt = modwpt(ecg_h,4,'sym4');
wtrec = zeros(size(wt));
wtrec(1:4,:) = wt(1:4,:);   %Extracting only d1 d2 d3 and d4 coefficients.

%Inverse transform of MODWT
y = imodwpt(wtrec,'sym4');     %IDWT with only d3 and d4.
y = abs(y).^2;   %Magnitude square

avg = mean(y);   %Getting the average of y^2 as threshold.

%Finding Peaks
[Rpeaks,locs_Rwave] = findpeaks(y,t,'MinPeakHeight',4*avg,'MinPeakDistance',50);

nohb = length(locs_Rwave);   %No.of Heart beats
timelim = length(ecgsig)/Fs;
hbpermin = (nohb*60)/timelim;   %Getting BPM

disp(strcat('Heart Rate= ',num2str(hbpermin)))

%Displaying ECG signal and detected R-peaks
figure
subplot(2,1,1)
plot(tx,ecg_h);
xlim([0,timelim]);
grid on;
xlabel('Seconds')
title('ECG Signal')

subplot(2,1,2)
plot(t,y)
grid on;
xlim([0,length(ecgsig)]);
hold on

plot(locs_Rwave,Rpeaks,'ro')
xlabel('Samples')
title(strcat('R Peaks found and Heart Rate: ',num2str(hbpermin)))
hold off


%% Initialize

len=length(locs_Rwave)
Ploc=zeros(1,len);
Pamp=zeros(1,len);
PON=zeros(1,len);
POFF=zeros(1,len);
Qloc=zeros(1,len);
Qamp=zeros(1,len);
QON=zeros(1,len);
QOFF=zeros(1,len);
Sloc=zeros(1,len);
Samp=zeros(1,len);
SON=zeros(1,len);
SOFF=zeros(1,len);
Tloc=zeros(1,len);
Tamp=zeros(1,len);
TON=zeros(1,len);
TOFF=zeros(1,len);



y1=ecg_h;
ls = length(y1);

 for j=1:len
%% P Peak
 
    a=locs_Rwave(j)-floor(.2*Fs):locs_Rwave(j)-(.05*Fs);
    m=max(y1(a));
    b=find(y1(a)== m);
    b=b(1);
    b=a(b);
    Ploc(j)=b;
    Pamp(j)=m;
 %%%%% P ONSET off
    fnd=0;
    for k=b-floor(.06*Fs):b
        if((y1(k)>0) && (y1(k-1)<=0))
            qon1=k;
            fnd=1;
          break
        end
    end
    if(fnd==0)
        Qrange=b-floor(.06*Fs):b;
        qon1= y1(Qrange)==max(y1(Qrange));
        qon1=Qrange(qon1);
    end
    PON(j)=qon1(1);
    fnd=0;
    for k=b:b+floor(.06*Fs)
        if((y1(k)<=0) && (y1(k-1)>0))
            qon1=k;
            fnd=1;
          break 
        end
    end
    if(fnd==0)
        Qrange=b:b+floor(.06*Fs);
        qon1= y1(Qrange)==max(y1(Qrange));
        qon1=Qrange(qon1);
    end
    POFF(j)=qon1(1);
    %     end
    
    %% Q  Detection
    a=locs_Rwave(j)-floor(.07*Fs):locs_Rwave(j);
    m=min(y1(a));
    b=find(y1(a)==m);
    b=b(1);
    b=a(b);
    Qloc(j)=b;
    Qamp(j)=m;
    
    %Q onset off
    fnd=0;
    for k=b-floor(.06*Fs):b
        if((y1(k)<=0) && (y1(k-1)>0))
            qon1=k;
            fnd=1;
          break
        end
    end
    if(fnd==0)
        Qrange=b-floor(.06*Fs):b;
        qon1= y1(Qrange)==max(y1(Qrange));
        qon1=Qrange(qon1);
    end
    QON(j)=qon1(1);
    fnd;
    for k=b:b+floor(.06*Fs)
        if((y1(k)>0) && (y1(k-1)<=0))
            qon1=k;
            fnd=1;
          break 
        end
    end
    if(fnd==0)
        Qrange=b:b+floor(.06*Fs);
        qon1= y1(Qrange)==max(y1(Qrange));
        qon1=Qrange(qon1);
    end
    QOFF(j)=qon1(1);

    
    %% S  Detection
    a=locs_Rwave(j):locs_Rwave(j)+(0.06*Fs);
    m=min(y1(a));
    b=find(y1(a)==m);
    b=b(1);
    b=a(b);
    Sloc(j)=b;
    Samp(j)=m;
     
    %S onset off
    fnd=0;
    for k=b-floor(.06*Fs):b
        if((y1(k)<=0) && (y1(k-1)>0))
            qon1=k;
            fnd=1;
          break
        end
    end
    if(fnd==0)
        Qrange=b-floor(.06*Fs):b;
        qon1= y1(Qrange)==max(y1(Qrange));
        qon1=Qrange(qon1);
    end
    SON(j)=qon1(1);
    fnd=0;
    for k=b:b+floor(.06*Fs)
        if((y1(k)<=0) && (y1(k-1)>0))
            qon1=k;
            fnd=1;
          break 
        end
    end
    if(fnd==0)
        Qrange=b:b+floor(.06*Fs);
        qon1= y1(Qrange)==max(y1(Qrange));
        qon1=Qrange(qon1);
    end
    SOFF(j)=qon1(1);fnd=0;
    for k=b-floor(.06*Fs):b
        if((y1(k)<=0) && (y1(k-1)>0))
            qon1=k;
            fnd=1;
          break
        end
    end
    if(fnd==0)
        Qrange=b-floor(.06*Fs):b;
        qon1= y1(Qrange)==max(y1(Qrange));
        qon1=Qrange(qon1);
    end
    SON(j)=qon1(1);
    fnd=0;
    for k=b:b+floor(.06*Fs)
        if((y1(k)<=0) && (y1(k-1)>0))
            qon1=k;
            fnd=1;
          break 
        end
    end
    if(fnd==0)
        Qrange=b:b+floor(.06*Fs);
        qon1= y1(Qrange)==max(y1(Qrange));
        qon1=Qrange(qon1);
    end
    SOFF(j)=qon1(1);
     %% T Peak
    a=locs_Rwave(j)+floor(.1*Fs):locs_Rwave(j)+(.15*Fs);
    m=max(y1(a));
    b=find(y1(a)==m);
    b=b(1);
    b=a(b);
    Tloc(j)=b;
    Tamp(j)=m;
      %%%% T onset off
    fnd=0;
    for k=b-floor(.1*Fs):b
        if((y1(k)>0) && (y1(k-1)<=0))
            qon1=k;
            fnd=1;
          break 
        end
    end
    if(fnd==0)
        Qrange=b-floor(.1*Fs):b;
        qon1= y1(Qrange)==max(y1(Qrange));
        qon1=Qrange(qon1);
    end
    TON(j)=qon1(1);
    fnd=0;
    for k=b:b+floor(.12*Fs)
        if((y1(k)<=0) && (y1(k-1)>0))
            qon1=k;
            fnd=1;
          break 
        end
    end
    if(fnd==0)
        Qrange=b:b+floor(.12*Fs);
        qon1= y1(Qrange)==max(y1(Qrange));
        qon1=Qrange(qon1);
    end
    TOFF(j)=qon1(1)
   
    
 end

figure 
grid on
plot(y1), hold on;
plot(locs_Rwave,ecg_h(locs_Rwave),'r*'),hold on;
plot(Qloc,Qamp,'r+'),hold on;
plot(Ploc,Pamp,'ro'), hold on;
plot(Sloc,Samp,'r+'),hold on;
plot(Tloc,Tamp,'r^'),hold on
xlabel('ECG sample')
ylabel('Electrical activity');

R_Peakloc=locs_Rwave;
R_PeakAmp=ecg_h(locs_Rwave);
PONamp = ecg_h(PON);
POFFamp = ecg_h(POFF);
TONamp = ecg_h(TON);
TOFFamp = ecg_h(TOFF);

% R_Peakloc*(1/Fs)
% R_PeakAmp
%  Ploc
%  Pamp
%  PON
%  POFF
%  Qloc
%  Qamp
%  QON
%  QOFF
%  Sloc
%  Samp
%  SON
%  SOFF
%  Tloc
%  Tamp
%  TON
%  TOFF
 hbpermin
 
%P duration
for(i=1:1:1)
    for(j=1:1:len)
        Pint(i,j)=POFF(i,j)-PON(i,j);
    end
end
Pduration=mean(Pint);
Pseg=Pduration/Fs

%PQ duration
for(i=1:1:1)
    for(j=1:1:len)
        PQ(i,j)=Qloc(i,j)-Ploc(i,j);
    end
end
PQavg=mean(PQ);
PQseg=PQavg/Fs

%QR duration
for(i=1:1:1)
    for(j=1:1:len)
        QR(i,j)=R_Peakloc(i,j)-Qloc(i,j);
    end
end
QRavg=mean(QR);
QRseg=QRavg/Fs

%QRS duration
for(i=1:1:1)
    for(j=1:1:len)
        QRS(i,j)=Sloc(i,j)-Qloc(i,j);
    end
end
QRSavg=mean(QRS);
QRSseg=QRSavg/Fs

%RS duration
for(i=1:1:1)
    for(j=1:1:len)
        RS(i,j)=Sloc(i,j)-R_Peakloc(i,j);
    end
end
RSavg=mean(RS);
RSseg=RSavg/Fs

%Detection of S-T Segment
for(i=1:1:1)
    for(j=1:1:len)
        ST(i,j)=Tloc(i,j)-Sloc(i,j);
    end
end
STavg=mean(ST);
STseg=STavg/Fs

%QT duration
for(i=1:1:1)
    for(j=1:1:len)
        QT(i,j)=Tloc(i,j)-Qloc(i,j);
    end
end
QTavg=mean(QT);
QTseg=QTavg/Fs

%T duration
for(i=1:1:1)
    for(j=1:1:len)
        Tint(i,j)=TOFF(i,j)-TON(i,j);
    end
end
Tduration=mean(Tint);
Tseg=Tduration/Fs

%PTseg Duration
for(i=1:1:1)
    for(j=1:1:len)
        PT(i,j)=Tloc(i,j)-Ploc(i,j);
    end
end
PTavg=mean(PT);
PTseg=PTavg/Fs

%Entire ECG signal duration - PON to TOFF :ECGseg
for(i=1:1:1)
    for(j=1:1:len)
        ECG(i,j)=TOFF(i,j)-PON(i,j);
    end
end
ECGavg=mean(ECG);
ECGseg=ECGavg/Fs

%Distance Features - PQ, QR, RS, ST, PT : 5features
PQdis = find_dis(Ploc,Pamp,Qloc,Qamp)
PonQdis = find_dis(PON,PONamp,Qloc,Qamp)
PRdis = find_dis(Ploc,Pamp,R_Peakloc,R_PeakAmp)
PonRdis = find_dis(PON,PONamp,R_Peakloc,R_PeakAmp)
PSdis = find_dis(Ploc,Pamp,Sloc,Samp)
PonSdis = find_dis(PON,PONamp,Sloc,Samp)
PTdis = find_dis(Ploc,Pamp,Tloc,Tamp)
PonTdis = find_dis(PON,PONamp,Tloc,Tamp)
PToffdis = find_dis(Ploc,Pamp,TOFF,TOFFamp)
QRdis = find_dis(Qloc,Qamp,R_Peakloc,R_PeakAmp)
QSdis = find_dis(Qloc,Qamp,Sloc,Samp)
QTdis = find_dis(Qloc,Qamp,Tloc,Tamp)
QToffdis = find_dis(Qloc,Qamp,TOFF,TOFFamp)
RSdis = find_dis(R_Peakloc,R_PeakAmp,Sloc,Samp)
RTdis = find_dis(R_Peakloc,R_PeakAmp,Tloc,Tamp)
RToffdis = find_dis(R_Peakloc,R_PeakAmp,TOFF,TOFFamp)
STdis = find_dis(Sloc,Samp,Tloc,Tamp)
SToffdis = find_dis(Sloc,Samp,TOFF,TOFFamp)
PonToffdis = find_dis(PON,PONamp,TOFF,TOFFamp)

%QR interval to QS interval ratio and RS interval to QS interval ratio: Used in cardiology
[QRtoQS,RStoQS]= find_QRtoQS_RStoQS(Qloc,R_Peakloc,Sloc);

%QR interval (only indices) to QS interval ratio in time (secs)
QRtoQSM = mean(QRtoQS);
QRtoQSdur = QRtoQSM/Fs

%RS interval to QS interval ratio in time (secs)
RStoQSM = mean(RStoQS);
RStoQSdur = RStoQSM/Fs

%RRmean : Mean of all RR_ intervals in function : find_mean_RR()
RRmean = find_mean_RR(locs_Rwave)
PPmean = find_mean_RR(Ploc)


%SDRR : Standard deviation of RR interval
SDRR = find_SD_RR(locs_Rwave)

%IBIM - inter beat intervals mean - NN
%Where IBI is time between adjacent RR interval.
%NN represents adjacent RR interval 
%NNTot : Number of total IBI intervals
%RRTot : Number of R peaks in the given length
RRTot = len
for(i=1:1:1)
    for(j=1:1:len-1)
    IBI(i,j) = locs_Rwave(i,j+1) - locs_Rwave(i,j);
    end
end
NNTot = length(IBI)
IBIM = mean(IBI)

%IBISD : Standard deviation of IBI
%SD = root(sum(IBI(i,j) - IBIM)^2/N)

IBIsum = 0
for(i=1:1:1)
    for(j=1:1:len-1)
        IBIsum = (IBI(i,j) - IBIM)^2 + IBIsum;
    end
end
N = length(IBI);
IBImean = IBIsum/(N-1);
IBISD = sqrt(IBImean)

%NN50 : the number of pairs of adjacent RR intervals 
% where the successive RR intervals >50 ms
NN50= find_NN50(R_Peakloc,50,Fs)

%pNN50: the percentage of successive RR intervals >50 ms (pNN50)
pNN50= (NN50/NNTot)*100

%Power Spectral Density PSD:
%PSD = find_PSD(locs_Rwave,Fs);

%SDSD : Standard deviation of the differencee between adjacent IBIs 
SDSD = find_SDSD(locs_Rwave)

%RMSSD - square root of the mean of the sum of the squares of the
%differences between adjacent IBIs in a segment.
RMSSD = find_RMSSD(locs_Rwave)

%QRSarea : Area of QRS complex by 2D formula of area
% Area = |Ax(By-Cy)+Bx(Cy-Ay)+Cx(Ay-By)|/2
% Q(Qloc,Qamp) R(R_Peakloc,R_PeakAmp) S(Sloc,Samp)
QRSarea = find_QRSarea(Qloc,Qamp,R_Peakloc,R_PeakAmp,Sloc,Samp)

%QRSperimeter: Distance between QR RS and QS points and their sum.
QRSperi = find_peri(Qloc,Qamp,R_Peakloc,R_PeakAmp,Sloc,Samp)

%Slope of QR line : PQslope, QRslope, RSslope, STslope
%Slope formula in 2D geometry - y2-y1/x2-x1
PQslope = find_slope(Ploc,Pamp,Qloc,Qamp)
QRslope = find_slope(Qloc,Qamp,R_Peakloc,R_PeakAmp)
RSslope = find_slope(R_Peakloc,R_PeakAmp,Sloc,Samp)
STslope = find_slope(Sloc,Samp,Tloc,Tamp)

%Angle of the signal : PQRang, QRSang, RSTang
%Angle between two lines is given by tan(theta) = (m1-m2)/(1+m1*m2):
%atand() - Function
%PQRang : Depends on slope of PQslope  and QRslope value
PonPQang = find_angle(PON,PONamp,Ploc,Pamp,Qloc,Qamp)
PQRang = find_angle(Ploc,Pamp,Qloc,Qamp,R_Peakloc,R_PeakAmp)
QRSang = find_angle(Qloc,Qamp,R_Peakloc,R_PeakAmp,Sloc,Samp)
RSTang = find_angle(R_Peakloc,R_PeakAmp,Sloc,Samp,Tloc,Tamp)
STToffang = find_angle(Sloc,Samp,Tloc,Tamp,TOFF,TOFFamp)

%Label = {'ARR'};
Featset = [hbpermin,Pseg,PQseg,QRSseg,QRseg,QTseg,RSseg,STseg,Tseg,PTseg,ECGseg,QRtoQSdur,RStoQSdur,RRmean,PPmean...
           PQdis,PonQdis,PRdis,PonRdis,PSdis,PonSdis,PTdis,PonTdis,PToffdis,QRdis,QSdis,QTdis,QToffdis,RSdis,RTdis,...
           RToffdis,STdis,SToffdis,PonToffdis,PonPQang,PQRang,QRSang,RSTang,STToffang,RRTot,NNTot...
           SDRR,IBIM,IBISD,SDSD,RMSSD,QRSarea,QRSperi,PQslope,QRslope,RSslope,STslope,NN50,pNN50];
           
