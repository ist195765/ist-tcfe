%Circuit Components
C1 =110e-09;
C2=220e-09;
R1=1000;
R2=1000;
R3=100000;
R4=1000;
Vcc=10;
printf ("valores_intro_TAB\n");
printf ("C1 = %e \n", C1);
printf ("C2 = %e \n", C2);
printf ("R1 = %e \n", R1);
printf ("R2 = %e \n", R2);
printf ("R3 = %e \n", R3);
printf ("R4 = %e \n", R4);
printf ("Vcc = %e \n", Vcc);
printf ("valores_intro_END\n\n");

%Low, High, Central Band Pass Frequencies
wL=1/(R1*C1);
wH=1/(R2*C2);
wo=sqrt(wL*wH);
printf ("band_pass_freq_TAB\n");
printf ("LowFreq BandPass = %e \n", wL); 
printf ("HighFreq BandPass = %e \n", wH);
printf ("Central Freq = %e \n", wo);
printf ("band_pass_freq_END\n\n");

%PONTO1%
%Central Frequency(Hz) and Respective Gain(dB)
T_central_freq = (R1*C1*j*wo/(1+R1*C1*j*wo))*(1+R3/R4)*(1/(1+R2*C2*j*wo));
Tdb_central_freq = 20*log10(abs(T_central_freq));
wo_Hz=wo/2/pi;
printf ("wo_freq_gain_TAB\n");
printf ("Central Freq (Hz) = %e \n", wo_Hz); 
printf ("Gain Central Freq (dB) = %e \n", Tdb_central_freq);
printf ("wo_freq_gain_END\n\n");
%Input and Output Impedancies
z_in = (R1 + 1/(j*wo*C1))
z_out = R2/(j*wo*C2)/(R2+1/(j*wo*C2))
printf ("impedances_TAB\n");
printf ("Z in = %e + %ej \n", real(z_in), imag(z_in)); 
printf ("Z out = %e + %ej\n", real(z_out) , imag(z_out));
printf ("impedances_END\n\n");

%PONTO2%
%Gain in dB - logscale from 10Hz to 100MHz
w = logspace(1,8,70);
s=j*w;
Tdb = ones(1,length(s));
for k = 1:length(s)
  T = ((R1*C1*s(k))/(1+R1*C1*s(k)))*(1+R3/R4)*(1/(1+R2*C2*s(k)));
	Tdb(k) = 20*log10(abs(T));
end
%--------Plot----------%
theo = figure ();
plot(log10(w/(2*pi)),Tdb,"g");
legend("v_o(f)/v_i(f)");
xlabel ("Log10(Frequency [Hz])");
ylabel ("Gain");
print (theo, "theo", "-depsc");


%Merit & Cost
Gain_Deviation = abs(40-Tdb_central_freq);
Central_Frequency_Deviation=abs(1000-wo_Hz);
cost = 1e-3*(R1 + R2 + R3 + R4 + 100 + 530500 + 183600 + 13190000 + 150) + 1e6*(C1 + C2) + 38.66e-18 + 0.1*2;
Merit = 1/(cost * Gain_Deviation * Central_Frequency_Deviation);
printf ("Cost_Merit_TAB\n");
printf ("Cost = %e \n", cost); 
printf ("Merit = %e \n", Merit);
printf ("Cost_Merit_END\n\n");