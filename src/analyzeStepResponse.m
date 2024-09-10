function analyzeStepResponse(sys) %(num, den)
    % Function to analyze and plot step response metrics for a system
    % Input:
    %   num - Numerator coefficients of the transfer function
    %   den - Denominator coefficients of the transfer function

    % Create the transfer function
    % sys = tf(num, den);

    % Simulate the step response
    [response, time] = step(sys);

    % Analyze the step response
    info = stepinfo(sys);

    % Extract performance metrics
    riseTime = info.RiseTime;
    overshoot = info.Overshoot;
    peakValue = info.Peak;

    % Calculate the final value
    finalValue = response(end);

    % Calculate the 2% tolerance value
    tolerance = 0.02 * finalValue;

    % Determine settling time for 2% criterion
    withinTolerance = abs(response - finalValue) <= tolerance;
    settlingTimeIndex = find(withinTolerance, 1, 'first')
    time(end)
    if isempty(settlingTimeIndex)
        settlingTime2Percent = NaN;
    else
        settlingTime2Percent = time(settlingTimeIndex);
    end

    % Plot the step response
    figure;
    plot(time, response, 'b', 'LineWidth', 2);
    hold on;

    % Add grid and labels
    grid on;
    title('Step Response');
    xlabel('Time (s)');
    ylabel('Amplitude');

    % Annotate the plot with metrics
    text(0.1, 0.9, sprintf('Settling Time (2%%): %.2f s', settlingTime2Percent), 'Units', 'normalized', 'FontSize', 12, 'BackgroundColor', 'w');
    text(0.1, 0.85, sprintf('Rise Time: %.2f s', riseTime), 'Units', 'normalized', 'FontSize', 12, 'BackgroundColor', 'w');
    text(0.1, 0.8, sprintf('Overshoot: %.2f%%', overshoot), 'Units', 'normalized', 'FontSize', 12, 'BackgroundColor', 'w');
    text(0.1, 0.75, sprintf('Peak Value: %.2f', peakValue), 'Units', 'normalized', 'FontSize', 12, 'BackgroundColor', 'w');

    % Highlight the peak value
    [peakResponse, peakIndex] = max(response);
    plot(time(peakIndex), peakResponse, 'ro', 'MarkerSize', 8, 'LineWidth', 2);
    text(time(peakIndex), peakResponse, sprintf('Peak: %.2f', peakResponse), 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');

    % Highlight the settling region
    if ~isnan(settlingTime2Percent)
        settlingRegion = time >= (settlingTime2Percent - 0.1) & time <= (settlingTime2Percent + 0.1); % Adjust as needed
        fill([time(settlingRegion); flip(time(settlingRegion))], ...
             [response(settlingRegion); flip(response(settlingRegion))], 'yellow', 'FaceAlpha', 0.3, 'EdgeColor', 'none');

        % Add line to show settling time region
        yLimits = ylim;
        line([settlingTime2Percent, settlingTime2Percent], yLimits, 'Color', 'g', 'LineStyle', '--', 'LineWidth', 1.5);
        text(settlingTime2Percent, yLimits(2), sprintf('Settling Time (2%%): %.2f s', settlingTime2Percent), 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'left', 'Color', 'g');
    end

    hold off;
end

