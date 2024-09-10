 % System parameters
L = 5.2e-3;    % ESTIMATED - Inductance of the motor (H)
J = 2.54e-3;   % Inertia of the reaction wheel (kg*m^2)
b = 10e-6;     % ESTIMATED - Viscous friction coefficient of the reaction wheel (N*m*s)
R = 5.6;       % Resistance of the motor (Ohm)
Ke = 67.5e-3;  % Back EMF constant (V*s/rad)
Ktt = 78.48e-3; % Torque constant of the motor (N*m/A)
Js = 0.05116;  % Inertia of the satellite (kg*m^2)
Kt = Ke;
Jr=Js;
Jb=Js;
Jw=J;