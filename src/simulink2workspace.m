% Extract data from the workspace
time = out.simout.time;  % Time vector
output = out.simout.Data;  % System output
% Get step response information
info = stepinfo(output, time);

% Display the results
disp(['Settling Time: ', num2str(info.SettlingTime), ' s']);
disp(['Overshoot: ', num2str(info.Overshoot), ' %']);
disp(['Peak: ', num2str(info.Peak), ' units']);
disp(['Peak Time: ', num2str(info.PeakTime), ' s']);

% Suppose you already have the simulation data in 'time' and 'output' variables

% Plot the system response
figure;
plot(time, output, 'b', 'LineWidth', 1.5);
hold on;

% Mark the peak value
plot(info.PeakTime, info.Peak, 'ro', 'MarkerSize', 10);

% Mark the Settling Time
plot([info.SettlingTime, info.SettlingTime], [0, 250], '--', 'Color', [0 0.5 0], 'LineWidth', 1);  % Darker green
h2 = plot([0, 10], [170, 170], '-', 'Color', [1 .8 0], 'LineWidth', 1);  % Dark yellow
uistack(h2, 'bottom');

% Add text to the plot
% Peak label: Move further down and to the left
text(info.PeakTime - 2.8, info.Peak, ['Peak: ', num2str(info.Peak), '\rightarrow'], 'HorizontalAlignment', 'left');

% Settling Time label: Darker green and move up
text(info.SettlingTime + .7, 0.38*info.Peak, ['Settling Time: ', num2str(info.SettlingTime), ' s'], 'Color', [0 0.5 0]);

% Adjust text box positions for clarity
verticalOffset = 0.10;  % Increase spacing between text lines
baseTextPosition = 0.55; % Lower starting position for text boxes
% Annotate the plot with metrics, adjusting the position for clarity
text(0.62, baseTextPosition, sprintf('Rise Time: %.2f s', info.RiseTime), ...
    'Units', 'normalized', 'FontSize', 11, 'FontName', 'Times New Roman', 'BackgroundColor', 'w');
text(0.62, baseTextPosition - verticalOffset, sprintf('Overshoot: %.2f%%', info.Overshoot), ...
    'Units', 'normalized', 'FontSize', 11, 'FontName', 'Times New Roman', 'BackgroundColor', 'w');

% Titles and axes
title('System Step Response of amplitude 170 degrees.');
xlabel('Time (seconds)');
ylabel('ϕ (degrees)');
grid on;

% Define the path and file name as variables
path = '../Images/';  % Go one level up and into the 'Imagenes' folder
fileName = 'CompleteControlOldPolesStep170.png';
% Save the figure using the path and file name variables
saveas(gcf, [path, fileName]);  % Save as PNG
