close all
clear all

%% Symbolic variables

pkg load symbolic

format long

%% Resistors values defined


R1 = 1.01360927043;
R2 = 2.01657828976;
R3 = 3.00681599161;
R4 = 4.04922873502;
R5 = 3.05392516866;
R6 = 2.09250198059;
R7 = 1.0223196044;
Va = 5.21604048925;
Id = 1.02958724781;
Kb = 7.2133236346;
Kc = 8.32103470507;


%% Condutivities values obtained by the resistors 

G1 = 1/R1;
G2 = 1/R2;
G3 = 1/R3;
G4 = 1/R4;
G5 = 1/R5;
G6 = 1/R6;
G7 = 1/R7;

%% Values of zero and one defined 

Z = 0.0;

U = 1.0;

%% Matrices obtained by the mesh analysis method defined

M = [R1+R3+R4, R3, R4, Z; Kb*R3, Kb*R3 - U, Z, Z; R4, Z, R4+R6+R7-Kc, Z; Z, Z, Z, U];

MB = [Va; Z; Z; Id];

%% Determination of the Circulation Currents 

I = M\MB;

%% Matrices obtained by the node analysis method 

I = M\MB;

N = [U, Z, Z, -U, Z, Z, Z; Z, -G2-Kb, G2, Z, Kb, Z, Z; -G1, G1+G2+G3, -G2, Z, -G3, Z, Z; Z, Kb, Z, Z, -G5-Kb, G5, Z; Z, Z, Z, -Kc*G6, U, Z, Kc*G6; Z, Z, Z, -G6, Z, Z, G6+G7; G1, -G1, Z, G4+G6, -G4, Z, -G6];

NB = [Va; Z; Z; Id; Z; Z; Z];

%% Determination of the voltage in each node

V = N\NB;

%% Defining the tables in order to put them in the report

V = N\NB;

printf ("Resistências_TAB\n");
printf ("R1 = %e kOhm\n", R1);
printf ("R2 = %e kOhm\n", R2);
printf ("R3 = %e kOhm\n", R3);
printf ("R4 = %e kOhm\n", R4);
printf ("R5 = %e kOhm\n", R5);
printf ("R6 = %e kOhm\n", R6);
printf ("R7 = %e kOhm\n", R7);
printf ("Resistências_END\n");

printf ("Correntes_TAB\n");
printf ("Ia = %e mA\n", I(1));
printf ("Ib = %e mA\n", I(2));
printf ("Ic = %e mA\n", I(3));
printf ("Id = %e mA\n", I(4));
printf ("Correntes_END\n");

printf ("Tensoes_TAB\n");
printf ("V1 = = %e V\n", V(1));
printf ("V2 = = %e V\n", V(2));
printf ("V3 = = %e V\n", V(3));
printf ("V4 = = %e V\n", V(4));
printf ("V5 = = %e V\n", V(5));
printf ("V6 = = %e V\n", V(6));
printf ("V7 = = %e V\n", V(7));
printf ("V8 = = %e V\n", 0);
printf ("Tensoes_END\n");

printf("Constantes_TAB\n");
printf("Kb = %e V/mA\n", Kb);
printf("Kb = %e ma/V\n", Kb);
printf("Constantes_END\n");

