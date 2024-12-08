% Step 1: Load the Data
%VS1_1_p54_shading66.csv
%VS_normal_condition.csv
%S1_10_p18_R.csv
% Fault detection test data
fault_file = 'Data for testing/Test/VS1_1_p54_shading66.csv';
fault_data = readtable(fault_file);
fault_signal = fault_data{:, 1}; % Assume voltage data is in the first column

% Step 2: Define Sampling Rate and Time Axis
fs = 100; % Sampling frequency in Hz
num_samples = length(fault_signal); % Total number of samples
time_axis = (0:num_samples-1) / fs; % Time in seconds

% Step 3: Define Threshold Parameters
threshold_low = 30; % Low voltage threshold
threshold_high = 50; % High voltage threshold

% Step 4: Fault Detection using Threshold Method
threshold_faults = (fault_signal < threshold_low) | (fault_signal > threshold_high);

% Step 5: Visualize Results
figure;

% Plot original fault signal with thresholds
subplot(2, 1, 1);
plot(time_axis, fault_signal, 'b-', 'LineWidth', 1.5); % Use time_axis for x-axis
hold on;
yline(threshold_low, 'r--', 'LineWidth', 1.2, 'Label', 'Low Threshold');
yline(threshold_high, 'r--', 'LineWidth', 1.2, 'Label', 'High Threshold');
title('Fault Signal with Thresholds');
xlabel('Time (seconds)');
ylabel('Voltage (V)');
grid on;

% Plot threshold-based fault detection
subplot(2, 1, 2);
plot(time_axis, fault_signal, 'b-', 'LineWidth', 1.5); % Use time_axis for x-axis
hold on;
plot(time_axis(threshold_faults), fault_signal(threshold_faults), 'ro', 'MarkerSize', 6);
title('Fault Detection: Threshold Method');
xlabel('Time (seconds)');
ylabel('Voltage (V)');
legend('Signal', 'Faults Detected');
grid on;
