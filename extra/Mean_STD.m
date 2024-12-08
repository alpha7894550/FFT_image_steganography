% Step 1: Load the Fault Data
%VS1_1_p54_shading66.csv
%VS_normal_condition.csv
%S1_10_p18_R.csv
fault_file = 'Data for testing/Test/VS1_1_p54_shading66.csv';
fault_data = readtable(fault_file);
fault_signal = fault_data{:, 1}; % Assuming voltage data is in the first column

% Step 2: Load the Training Data (Initial Mean and Std Dev)
normal_file = 'Data for testing/Test/Normal_data_for_MD_trained.csv';
normal_data = readtable(normal_file);
normal_signal_col1 = normal_data{:, 1}; % First column
normal_signal_col2 = normal_data{:, 2}; % Second column

% Initialize mean and standard deviation
trained_mean_col1 = mean(normal_signal_col1);
trained_std_col1 = std(normal_signal_col1);
trained_mean_col2 = mean(normal_signal_col2);
trained_std_col2 = std(normal_signal_col2);

% Parameters
window_size = 1000; % Update mean and std dev every 1000 samples
mean_threshold = 2; % Number of standard deviations allowed from the mean
num_samples = length(fault_signal); % Total number of samples

% Step 3: Initialize Variables
updated_mean_col1 = trained_mean_col1;
updated_std_col1 = trained_std_col1;
updated_mean_col2 = trained_mean_col2;
updated_std_col2 = trained_std_col2;

dynamic_faults_col1 = false(size(fault_signal)); % To store fault detection results
dynamic_faults_col2 = false(size(fault_signal));

% Step 4: Dynamic Fault Detection
for i = 1:window_size:num_samples
    % Define the current window
    end_idx = min(i + window_size - 1, num_samples);
    current_window = fault_signal(i:end_idx);
    
    % Detect faults using current mean and std dev
    dynamic_faults_col1(i:end_idx) = abs(current_window - updated_mean_col1) > (mean_threshold * updated_std_col1);
    dynamic_faults_col2(i:end_idx) = abs(current_window - updated_mean_col2) > (mean_threshold * updated_std_col2);
    
    % Update mean and std dev based on the current window
    updated_mean_col1 = mean(current_window);
    updated_std_col1 = std(current_window);
    
    % For demonstration, assume column 2 is same signal for now
    updated_mean_col2 = updated_mean_col1; 
    updated_std_col2 = updated_std_col1;
end

% Step 5: Combined Fault Detection (Any Column)
combined_faults = dynamic_faults_col1 | dynamic_faults_col2;

% Step 6: Visualization
figure;

% Plot the original fault signal
subplot(2, 1, 1);
plot(fault_signal, 'b-', 'LineWidth', 1.5);
title('Fault Signal');
xlabel('Sample Index');
ylabel('Voltage (V)');
grid on;

% Plot dynamic fault detection
subplot(2, 1, 2);
plot(fault_signal, 'b-', 'LineWidth', 1.5);
hold on;
plot(find(combined_faults), fault_signal(combined_faults), 'ro', 'MarkerSize', 6);
title('Dynamic Fault Detection (Mean & Standard Deviation)');
xlabel('Sample Index');
ylabel('Voltage (V)');
legend('Signal', 'Faults Detected');
grid on;

% Display Results
disp('Dynamic Fault Detection Results:');
disp(['Number of faults detected: ', num2str(sum(combined_faults))]);
