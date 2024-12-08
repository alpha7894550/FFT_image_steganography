% Step 1: Load the CSV File 
%VS1_1_p54_shading66.csv
%VS_normal_condition.csv
%S1_10_p18_R.csv
data = readtable('Data for testing/Test/S1_10_p18_R.csv'); % Replace with your CSV file name
voltage = data{:, 1}; % Extract voltage column (assumed to be the first column)

% Step 2: Sampling Information
fs = 100; % Sampling frequency in Hz (adjust based on your setup)
N = length(voltage); % Number of samples
T = N / fs; % Total duration of the signal
time = linspace(0, T, N); % Create time vector for plotting

% Step 3: Compute FFT
fft_result = fft(voltage); % Compute FFT of the voltage signal
frequencies = (0:N-1) * (fs / N); % Frequency vector
magnitude = abs(fft_result) / N; % Normalize FFT magnitude

% Step 4: Plot Frequency Spectrum
figure;
plot(frequencies(1:N/2), magnitude(1:N/2)); % Plot positive frequencies
title('Frequency Spectrum of Voltage Signal');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
grid on;

% Step 5: Optional - Plot Original Signal
figure;
plot(time, voltage, 'r');
title('Original Voltage Signal');
xlabel('Time (s)');
ylabel('Voltage (V)');
grid on;
