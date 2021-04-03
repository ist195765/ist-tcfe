
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

Vi = V1(6)-V1(8);

V6n = Vi*exp(-t/(C*Req));

hf = figure ();
plot (t*1000, V6n, "g");
xlabel ("t[ms]");
ylabel ("V6n(t) [V]");

%%Theoretical analysis point 4

f = 1000;
w = 2*pi*f;
Zc = 1/(j*w*C)


N1 = [U, Z, Z, -U, Z, Z, Z, Z; 
    Z, -G2-Kb, G2, Z, Kb, Z, Z, Z; 
    -G1, G1+G2+G3, -G2, Z, -G3, Z, Z, Z; 
    Z, Kb, Z, Z, -G5-Kb, G5+U/Zc, Z, -U/Zc; 
    Z, Z, Z, -Kd*G6, U, Z, Kd*G6, -U; 
    Z, Z, Z, -G6, Z, Z, G6+G7, -G7; 
    G1, -G1, Z, G4+G6, -G4, Z, -G6, Z; 
    Z, Z, Z, U, Z, Z, Z, Z];

NB1 = [Vs; Z; Z; Z; Z; Z; Z; Z];














