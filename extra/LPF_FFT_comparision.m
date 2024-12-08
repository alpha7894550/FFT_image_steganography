% Step 1: Load Data from CSV Files
data1 = readtable('Data for testing/Test/VS1_1_p19_error.csv'); % Replace with your file name
data2 = readtable('Data for testing/Test/Normal_PV_pannel.csv'); % Replace with your file name

% Extract voltage data (assuming it's in the first column)
voltage1 = data1{:, 1}; % Shading, no fault
voltage2 = data2{:, 1}; % Fault, no shading

% Step 2: Define Sampling Information
fs = 1000; % Sampling frequency (Hz) - adjust as needed
fc = 50; % Low-pass filter cutoff frequency (Hz)
order = 4; % Filter order

% Step 3: Design the Low-Pass Filter
[b, a] = butter(order, fc/(fs/2), 'low'); % Butterworth low-pass filter

% Step 4: Apply the Filter to Each Dataset
filtered_voltage1 = filtfilt(b, a, voltage1); % Filtered shading, no fault
filtered_voltage2 = filtfilt(b, a, voltage2); % Filtered fault, no shading

% Step 5: Compute FFT for Each Filtered Signal
N1 = length(filtered_voltage1); % Number of samples in file 1
N2 = length(filtered_voltage2); % Number of samples in file 2

fft_result1 = fft(filtered_voltage1); % FFT for shading, no fault
fft_result2 = fft(filtered_voltage2); % FFT for fault, no shading

% Compute frequency vectors and normalize magnitudes
frequencies1 = (0:N1-1) * (fs / N1); % Frequency vector for file 1
frequencies2 = (0:N2-1) * (fs / N2); % Frequency vector for file 2
magnitude1 = abs(fft_result1) / N1; % Normalized magnitude for file 1
magnitude2 = abs(fft_result2) / N2; % Normalized magnitude for file 2

% Step 6: Plot Time-Domain Signals (Before and After Filtering)
figure;
subplot(2, 2, 1);
plot(voltage1, 'r');
title('Original Signal: Shading, No Fault');
xlabel('Sample Index');
ylabel('Voltage (V)');
grid on;

subplot(2, 2, 2);
plot(filtered_voltage1, 'b');
title('Filtered Signal: Shading, No Fault');
xlabel('Sample Index');
ylabel('Voltage (V)');
grid on;

subplot(2, 2, 3);
plot(voltage2, 'r');
title('Original Signal: Fault, No Shading');
xlabel('Sample Index');
ylabel('Voltage (V)');
grid on;

subplot(2, 2, 4);
plot(filtered_voltage2, 'b');
title('Filtered Signal: Fault, No Shading');
xlabel('Sample Index');
ylabel('Voltage (V)');
grid on;

% Step 7: Plot Frequency-Domain Comparison (After Filtering)
figure;
plot(frequencies1(1:N1/2), magnitude1(1:N1/2), 'r', 'LineWidth', 1.5);
hold on;
plot(frequencies2(1:N2/2), magnitude2(1:N2/2), 'b', 'LineWidth', 1.5);
title('Frequency Spectrum Comparison (After Filtering)');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
legend('Shading, No Fault', 'Fault, No Shading');
grid on;
