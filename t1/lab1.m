close all
clear all

%% Symbolic variables

pkg load symbolic

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

G1 = 1/R1;
G2 = 1/R2;
G3 = 1/R3;
G4 = 1/R4;
G5 = 1/R5;
G6 = 1/R6;
G7 = 1/R7;

Z = 0.0;

U = 1.0;

M = [R1+R3+R4, R3, R4, Z; Kb*R3, Kb*R3 - U, Z, Z; R4, Z, R4+R6+R7-Kc, Z; Z, Z, Z, U];

MB = [Va; Z; Z; Id];

X= M\MB

N = [U, Z, Z, -U, Z, Z, Z; Z, -G2-Kb, G2, Z, Kb, Z, Z; -G1, G1+G2+G3, -G2, Z, -G3, Z, Z; Z, Kb, Z, Z, -G5-Kb, G5, Z; Z, Z, Z, -Kc*G6, U, Z, Kc*G6; Z, Z, Z, -G6, Z, Z, G6+G7; Z, Z, Z, Z, U, Z, -Kc*G7];

NB = [Va; Z; Z; Id; Z; Z; Z];

Y= N\NB










