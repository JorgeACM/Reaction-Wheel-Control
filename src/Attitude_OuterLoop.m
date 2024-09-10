 % System parameters
L = 5.2e-3;    % Inductance of the motor (H)
J = 2.54e-3;   % Inertia of the reaction wheel (kg*m^2)
b = 10e-6;     % Viscous friction coefficient of the reaction wheel (N*m*s)
R = 5.6;       % Resistance of the motor (Ohm)
Ke = 67.5e-3;  % Back EMF constant (V*s/rad)
Ktt = 78.48e-3; % Torque constant of the motor (N*m/A)
Js = 0.05116;  % Inertia of the satellite (kg*m^2)
Kt = Ke;
Jr=Js;
Jb=Js;
Jw=J;

% Define the path and file name as variables
path = '../Images/';  % Go one level up and into the 'Images' folder

% Attitude Equations
A = [0 1; 0 0];
B = [0; 1/Js];
C = [ 1 0; 0 1];
D = [0; 0];

% Check controllability
controllability = ctrb(A, B);
rank_controllability = rank(controllability);
% size(A,1)
if rank_controllability == size(A, 1)
    disp('The system is fully controllable.');
else
    disp('The system is NOT fully controllable.');
end

% Check observability
observability = obsv(A, C);
rank_observability = rank(observability);
if rank_observability == size(A, 1)
    disp('The system is fully observable.');
else
    disp('The system is NOT fully observable.');
end
% Pole Placement Satellite
sys = ss(A,B,C,D);

% Compute open-loop poles and checkthe step response of the open-loop
% system
pol = pole(sys);

figure(1)
step(sys)
grid on;
% leg = sprintf("Poles: %d, %d", pol(1), pol(2));
% legend(leg);
% title('Open-Loop Step Response.');

% Enhance the appearance of the plot
title('Open-Loop Step Response.', 'FontSize', 11, 'FontName', 'Times New Roman'); % Set title size
xlabel('Time (seconds)', 'FontSize', 11, 'FontName', 'Times New Roman'); % Set x-axis label size
grid on;  % Turn on the grid

% Access the axes handles and set custom labels with size adjustments
axesHandles = findall(gcf, 'Type', 'axes');

axesHandles(3).YLabel.String = {"Angle \phi (radians)", " "};
axesHandles(2).YLabel.String = "Angular Velocity \omega (rad/s)";
axesHandles(1).YLabel.String = "";
axesHandles(2).YLabel.FontSize = 11;
axesHandles(2).YLabel.FontSize = 11;
axesHandles(1).XLabel.String = "Time (seconds)";
axesHandles(1).XLabel.FontSize = 11;

% Optional: Additional customization
set(findall(gcf,'-property','FontSize'),'FontSize',11, 'FontName', 'Times New Roman'); % Adjust the font size for the entire figure
% set(findall(gcf,'-property','LineWidth'),'LineWidth',1); % Increase line thickness

% Display the computed poles in the console
disp('Open-loop system poles:');
disp(pol);

fileName = 'OpenOuterLoop.png';
% Save the figure using the path and file name variables
saveas(gcf, [path, fileName]);  % Save as PNG


% System is marginally stable, has adouble integrator behaivour will not stabilize
% any perturbation will make the output grow to infinite
% p=[-2, -1];
% p=[-4.9, -4.]
% p=[-4.89, -3.998];
p=[-3.998,-4.89];

% Find matrix K using pole plaement and check the closed-loop poles of
K = place(A,B,p);
Acl = A-B*K;
syscl = ss(Acl,B,C,D);
syscl = syscl(1);
Pcl = pole(syscl);
figure(2)
step(syscl)
% info=stepinfo(syscl);
% info(1)
% info(2)
hold on;
title('Step Response of Closed-Loop State Feedback Controller.', 'FontSize', 11); % Set title size
xlabel('Time (seconds)', 'FontSize', 11); % Set x-axis label size
grid on;  % Turn on the grid

% Leyends
legends = {};
leg = sprintf('Poles: %.2f, %.2f', p(1), p(2));
legends{end+1} = leg;
% legend(leg, 'FontSize', 11);

% Access the axes handles and set custom labels with size adjustments
% axesHandles = findall(gcf, 'Type', 'axes');
% axesHandles(3).YLabel.String = {"Angle \phi (radians)"};
% axesHandles(2).YLabel.String = "Angular Velocity \omega (rad/s)";
% axesHandles(1).YLabel.String = "";
% axesHandles(2).YLabel.FontSize = 11;
% axesHandles(2).YLabel.FontSize = 11;
% axesHandles(1).XLabel.String = "Time (seconds)";
% axesHandles(1).XLabel.FontSize = 11;
% Optional: Additional customization
set(findall(gcf,'-property','FontSize'),'FontSize',11, 'FontName', 'Times New Roman');

% Add an extra pole pair test
p=[-4, -3.5];
K = place(A,B,p);
Acl = A-B*K;
syscl = ss(Acl,B,C,D);
syscl = syscl(1);
step(syscl)
leg = sprintf('Poles: %.2f, %.2f', p(1), p(2));
legends{end+1} = leg;

% Another pole pair
p=[-5, -3];
K = place(A,B,p);
Acl = A-B*K;
syscl = ss(Acl,B,C,D);
syscl = syscl(1);
step(syscl)
leg = sprintf('Poles: %.2f, %.2f', p(1), p(2));
legends{end+1} = leg;

% More poles
p=[-5, -8];
K = place(A,B,p);
Acl = A-B*K;
syscl = ss(Acl,B,C,D);
syscl = syscl(1);
step(syscl)
leg = sprintf('Poles: %.2f, %.2f', p(1), p(2));
legends{end+1} = leg;
legend(legends, 'FontSize', 11);

fileName = 'ClosedOuterLoopPolesSelection.png';
% Save the figure using the path and file name variables
saveas(gcf, [path, fileName]);  % Save as PNG


figure;
pzmap(syscl);
grid on;

% Configurar tipo de letra y tamaño (Times New Roman, tamaño 11)
set(gca, 'FontSize', 11, 'FontName', 'Times New Roman');  % Cambiar el tamaño y tipo de letra

% Personalizar el título y etiquetas con Times New Roman y tamaño 11
title('Pole-Zero Map', 'FontSize', 11, 'FontWeight', 'bold', 'FontName', 'Times New Roman');  
xlabel('Real Axis', 'FontSize', 11, 'FontName', 'Times New Roman');  
ylabel('Imaginary Axis', 'FontSize', 11, 'FontName', 'Times New Roman');  

% Ajustar los límites del gráfico si es necesario
xlim([-6 0]);  % Ajustar el eje X para que se vea mejor (según tus polos)
ylim([-1 1]);

% Cambiar los colores y estilos de los polos y ceros
p = findobj(gca, 'Type', 'line');  % Buscar los objetos tipo 'line'
set(p, 'MarkerSize', 10, 'LineWidth', 1);  % Aumentar el tamaño de los polos/ceros y el grosor de las líneas
set(p, 'Color', 'b');  % Cambiar color a azul (puedes usar otros colores si prefieres)


fileName = 'PoleZeroMap_OuterLoop.png';
% Save the figure using the path and file name variables
saveas(gcf, [path, fileName]);  % Save as PNG


% % Nyquist
figure;
nyquist(syscl);
grid on;

% Define el frequency range in rad/s (logspace allow a logaritmic range)
w = logspace(-1, 2, 500);  % 10^-1 a 10^2 rad/s with 500 pts

% Generate Nyquist Diagram with adjusted freq. range
figure;
nyquist(syscl, w);
grid on;
title('Nyquist Diagram');

% Create the state-space system
sys_ss = ss(Acl, B, C, D);

% Convert state-space to transfer function
sys_tf = tf(sys_ss);

analyzeStepResponse(sys_tf);

savePath = path;
analyzeStateSpaceResponse(Acl,B,C,D, savePath);