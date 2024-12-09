% Define the original continuous signal
fs_original = 1000; % High sampling rate for the original signal
T = 8; % Duration (seconds)
t_original = linspace(0, T, fs_original); % Time points for original signal
signal_original = 5 + 2 * cos(2 * pi * t_original - pi/2) + 3 * cos(4 * pi * t_original); % Original signal

% Define the sampled signal
fs_sampled = 100; % Sampling rate (samples per second)
t_sampled = linspace(0, T, fs_sampled); % Sampled time points
signal_sampled = 5 + 2 * cos(2 * pi * t_sampled - pi/2) + 3 * cos(4 * pi * t_sampled); % Sampled signal

% Define the finer time vector for interpolation
fs_interp = 100; % Desired sampling rate for interpolation
t_interp = linspace(0, T, fs_interp); % Time points for interpolation

% Perform linear interpolation
signal_interp = interp1(t_sampled, signal_sampled, t_interp, 'linear');

% Perform spline interpolation (for smoother results)
signal_spline = interp1(t_sampled, signal_sampled, t_interp, 'spline');

% Plot the results
figure;

% Plot original continuous signal
subplot(3, 1, 1);
plot(t_original, signal_original, 'k-', 'LineWidth', 1.5);
hold on;
stem(t_sampled, signal_sampled, 'b', 'LineWidth', 1.5, 'MarkerFaceColor', 'b');
title('Original Continuous Signal and Sampled Points');
xlabel('Time (s)');
ylabel('Amplitude');
legend('Original Signal', 'Sampled Points');
grid on;

% Plot linear interpolation
subplot(3, 1, 2);
plot(t_interp, signal_interp, 'r-', 'LineWidth', 1.5);
hold on;
stem(t_sampled, signal_sampled, 'b', 'LineWidth', 1.5, 'MarkerFaceColor', 'b');
title('Linear Interpolation');
xlabel('Time (s)');
ylabel('Amplitude');
legend('Interpolated Signal', 'Sampled Points');
grid on;

% Plot spline interpolation
subplot(3, 1, 3);
plot(t_interp, signal_spline, 'g-', 'LineWidth', 1.5);
hold on;
stem(t_sampled, signal_sampled, 'b', 'LineWidth', 1.5, 'MarkerFaceColor', 'b');
title('Spline Interpolation');
xlabel('Time (s)');
ylabel('Amplitude');
legend('Spline Interpolation', 'Sampled Points');
grid on;
