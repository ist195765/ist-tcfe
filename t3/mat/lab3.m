close all;
clear all;

format long;

R1 = 98437;
C = 0.0073476945;
n = 10;
eta = 1;
freq = 50;
I_s = 1e-14;
k = 22;
Vd = 0.6;
Vs = 230;
Vt = 0.025;
w = 2*pi*freq;

T = 1/(2*freq);
t_off = (1/4)*T;

R2 = ((230/n)-12)/(I_s*(exp(12/(eta*Vt*k))-1));

for i = 1:20
  f = (Vs/n)*C*w*sin(w*t_off) - (1/R1)*(Vs/n)*cos(w*t_off) - I_s*(exp(12/(eta*Vt*k))-1);
  fl = (Vs/n)*C*(w^2)*cos(w*t_off)+(1/R1)*(Vs/n)*w*sin(w*t_off);
  t_off = t_off - (f/fl);
endfor

t_on = (3/4)*T;

Req = 1/((1/R1)+(1/R2));

for i = 1:20
  f = (Vs/n)*cos(w*t_on)+(Vs/n)*cos(w*t_off)*exp(-(1/(Req*C))*(t_on-t_off));
  fl = -w*(Vs/n)*sin(w*t_on)-(Vs/n)*cos(w*t_off)*(1/(Req*C))*exp(-(1/(Req*C))*(t_on-t_off));
  t_on = t_on - (f/fl);
endfor

t = 0:(1e-6):0.2;

l = length(t);

v0_env = ones(1,l);

for i = 1:l
  if t(i)<=t_off
    v0_env(i) = abs((230/n)*cos(w*t(i)));
  else
    if t(i)<=t_on
      v0_env(i) = (230/n)*abs(cos(w*t_off))*exp(-(1/(Req*C))*(t(i)-t_off));
    else
      t_off = t_off + T;
      t_on = t_on + T;
      if t(i)<=t_off
        v0_env(i) = abs((230/n)*cos(w*t(i)));
      else
        if t(i)<=t_on
          v0_env(i) = (230/n)*abs(cos(w*t_off))*exp(-(1/(Req*C))*(t(i)-t_off));
        endif
      endif
    endif
  endif
endfor



v0_env_dc = mean(v0_env);
ripple_v0_env = max(v0_env) - min(v0_env);
v0_env_centro = (ripple_v0_env/2) + min(v0_env);

printf ("Envlope_Detector_Values_TAB\n");
printf ("Ripple = %e\n", ripple_v0_env);
printf ("Average = %e\n", v0_env_dc);
printf ("Envlope_Detctor_Values_END\n");

rd = (eta*Vt)/(I_s*exp((12/k)/(eta*Vt)));
v0_reg_ac = ((k*rd)/(k*rd + R2))*(v0_env - v0_env_dc);

if v0_env_centro >= 12
    v0_reg_dc = 12;
else
    v0_reg_dc = v0_env_centro;
endif

v0_reg = v0_reg_ac + v0_reg_dc;

testar = v0_reg - 12;
average = mean(testar);
ripple = max(v0_reg) - min(v0_reg);

printf ("Volatge_Regulator_Values_TAB\n");
printf ("Ripple = %e\n", ripple);
printf ("Average = %e\n", average);
printf ("Volatge_Regulator_Values_END\n");

V_i = (230/n)*cos(w*t);
Deviation = v0_reg - 12;


MainPlot = figure();
plot(t*1000,v0_env);
hold on
plot(t*1000,v0_reg);
plot(t*1000, Deviation);
plot(t*1000, V_i);
legend('EnvlopeDetector','VolatgeRegulator','DC Deviation','InitialVoltage');
xlabel ("Time [ms]");
ylabel ("Voltages[V]");
hold off
print(MainPlot, "MainPlot.eps", "-depsc");

VoltageRegulator = figure();
plot(t*1000,v0_reg);
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
