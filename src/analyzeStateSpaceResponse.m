function analyzeStateSpaceResponse(A, B, C, D, savePath)
    % Function to convert state-space to transfer function and analyze step response
    % for angular velocity (omega) and torque (tau)
    % Input:
    %   A - State matrix
    %   B - Input matrix
    %   C - Output matrix
    %   D - Feedthrough matrix
    %   savePath - Path where the figures should be saved

    % Create the state-space system
    sys_ss = ss(A, B, C, D);

    % Simulate the step response
    [response, time] = step(sys_ss);

    % Analyze the step response for each output (omega and torque)
    numOutputs = size(C, 1);  % Number of outputs

    % Define labels for each output
    outputLabels = {'Angular Velocity (\omega)', 'Torque (\tau)'};
    
    % Define the filenames for saving the images
    fileNames = {'omega_response.png', 'tau_response.png'};
    
    for i = 1:numOutputs
        % Extract the response for the i-th output
        response_i = response(:, i);

        % Analyze the step response
        info = stepinfo(response_i, time);

        % Extract performance metrics
        riseTime = info.RiseTime;
        overshoot = info.Overshoot;
        peakValue = info.Peak;

        % Calculate the final value
        finalValue = response_i(end);

        % Calculate the 2% tolerance value
        tolerance = 0.02 * finalValue;

        % Determine settling time for 2% criterion
        withinTolerance = abs(response_i - finalValue) <= tolerance;
        settlingTimeIndex = find(withinTolerance, 1, 'first');
        if isempty(settlingTimeIndex) || settlingTimeIndex > length(time)
            settlingTime2Percent = NaN;
        else
            settlingTime2Percent = time(settlingTimeIndex);
        end

        % Create a new figure for each output
        figure;
        plot(time, response_i, 'b', 'LineWidth', 2);
        hold on;

        % Add grid and labels
        grid on;
        title(['Step Response - ' outputLabels{i}], 'FontName', 'Times New Roman', 'FontSize', 11, 'VerticalAlignment', 'bottom');
        xlabel('Time (s)', 'FontName', 'Times New Roman', 'FontSize', 11);
        ylabel('Amplitude', 'FontName', 'Times New Roman', 'FontSize', 11);

        % Adjust text box positions for clarity
        verticalOffset = 0.10;  % Increase spacing between text lines
        baseTextPosition = 0.64; % Lower starting position for text boxes

        % For Angular Velocity plot (move labels slightly down)
        if i == 1
            % Annotate the plot with metrics, adjusting the position for clarity
            text(0.6, baseTextPosition, sprintf('Rise Time: %.2f s', riseTime), ...
                'Units', 'normalized', 'FontSize', 11, 'FontName', 'Times New Roman', 'BackgroundColor', 'w');
            text(0.6, baseTextPosition - verticalOffset, sprintf('Overshoot: %.2f%%', overshoot), ...
                'Units', 'normalized', 'FontSize', 11, 'FontName', 'Times New Roman', 'BackgroundColor', 'w');

            % Highlight the peak value
            [peakResponse, peakIndex] = max(response_i);
            plot(time(peakIndex), peakResponse, 'ro', 'MarkerSize', 8, 'LineWidth', 2);
            % Place Peak label further down
            text(time(peakIndex), peakResponse - 0.08, sprintf('Peak: %.2f', peakResponse), ...
                'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right', 'FontSize', 11, 'FontName', 'Times New Roman');
            
            % Move the green Settling Time label a bit to the right and lower
            text(settlingTime2Percent + 0.1, finalValue - 0.18, sprintf('Settling Time (2%%): %.2f s', settlingTime2Percent), ...
                'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'left', 'Color', 'g', 'FontSize', 11, 'FontName', 'Times New Roman', 'BackgroundColor', 'w');
        
        % For Torque plot (move Settling Time label further left and higher)
        elseif i == 2
            % Remove Rise Time and Overshoot labels for torque
            % Highlight the peak value
            [peakResponse, peakIndex] = max(response_i);
            plot(time(peakIndex), peakResponse, 'ro', 'MarkerSize', 8, 'LineWidth', 2);
            % Place Peak label to the right of the red circle
            text(time(peakIndex) + 0.05, peakResponse, sprintf('Peak: %.2f', peakResponse), ...
                'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'left', 'FontSize', 11, 'FontName', 'Times New Roman');
            
            % Move the green Settling Time label much further to the left and a bit higher
            text(settlingTime2Percent - 1.15, finalValue + 0.3, sprintf('Settling Time (2%%): %.2f s', settlingTime2Percent), ...
                'VerticalAlignment', 'top', 'HorizontalAlignment', 'left', 'Color', 'g', 'FontSize', 11, 'FontName', 'Times New Roman');
        end

        % Highlight the settling region if valid
        if ~isnan(settlingTime2Percent)
            settlingRegion = time >= (settlingTime2Percent - 0.1) & time <= (settlingTime2Percent + 0.1); % Adjust as needed
            fill([time(settlingRegion); flip(time(settlingRegion))], ...
                 [response_i(settlingRegion); flip(response_i(settlingRegion))], 'yellow', 'FaceAlpha', 0.3, 'EdgeColor', 'none');

            % Add line to show settling time region
            yLimits = ylim;
            line([settlingTime2Percent, settlingTime2Percent], yLimits, 'Color', 'g', 'LineStyle', '--', 'LineWidth', 1.5);
        end

        hold off;

        % Save the figure to the specified path
        saveas(gcf, fullfile(savePath, fileNames{i}));
    end
end