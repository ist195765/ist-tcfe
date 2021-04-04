
close all
clear all


%% Read data.txt file to obtain the values

fp = fopen ("~/ist-tcfe/t2/data.txt","r");
str = importdata("~/ist-tcfe/t2/data.txt", '\t', 14);

R1 = sscanf(char (str(4,1)), "Values:  R1 = %e")*1000;
R2 = sscanf(char (str(5,1)), "R2 = %e")*1000;
R3 = sscanf(char (str(6,1)), "R3 = %e")*1000;
R4 = sscanf(char (str(7,1)), "R4 = %e")*1000;
R5 = sscanf(char (str(8,1)), "R5 = %e")*1000;
R6 = sscanf(char (str(9,1)), "R6 = %e")*1000;
R7 = sscanf(char (str(10,1)), "R7 = %e")*1000;
Vs = sscanf(char (str(11,1)), "Vs = %e");
C = sscanf(char (str(12,1)), "C = %e")/1000000;
Kb = sscanf(char (str(13,1)), "Kb = %e")/1000;
Kd = sscanf(char (str(14,1)), "Kd = %e")*1000;

fclose(fp);  

%% Difining variables


U = 1.0;
Z = 0.0;

G1 = 1/R1;
G2 = 1/R2;
G3 = 1/R3;
G4 = 1/R4;
G5 = 1/R5;
G6 = 1/R6;
G7 = 1/R7;


%%Theoretical analysis point 1

cir1 = fopen('circuit1.cir','w');

fprintf (cir1,".OP\n");
fprintf (cir1,"R1 1 2 %e \n", R1);
fprintf (cir1,"R2 3 2 %e \n", R2);
fprintf (cir1,"R3 2 5 %e \n", R3);
fprintf (cir1,"R4 5 0 %e \n", R4);
fprintf (cir1,"R5 5 6 %e \n", R5);
fprintf (cir1,"R6 9 7 %e \n", R6);
fprintf (cir1,"R7 7 8 %e \n", R7);
fprintf (cir1,"Vs 1 0 %e \n", Vs);
fprintf (cir1,"Vaux 0 9 %e \n", 0);
fprintf (cir1,"Hd 5 8 Vaux %e \n", Kd);
fprintf (cir1,"Gb 6 3 (2,5) %e \n", Kb);
fprintf (cir1,".END\n");

fclose(cir1);

N1 = [U, Z, Z, -U, Z, Z, Z, Z; 
    Z, -G2-Kb, G2, Z, Kb, Z, Z, Z; 
    -G1, G1+G2+G3, -G2, Z, -G3, Z, Z, Z; 
    Z, Kb, Z, Z, -G5-Kb, G5, Z, Z; 
    Z, Z, Z, -Kd*G6, U, Z, Kd*G6, -U; 
    Z, Z, Z, -G6, Z, Z, G6+G7, -G7; 
    G1, -G1, Z, G4+G6, -G4, Z, -G6, Z; 
    Z, Z, Z, U, Z, Z, Z, Z];

NB1 = [Vs; Z; Z; Z; Z; Z; Z; Z];

V1 = N1\NB1; 

printf ("Tensoes_TAB\n");
printf ("V1 = = %e V\n", V1(1));
printf ("V2 = = %e V\n", V1(2));
printf ("V3 = = %e V\n", V1(3));
printf ("V4 = = %e V\n", V1(4));
printf ("V5 = = %e V\n", V1(5));
printf ("V6 = = %e V\n", V1(6));
printf ("V7 = = %e V\n", V1(7));
printf ("V8 = = %e V\n", V1(8));
printf ("Tensoes_END\n");

%%Theoretical analysis point 2

Vx = 50;

cir2 = fopen('circuit2.cir','w');

fprintf (cir2,".OP\n");
fprintf (cir2,"R1 1 2 %e \n", R1);
fprintf (cir2,"R2 3 2 %e \n", R2);
fprintf (cir2,"R3 2 5 %e \n", R3);
fprintf (cir2,"R4 5 0 %e \n", R4);
fprintf (cir2,"R5 5 6 %e \n", R5);
fprintf (cir2,"R6 9 7 %e \n", R6);
fprintf (cir2,"R7 7 8 %e \n", R7);
fprintf (cir2,"Vx 6 8 %e \n", Vx);
fprintf (cir2,"Vaux 0 9 %e \n", 0);
fprintf (cir2,"Hd 5 8 Vaux %e \n", Kd);
fprintf (cir2,"Gb 6 3 (2,5) %e \n", Kb);
fprintf (cir2,".END\n");

fclose(cir2);

N2 = [Z, Z, Z, Z, Z, U, Z, -U; 
 Z, -G2-Kb, G2, Z, Kb, Z, Z, Z;
 -G1, G1+G2+G3, -G2, Z, -G3, Z, Z, Z; 
 U, Z, Z, -U, Z, Z, Z, Z;
 Z, Z, Z, -Kd*G6, U, Z, Kd*G6, -U;
 Z, Z, Z, -G6, Z, Z, G6+G7, -G7;
 G1, -G1, Z, G4+G6, -G4, Z, -G6, Z; 
 Z, Z, Z, U, Z, Z, Z, Z];
 
NB2 = [Vx; Z; Z; Z; Z; Z; Z; Z];

V2 = N2\NB2;

Ix = -(V2(5)-V2(6))*G5 - Kb*(V2(2)-V2(5));

Req = Vx/Ix;

%%Theoretical analysis point 3

t = 0:1e-6:20e-3;

Vi = V1(6) - V1(8);

V6n = Vi*exp(-t/(C*Req));

NaturalResponse = figure ();
plot (t*1000, V6n, "g");
xlabel ("t[ms]");
ylabel ("V6n(t) [V]");
legend({"V6n(t)"});
print(NaturalResponse, "NaturalResponse.eps", "-depsc");

cir3 = fopen('circuit3.cir','w');

fprintf (cir3,".OP\n");
fprintf (cir3,"R1 1 2 %e \n", R1);
fprintf (cir3,"R2 3 2 %e \n", R2);
fprintf (cir3,"R3 2 5 %e \n", R3);
fprintf (cir3,"R4 5 0 %e \n", R4);
fprintf (cir3,"R5 5 6 %e \n", R5);
fprintf (cir3,"R6 9 7 %e \n", R6);
fprintf (cir3,"R7 7 8 %e \n", R7);
fprintf (cir3,"C1 6 8 %e \n", C);
fprintf (cir3,".IC v(6) = %e v(8) = %e\n", V1(6), V1(8));
fprintf (cir3,"Vaux 0 9 %e \n", 0);
fprintf (cir3,"Hd 5 8 Vaux %e \n", Kd);
fprintf (cir3,"Gb 6 3 (2,5) %e \n", Kb);
fprintf (cir3,".END\n");

fclose(cir3);


%%Theoretical analysis point 4

f = 1000;
w = 2*pi*f;
Zc = 1/(j*w*C);
phi = 0;


N3 = [U, Z, Z, -U, Z, Z, Z, Z; 
    Z, -G2-Kb, G2, Z, Kb, Z, Z, Z; 
    -G1, G1+G2+G3, -G2, Z, -G3, Z, Z, Z; 
    Z, Kb, Z, Z, -G5-Kb, G5+U/Zc, Z, -U/Zc; 
    Z, Z, Z, -Kd*G6, U, Z, Kd*G6, -U; 
    Z, Z, Z, -G6, Z, Z, G6+G7, -G7; 
    G1, -G1, Z, G4+G6, -G4, Z, -G6, Z; 
    Z, Z, Z, U, Z, Z, Z, Z];

NB3 = [U; Z; Z; Z; Z; Z; Z; Z];

V3 = N3\NB3;

printf ("ComplexAmplitudes_TAB\n");
printf ("V1 = = %e + i(%e) V\n", real(V3(1)), imag(V3(1)));
printf ("V2 = = %e + i(%e) V\n", real(V3(2)), imag(V3(2)));
printf ("V3 = = %e + i(%e) V\n", real(V3(3)), imag(V3(3)));
printf ("V4 = = %e + i(%e) V\n", real(V3(4)), imag(V3(4)));
printf ("V5 = = %e + i(%e) V\n", real(V3(5)), imag(V3(5)));
printf ("V6 = = %e + i(%e) V\n", real(V3(6)), imag(V3(6)));
printf ("V7 = = %e + i(%e) V\n", real(V3(7)), imag(V3(7)));
printf ("V8 = = %e + i(%e) V\n", real(V3(8)), imag(V3(8)));
printf ("ComplexAmplitudes_END\n");

cir4 = fopen('circuit4.cir','w');

fprintf (cir4,".OP\n");
fprintf (cir4, "Vs 1 0 0.0 AC 1.0 sin(0 1 1000)\n");
fprintf (cir4,"R1 1 2 %e \n", R1);
fprintf (cir4,"R2 3 2 %e \n", R2);
fprintf (cir4,"R3 2 5 %e \n", R3);
fprintf (cir4,"R4 5 0 %e \n", R4);
fprintf (cir4,"R5 5 6 %e \n", R5);
fprintf (cir4,"R6 9 7 %e \n", R6);
fprintf (cir4,"R7 7 8 %e \n", R7);
fprintf (cir4,"C1 6 8 %e \n", C);
fprintf (cir4,".IC v(6) = %e v(8) = %e\n", V1(6), V1(8));
fprintf (cir4,"Vaux 0 9 %e \n", 0);
fprintf (cir4,"Hd 5 8 Vaux %e \n", Kd);
fprintf (cir4,"Gb 6 3 (2,5) %e \n", Kb);
fprintf (cir4,".END\n");

fclose(cir4);

%%Theoretical analysis point 5

s = -5e-3:1e-6:20e-3;

ph6 = arg(V3(6)) + phi;

V6i = abs(V3(6));

V6n = Vi*exp(-t/(C*Req));
V6f = V6i*sin(w*t + ph6);

V6(-5e-3 <= s & s <= 0) = V1(6);
V6(0 <= s & s <= 20e-3) = V6n + V6f;

vs(-5e-3 <= s & s <= 0) = Vs;
vs(0 <= s & s <= 20e-3) = sin(w*t);

Solution = figure ();
plot (s*1000, vs, "g");
hold on;
plot (s*1000, V6, "b");
legend({"Vs(t)","V6(t)"});
print(Solution, "Solution.eps", "-depsc");
xlabel ("t[ms]");
ylabel ("Vs(t), V6(t) [V]");

%%Theoretical analysis point 6

f = logspace(-1,6,200);

for i = 1:200

w = 2*pi*f(i);
Zc = 1/(j*w*C);
phi = 0;


N3 = [U, Z, Z, -U, Z, Z, Z, Z; 
    Z, -G2-Kb, G2, Z, Kb, Z, Z, Z; 
    -G1, G1+G2+G3, -G2, Z, -G3, Z, Z, Z; 
    Z, Kb, Z, Z, -G5-Kb, G5+U/Zc, Z, -U/Zc; 
    Z, Z, Z, -Kd*G6, U, Z, Kd*G6, -U; 
    Z, Z, Z, -G6, Z, Z, G6+G7, -G7; 
    G1, -G1, Z, G4+G6, -G4, Z, -G6, Z; 
    Z, Z, Z, U, Z, Z, Z, Z];

NB3 = [U; Z; Z; Z; Z; Z; Z; Z];

V3 = N3\NB3;  
  
Vc = V3(6) - V3(8);

A6(i) = abs(V3(6));
Ac(i) = abs(Vc);

PH6(i) = arg(V3(6)) + phi;
PHc(i) = arg(Vc) + phi;
  
end


A = figure ();
plot (log10(f), 20*log10(1), "g");
hold on;
plot (log10(f), 20*log10(Ac), "b");
plot (log10(f), 20*log10(A6), "r");
legend({"Vs(f)","Vc(f)","V6(f)"});
print(A, "Amplitude.eps", "-depsc");
xlabel ("f[Hz]");
ylabel ("Vs(f), V6(f), Vc(f) [dB]");

Arg = figure ();
plot (log10(f), 0*(180/pi), "g");
hold on;
plot (log10(f), PHc*(180/pi), "b");
plot (log10(f), PH6*(180/pi), "r");
legend({"Vs(f)","Vc(f)","V6(f)"});
print(Arg, "Arguments.eps", "-depsc");
xlabel ("f[Hz]");
ylabel ("arg(Vs(f)), arg(V6(f)), arg(Vc(f)) [degrees]");

