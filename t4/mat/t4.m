%variaveis otimizadas
C1 = 1.7695e-06;
C2 = 7.8666e-05;
RB1 = 6634.6;
RB2 = 1318.4;
RC1 = 9971.4;
RE1 = 1444;

i = complex(0,1);
f = logspace(1,8, 100);
w = 2*pi*f;
vi = 0.01;
VT=25e-3;
BFN=178.7;
VAFN=69.7;
VBEON=0.7;
VCC=12;
RS=100;

RB=1/(1/RB1+1/RB2);
VEQ=RB2/(RB1+RB2)*VCC;
IB1=(VEQ-VBEON)/(RB+(1+BFN)*RE1);
IC1=BFN*IB1;
IE1=(1+BFN)*IB1;
VE1=RE1*IE1;
VO1=VCC-RC1*IC1;
VCE=VO1-VE1;

printf ("op_TAB\n");
printf ("VCE = %e V \n", VCE);
printf ("VBEON = %e V \n", VBEON);
printf ("op_END\n\n");

gm1 = IC1/VT;
rpi1 = BFN/gm1;
ro1 = VAFN/IC1;
Zc1 = 1./(i*w*C1);
Zc2 = 1./(i*w*C2);

I=ones(length(w),4);
voE=zeros(1,length(w));
AV1=zeros(1,length(w));

for k=1:length(w)
A = [0, -RB, 0, 0, RS+RB;
    -RE1, -Zc2(k), 0, RE1 + Zc2(k), 0; 
    RE1 + ro1 + RC1, 0, -ro1, -RE1, 0;
    0, gm1*rpi1, 1, 0, 0;
    0, RB+Zc1(k)+rpi1+Zc2(k), 0, -Zc2(k), -RB];

N = [vi; 0; 0; 0; 0];
res = A\N;

voE(k) = abs(RC1 * res(1));

AV1(k) = voE(k)/vi;
endfor

ZI1 = 1/(1/RB + 1/rpi1);

ZO1 = 1/(1/ro1 + 1/RC1);

%ZI1 = ((ro1+RC1+RE1)*(RB+rpi1+RE1)+gm1*RE1*ro1*rpi1 - RE1^2)/(ro1+RC1+RE1);

%ZX = ro1*((RB+rpi1)*RE1/(RB+rpi1+RE1))/(1/(1/ro1+1/(rpi1+RB)+1/RE1+gm1*rpi1/(rpi1+RB)));

%ZO1 = 1/(1/ZX+1/RC1);

Gain = figure ();
plot (log10(f), 20*log10(AV1), "b");
legend("v_o(f)/v_i(f)");

xlabel ("Frequency [Hz]");
ylabel ("Gain");

print (Gain, "Gain", "-depsc");

%ouput stage
BFP = 227.3;
VAFP = 37.2;
RE2 = 100;
VEBON = 0.7;
VI2 = VO1;
IE2 = (VCC-VEBON-VI2)/RE2;
IC2 = BFP/(BFP+1)*IE2;
VO2 = VCC - RE2*IE2;

gm2 = IC2/VT;
go2 = IC2/VAFP;
gpi2 = gm2/BFP;
ge2 = 1/RE2;

ro2 = 1/go2;
rpi2 = 1/gpi2;

I2=zeros(length(w),3);
vo2=zeros(1,length(w));
AV2 = zeros(1,length(w));

for k=1:length(w)
A2 = [rpi2+RE2, -RE2, 0;
    gm2*rpi2, 0, 1; 
    -RE2, RE2+ro2, -ro2];

N2 = [voE(k); 0; 0];
res = A2\N2;

vo2(k) = abs((res(1)-res(2))*RE2);

AV2(k) = vo2(k)/voE(k);

endfor


ZI2 = (gm2+gpi2+go2+ge2)/gpi2/(gpi2+go2+ge2);

ZO2 = 1/(gm2+gpi2+go2+ge2);

ZO = 1/(gm2*(rpi2/(rpi2+ZO1))+(1/(rpi2+ZO1))+go2+ge2);

AV = AV1.*AV2;

Output = figure ();
plot (log10(f), 20*log10(AV), "g");
legend("v_o(f)/v_i(f)");

xlabel ("Frequency [Hz]");
ylabel ("Gain");

print (Output, "Output", "-depsc");

AVdb = 20*log10(AV);
maximo = max(AVdb)

k = 1;

while  0.05 < ((maximo - AVdb(k))/maximo)
    k = k + 1;
endwhile

lowerCutoff = (w(k))/(2*pi);
highCutoff = 10^7;

bandwidth = highCutoff - lowerCutoff;

cost = 1e-3*(RE1 + RC1 + RB1 + RB2 + RE2) + 1e6*(C1 + C2) + 2*0.1;

AV=abs(AV);

Merit = (max(AV) * bandwidth)/(cost * lowerCutoff);

printf ("ponto2_TAB\n");
printf ("AV1 = %e \n", max(AV1));
printf ("ZI1 = %e \n", ZI1);
printf ("ZO1 = %e \n", ZO1);
printf ("AV2 = %e V \n", max(AV2));
printf ("ZI2 = %e \n", ZI2);
printf ("ZO2 = %e \n", ZO2);
printf ("ZO = %e \n", ZO);
printf ("ponto2_END\n\n");