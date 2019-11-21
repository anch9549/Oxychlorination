function outvar = handler(v,y,phi,H_tot,Cp_tot,Lr,D,Beta,Dp,Ac,N,U,flowC,Ftotal_0,T0,P0,Tc0)
%Species indices key:
    % 1 = c2h4
    % 2 = hcl
    % 3 = o2
    % 4 = 1,1,2-trichloroethane
    % 5 = co2
    % 6 = cl2
    % 7 = 1,2-dichloroethane
    % 8 = h2o
    
% Unload variables
F1 = y(1); % units of mol/s
F2 = y(2);
F3 = y(3);
F4 = y(4);
F5 = y(5);
F6 = y(6);
F7 = y(7);
F8 = y(8);
T = y(9); % units of K
P = y(10); % units of kPa
Tc = y(11); % units of K
Ftotal = (F1 + F2 + F3 + F4 + F5 + F6 + F7 + F8);
As = D * pi * Lr; % units of m2
Do = D + 2*.0036; % units of m
Cpc = ((Tc - 273) * .0029 + 1.5041 + 273)/1000; % units of kJ/(kg*K)

% Calculate partial pressures for each species 
pp = [0,0,0,0,0,0,0,0];
for i = 1:length(pp)
    pp(i) = (y(i)/Ftotal)*(T0/T)*P; % units of kPa
end

% Rate expressions from paper
R_kinetics = 8.3144621; % units of J/(mol*K)

% a's are the pre-exponential factors from the Lakshmanan paper
a1 = 10^4.2; 
a2 = 10^13.23; 
a3 = 10^6.78;  

% E's are acivation energies from the Lakshmanan paper.
E1 = -40100; % units of J
E2 = -128080; 
E3 = -112000;

% Calculate rate constants
k(1) = a1 * exp(E1/(R_kinetics*T));
k(2) = a2 * exp(E2/(R_kinetics*T));
k(3) = a3 * exp(E3/(R_kinetics*T));
k(4) = (1000 * exp(17.13 - 13000/(1.987*T))) / exp(5.4+16000/(1.987*T));
%Rate constant units vary, see Lakshmanan paper for units

% Calculate rate equations
r1 = k(1) * pp(1) * pp(6)^0.5/3600; % units of mol/(L cat. * s)
r2 = k(2) * pp(7) * pp(6)^0.5/3600;
r3 = k(3) * pp(1) * pp(3) * pp(6)^0.5/3600;
r4 = k(4) * pp(3) / pp(6)/3600;
