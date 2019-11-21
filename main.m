%Species indices key:
    % 1 = c2h4
    % 2 = hcl
    % 3 = o2
    % 4 = 1,1,2-trichloroethane
    % 5 = co2
    % 6 = cl2
    % 7 = 1,2-dichloroethane
    % 8 = h2o
    
%Heats of Reaction and Cp values at 533K
H_R1 = -240.14; % units of kJ/mol
H_R2 = -149.31;
H_R3 = -1321.08;
H_R4 = -116.82;
H_tot = [-240.14, -149.31, -1321.08, -116.82]; 

% our Cp values are about twice theirs -- not sure why!
Cp_1 = 23.29; % units of kJ/mol*K
Cp_2 = 15.54;
Cp_3 = 15.81;
Cp_4 = 42.88;
Cp_5 = 19.72;
Cp_6 = 17.44;
Cp_7 = 39.46;
Cp_8 = 18.07;
sumCp = Cp_1 + Cp_2 + Cp_3 + Cp_4 + Cp_5 + Cp_6 + Cp_7 + Cp_8;
Cp_tot = [23.29, 15.54, 15.81, 42.88, 19.72, 17.44, 39.46, 18.07];

%Main Properties, note that some of these values were taken from Aspen HYSYS
T0 = 500; % units of K
P0 = 1000; % units of kPa
D = 0.025; % units of m; diameter of tube
L = 1; % units of m
N = 2000; % number of tubes
Ac = (pi*((D^2)/4))*N; % units of m^2
A_tube = (pi*((D^2)/4)); % units of m^2
phi = 0.4; % represents the void fraction
Dp = D/8; % units of m; diameter of particle
mu = 2.11*10^-5; % units of kg/m*s
rho0 = 8.39; % units of kg/m^3
V_r = (pi*((D^2)/4))*N*L; % units of m^3
Vdot0 = 5110/3600; % units of m^3/s

%Coolant Properties
U = 0.3; % units of kW/m^2*K
Tc0 = 450; % units of K, boiling point is 530 K
flowC = 2000/3600; % units of kg/s

%Initial molar flowrates from starting material balance
F1_0 = 1000/3600; % units of mol/s
F2_0 = 3000/3600;
F3_0 = 1100/3600;
F4_0 = 0/3600;
F5_0 = 0/3600;
F6_0 = 0.0001/3600;
F7_0 = 0/3600;
F8_0 = 0/3600;
Ftotal_0 = F1_0 + F2_0 + F3_0 + F4_0 + F5_0 + F6_0 + F7_0 + F8_0;

%Ergun Equation Parameters
G = rho0*(Vdot0/Ac)/N; % units of kg/(m^2 * s)
Beta = (G/(rho0*Dp)) * ((1-phi)/(phi^3)) * (((150*(1-phi)*mu)/Dp) + (1.75*G)/1000); %kPa/m

%Logic
numElements = 200; % number of solver iterations
vspan = linspace(0, V_r, numElements);
y0 = [F1_0 F2_0 F3_0 F4_0 F5_0 F6_0 F7_0 F8_0 T0 P0 Tc0]; % load dependent variables
handleranon = @(v,y) handler(v,y,phi,H_tot,Cp_tot,Lr,D,Beta,Dp,Ac,N,U,flowC,Ftotal_0,T0,P0,Tc0);

