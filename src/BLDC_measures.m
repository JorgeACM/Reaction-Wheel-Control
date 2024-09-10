% System parameters
L = 5.2e-3;    % Motor inductance (H)
J = 2.54e-3;   % Reaction wheel inertia (kg*m^2)
b = 10e-6;     % Viscous friction coefficient of the reaction wheel (N*m*s)
R = 5.6;       % Motor resistance (Ohm)
Ke = 67.5e-3;  % Back EMF constant (V*s/rad)
Kt = Ke;
Ktt = 78.48e-3; % Motor torque constant (N*m/A)
Js = 0.05116;  % Satellite inertia (kg*m^2)
Jw = J;

s = tf('s');
% motor_tf = (s*Jw / Ke) / (1 + s*Jw*R / (Ke*Ke));
% K = 11200.0158265711;
K = 11200;
Ke * Kt / (K * Jw);
% num = K / (s*R);
% den = 1 + (K / (s*R)) * (1 + (Ke * Kt / (K * Jw)));
% motor_tf = (K / (s * R)) / (1 + (K / s * R) * (1 + (Ke * Ke / (K * Jw))));
motor_tf = 1 / (1 + s * (R / K));
motor_ss = ss(motor_tf);

% Check controllability
controllability = ctrb(motor_ss.A, motor_ss.B);
rank_controllability = rank(controllability);
if rank_controllability == size(motor_ss.A, 1)
    disp('The system is fully controllable.');
else
    disp('The system is NOT fully controllable.');
end

% Check observability
observability = obsv(motor_ss.A, motor_ss.C);
rank_observability = rank(observability);
if rank_observability == size(motor_ss.A, 1)
    disp('The system is fully observable.');
else
    disp('The system is NOT fully observable.');
end
pole(motor_tf);

figure;
step(motor_tf);
% impulse(motor_tf)
% info = stepinfo(syscl);
% info(1);
% info(2);
% hold on;
title('Reaction Wheel in Torque Mode Step Response.', 'FontSize', 11, 'FontName', 'Times New Roman'); % Set title size
xlabel('Time', 'FontSize', 11, 'FontName', 'Times New Roman'); % Set x-axis label size
grid on;  % Turn on the grid

set(findall(gcf, '-property', 'FontSize'), 'FontSize', 11, 'FontName', 'Times New Roman');

% Save the figure at the specified location
path = '../Imagenes/';  % Go one level up and into the 'Imagenes' folder
fileName = 'SimplifiedTorqueModeRW.png';
% Save the figure using the path and file name variables
saveas(gcf, [path, fileName]);  % Save as PNG

figure;
pzmap(motor_tf);
grid on;

% Set font type and size (Times New Roman, size 11)
set(gca, 'FontSize', 11, 'FontName', 'Times New Roman');  % Change font type and size

% Customize the title and labels with Times New Roman and size 11
title('Pole-Zero Map', 'FontSize', 11, 'FontWeight', 'bold', 'FontName', 'Times New Roman');  
xlabel('Real Axis     ', 'FontSize', 11, 'FontName', 'Times New Roman');  
ylabel('Imaginary Axis     ', 'FontSize', 11, 'FontName', 'Times New Roman');  

% Access the axes handles and set custom labels with size adjustments
axesHandles = findall(gcf, 'Type', 'axes');

% Adjust the plot limits if necessary
xlim([-3000 0]);  % Adjust X-axis for better view (depending on your poles)
ylim([-1 1]);

% Change the colors and styles of poles and zeros
p = findobj(gca, 'Type', 'line');  % Find objects of type 'line'
set(p, 'MarkerSize', 10, 'LineWidth', 1);  % Increase the size of poles/zeros and line width
set(p, 'Color', 'b');  % Change color to blue (you can use other colors if preferred)

% Save the figure at the specified location
path = '../Imagenes/';  % Go one level up and into the 'Imagenes' folder
fileName = 'PoleZeroMap_SimplifiedInnerLoop.png';
% Save the figure using the path and file name variables
saveas(gcf, [path, fileName]);  % Save as PNG

% % Nyquist
figure;
nyquist(motor_tf);
grid on;

% Define the frequency range in rad/s (logspace allows for a logarithmic range)
w = logspace(-1, 2, 500);  % From 10^-1 to 10^2 rad/s with 500 points

% Generate the Nyquist plot with the adjusted frequency range
figure;
nyquist(syscl, w);
grid on;
title('Nyquist Diagram');
