% Step 1: Load Data from CSV Files
% Replace 'shading_no_fault.csv' and 'fault_no_shading.csv' with your file names
data1 = readtable('Data for testing/VS1_1_p54_shading66.csv');%shading no fault
data2 = readtable('Data for testing/S1_10_p18_R.csv');%no shading fault

% Extract voltage data (assuming it's in the first column)
voltage1 = data1{:, 1}; % Shading, no fault
voltage2 = data2{:, 1}; % Fault, no shading

% Step 2: Define Sampling Information
fs = 1000; % Sampling frequency (Hz) - adjust based on your setup
N1 = length(voltage1); % Number of samples in file 1
N2 = length(voltage2); % Number of samples in file 2

% Frequency vectors for each dataset
frequencies1 = (0:N1-1) * (fs / N1);
frequencies2 = (0:N2-1) * (fs / N2);

% Step 3: Compute FFT for Each Dataset
fft_result1 = fft(voltage1); % FFT for shading, no fault
fft_result2 = fft(voltage2); % FFT for fault, no shading

% Compute magnitude (normalized)
magnitude1 = abs(fft_result1) / N1;
magnitude2 = abs(fft_result2) / N2;

% Step 4: Plot Time-Domain Signals
figure;
subplot(2, 1, 1);
plot(voltage1, 'r');
title('Time-Domain Signal: Shading, No Fault');
xlabel('Sample Index');
ylabel('Voltage (V)');
grid on;

subplot(2, 1, 2);
plot(voltage2, 'b');
title('Time-Domain Signal: Fault, No Shading');
xlabel('Sample Index');
ylabel('Voltage (V)');
grid on;

% Step 5: Plot Frequency-Domain Comparison
figure;
plot(frequencies1(1:N1/2), magnitude1(1:N1/2), 'r', 'LineWidth', 1.5);
hold on;
plot(frequencies2(1:N2/2), magnitude2(1:N2/2), 'b', 'LineWidth', 1.5);
title('Frequency Spectrum Comparison');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
legend('Shading, No Fault', 'Fault, No Shading');
grid on;
