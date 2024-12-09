% Step 1: Load the Fault Data
fault_file = 'Test/VS1_1_p54_shading66.csv';
fault_data = readtable(fault_file);
fault_signal = fault_data{:, 1}; % Assuming voltage data is in the first column

% Step 2: Load the Training Data (Initial Mean and Std Dev)
normal_file = 'Data for testing/Test/Normal_data_for_MD_trained.csv';
normal_data = readtable(normal_file);
normal_signal_col1 = normal_data{:, 1}; % First column
normal_signal_col2 = normal_data{:, 2}; % Second column

% Compute initial mean and standard deviation for normal data
trained_stats = struct( ...
    'mean_col1', mean(normal_signal_col1), ...
    'std_col1', std(normal_signal_col1), ...
    'mean_col2', mean(normal_signal_col2), ...
    'std_col2', std(normal_signal_col2) ...
);

% Parameters
window_size = 1000; % Update mean and std dev every 1000 samples
mean_threshold = 2; % Threshold in terms of standard deviations
num_samples = length(fault_signal); % Total number of samples

% Step 3: Initialize Dynamic Variables
updated_stats = trained_stats; % Initialize with trained values
dynamic_faults_col1 = false(num_samples, 1); % Fault detection results for column 1
dynamic_faults_col2 = false(num_samples, 1); % Fault detection results for column 2

% Step 4: Dynamic Fault Detection
for start_idx = 1:window_size:num_samples
    % Define the current window range
    end_idx = min(start_idx + window_size - 1, num_samples);
    current_window = fault_signal(start_idx:end_idx);
    
    % Column 1 Fault Detection
    dynamic_faults_col1(start_idx:end_idx) = ...
        abs(current_window - updated_stats.mean_col1) > (mean_threshold * updated_stats.std_col1);
    
    % Update mean and std dev dynamically for column 1
    updated_stats.mean_col1 = mean(current_window);
    updated_stats.std_col1 = std(current_window);
    
    % Note: Column 2 is treated similarly for demonstration (if signal available)
    % Dynamic calculation for column 2 can be added as needed
    updated_stats.mean_col2 = updated_stats.mean_col1; % Placeholder
    updated_stats.std_col2 = updated_stats.std_col1; % Placeholder
end

% Step 5: Combined Fault Detection (Across Columns)
combined_faults = dynamic_faults_col1; % Update if multiple columns are processed

% Step 6: Visualization
figure;

% Plot the original fault signal
subplot(2, 1, 1);
plot(fault_signal, 'b-', 'LineWidth', 1.5);
title('Fault Signal');
xlabel('Sample Index');
ylabel('Voltage (V)');
grid on;

% Display Results
disp('Dynamic Fault Detection Results:');
disp(['Number of faults detected: ', num2str(sum(combined_faults))]);
