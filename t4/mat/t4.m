%Optimized values

C1 = 7.5007e-04;
C2 = 7.5007e-04;
C3 = 6.4997e-04;
RB1 = 3.9999e+04;
RB2 = 2.9353e+03;
RC1 = 4.9996e+03;
RE1 = 100.0070;
RE2 = 599.5248;

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


gm1=IC1/VT;
rpi1=BFN/gm1;
ro1=VAFN/IC1;

RSB=RB*RS/(RB+RS);

AV1 = RSB/RS * RC1*(RE1-gm1*rpi1*ro1)/((ro1+RC1+RE1)*(RSB+rpi1+RE1)+gm1*RE1*ro1*rpi1 - RE1^2);
AV1_DB = 20*log10(abs(AV1));

ZI1 = 1/(1/RB+1/(((ro1+RC1+RE1)*(rpi1+RE1)+gm1*RE1*ro1*rpi1 - RE1^2)/(ro1+RC1+RE1)));
ZO1 = 1/(1/ro1+1/RC1);

%ouput stage
RL = 8;
BFP = 227.3;
VAFP = 37.2;
VEBON = 0.7;
VI2 = VO1;
IE2 = (VCC-VEBON-VI2)/RE2;
IC2 = BFP/(BFP+1)*IE2;
VO2 = VCC - RE2*IE2;

gm2 = IC2/VT;
go2 = IC2/VAFP;
gpi2 = gm2/BFP;
ge2 = 1/RE2;

AV2 = gm2/(gm2+gpi2+go2+ge2);
AV2_DB = 20*log10(abs(AV2));

ZI2 = (gm2+gpi2+go2+ge2)/gpi2/(gpi2+go2+ge2);
ZO2 = 1/(gm2+gpi2+go2+ge2);


%total
gB = 1/(1/gpi2+ZO1);
AV = (gB+gm2/gpi2*gB)/(gB+ge2+go2+gm2/gpi2*gB)*AV1;
AV_DB = 20*log10(abs(AV));

ZI=ZI1;
ZO=1/(go2+gm2/gpi2*gB+ge2+gB);

%LowCutOff Frequency
R1S = RS + (1/(1/RB + 1/rpi1));
R2S = RL + (1/(1/RC1 + 1/ro1));
R3S = 1/((1/RE1) + (1/(rpi1 + (1/(1/RS + 1/RB)))) + ((gm1*rpi1)/(rpi1 + (1/(1/RS + 1/RB)))));
wL = 1/(R1S*C1) + 1/(R2S*C2) + 1/(R3S*C3);
fL = wL/(2*pi);

%HighCutOff Frequency
Cpi = 16.1e-12;
Co = 4.388e-12;
wH = 1/(Cpi*rpi1 + Co*ro1);
fH = wH/(2*pi);

%Plot
w = logspace(1,12);
Tdb = ones(1,length(w));

for k = 1:length(w)
	T = 10^((AV_DB-20*log10(wL))/20)*(w(k)/(w(k)/wL + 1))*(1/(w(k)/wH + 1));
	Tdb(k) = 20*log10(abs(T));
end

%Merit and cost calculations
cost = 1e-3*(RE1 + RC1 + RB1 + RB2 + RE2) + 1e6*(C1 + C2 + C3) + 2*0.1;
Merit = (abs(AV_DB) * (fH-fL))/(cost * fL);

%Ponto 3 Teorica
printf ("ponto1_TAB\n");
printf ("VCE = %e V\n", VCE);
printf ("VBEON = %e V \n", VBEON);
printf ("VEC = %e V\n", VO2);
printf ("VEBON = %e V \n", VEBON);
printf ("IB1 = %e A \n", IB1);
printf ("IC1 = %e A \n", IC1);
printf ("IE1 = %e A \n", IE1);
printf ("IB2 = %e A \n", IC2-IE2);
printf ("IC2 = %e A \n", IC2);
printf ("IE2 = %e A \n", IE2);
printf ("ponto1_END\n\n");

%Ponto 2 Teorica
printf ("ponto2_TAB\n");
printf ("First Stage\n");
printf ("AV1-DB = %e dB\n", AV1_DB);
printf ("ZI1 = %e Omega \n", ZI1);
printf ("ZO1 = %e Omega \n", ZO1);
printf ("Second Stage\n");
printf ("AV2-DB = %e dB\n", AV2_DB);
printf ("ZI2 = %e Omega \n", ZI2);
printf ("ZO2 = %e Omega \n", ZO2);
printf ("Complete\n");
printf ("ZO = %e Omega\n", ZO);
printf ("AV-DB = %e dB\n", AV_DB);
printf ("Merit = %e \n", Merit);
printf ("HighCutOff frequency = %e Hz\n", fH);
printf ("LowCutOff frequency = %e Hz\n", fL);
printf ("Cost = %e MU's\n", cost);
printf ("Bandwidth = %e rad/s\n", fH-fL);
printf ("ponto2_END\n\n");

%Ponto 3 Teorica
Gain = figure ();
plot(log10(w/(2*pi)),Tdb,"g");
legend("v_o(f)/v_i(f)");

xlabel ("Log10(Frequency [Hz])");
ylabel ("Gain");

print (Gain, "Gain", "-depsc");
