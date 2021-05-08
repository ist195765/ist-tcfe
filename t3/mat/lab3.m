close all;
clear all;

format long;

Vd = 0.6;
eta = 1;
fq = 50;
I_sat = 1e-14;
t_ratio = 10;
ndiode= 22;
Vs = 230;
R1 = 98437;
C = 0.0073476945;
Vt = 0.025;
w = 2*pi*fq;
T = 1/(2*fq);
toff = (1/4)*T;


R2 = 677410;


for k = 1:20
  func = (Vs/t_ratio)*C*w*sin(w*toff) - (1/R1)*(Vs/t_ratio)*cos(w*toff) - I_sat*(exp(12/(eta*Vt*ndiode))-1);
  funcd = (Vs/t_ratio)*C*(w^2)*cos(w*toff)+(1/R1)*(Vs/t_ratio)*w*sin(w*toff);
  toff = toff - (func/funcd);
endfor

ton = (3/4)*T;

Req = 1/((1/R1)+(1/R2));

for k = 1:20
  func = (Vs/t_ratio)*cos(w*ton)+(Vs/t_ratio)*cos(w*toff)*exp(-(1/(Req*C))*(ton-toff));
  funcd = -w*(Vs/t_ratio)*sin(w*ton)-(Vs/t_ratio)*cos(w*toff)*(1/(Req*C))*exp(-(1/(Req*C))*(ton-toff));
  ton = ton - (func/funcd);
endfor

t = 0:(1e-6):0.2;

tlength = length(t);

venvelope = ones(1, tlength);

for j = 1:tlength
  if t(j) <= toff
    venvelope(j) = abs((230/t_ratio)*cos(w*t(j)));
  else
    if t(j)<=ton
      venvelope(j) = (230/t_ratio)*abs(cos(w*toff))*exp(-(1/(Req*C))*(t(j)-toff));
    else
      toff = toff + T;
      ton = ton + T;
      if t(j)<=toff
        venvelope(j) = abs((230/t_ratio)*cos(w*t(j)));
      else
        if t(j)<=ton
          venvelope(j) = (230/t_ratio)*abs(cos(w*toff))*exp(-(1/(Req*C))*(t(j)-toff));
        endif
      endif
    endif
  endif
endfor



venvelopeDC = mean(venvelope);
ripple_venvelope = max(venvelope) - min(venvelope);
vcentroenvelope = (ripple_venvelope/2) + min(venvelope);

printf ("Envelope_Detector_Values_TAB\n");
printf ("Ripple = %e\n", ripple_venvelope);
printf ("Average = %e\n", venvelopeDC);
printf ("Envelope_Detector_Values_END\n");

rdiode = (eta*Vt)/(I_sat*exp((12/ndiode)/(eta*Vt)));
vregulatedAC  = ((ndiode*rdiode)/(ndiode*rdiode + R2))*(venvelope - venvelopeDC);

if vcentroenvelope >= 12
    vregulatedDC = 12;
else
    vregulatedDC = vcentroenvelope;
endif

vregulated = vregulatedAC + vregulatedDC;

average = mean(vregulated);

ripple = max(vregulated) - min(vregulated);

printf ("Voltage_Regulator_Values_TAB\n");
printf ("Ripple = %e\n", ripple);
printf ("Average = %e\n", average);
printf ("Voltage_Regulator_Values_END\n");

printf ("Circuit_Values_TAB\n");
printf ("C = %e\n", C);
printf ("R1 = %e\n", R1);
printf ("R2 = %e\n", R2);
printf ("num diodes = %e\n", ndiode);
printf ("Transformer Ratio = %e\n", t_ratio);
printf ("Circuit_Values_END\n");

V_i = (230/t_ratio)*cos(w*t);
Deviation = vregulated - 12;


MainPlot = figure();
plot(t*1000,venvelope);
hold on
plot(t*1000,vregulated);
plot(t*1000, Deviation);
plot(t*1000, V_i);
legend('EnvlopeDetector','VoltageRegulator','DC Deviation','InitialVoltage');
xlabel ("Time [ms]");
ylabel ("Voltages[V]");
hold off
print(MainPlot, "MainPlot.eps", "-depsc");

VoltageRegulator = figure();
plot(t*1000, vregulated);
legend('VolatgeRegulator');
xlabel ("Time [ms]");
ylabel ("Voltages[V]");
print(VoltageRegulator, "VoltageRegulator.eps", "-depsc");

DCDeviation = figure();
plot(t*1000, Deviation);
legend('DC Deviation');
xlabel ("Time [ms]");
ylabel ("Voltages[V]");
print(DCDeviation, "DCDeviation.eps", "-depsc");

EnvelopeDetector = figure();
plot(t*1000, venvelope);
legend('Envelope Detector');
xlabel ("Time [ms]");
ylabel ("Voltages[V]");
print(EnvelopeDetector, "EnvelopeDetector.eps", "-depsc");
