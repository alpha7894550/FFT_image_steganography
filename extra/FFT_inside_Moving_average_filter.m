% Step 1: Load Data from CSV
%VS1_1_p54_shading66.csv
%VS_normal_condition.csv
%S1_10_p18_R.csv
filename = 'Data for testing/Test/VS1_1_p54_shading66.csv'; % Replace with your CSV file name
data = readtable(filename);
signal = data{:, 1}; % Assuming the signal is in the first column

% Step 2: Define Sampling Parameters and Moving Average Window
fs = 100; % Sampling frequency in Hz (adjust based on your data)
window_size = 50; % Window size for the moving average

% Step 3: Apply Moving Average Filter
smoothed_signal = movmean(signal, window_size);

% Step 4: Compute FFT of the Smoothed Signal
N = length(smoothed_signal); % Number of samples
fft_result = fft(smoothed_signal); % Compute FFT

frequencies = (0:(N/2)-1) * (fs / N); % Frequency axis (positive frequencies)
magnitude = abs(fft_result(1:N/2)) / N; % Magnitude spectrum (normalized)

% Step 5: Plot the Original and Smoothed Signals
figure;
subplot(2,1,1); % Top plot for time-domain signals
plot(signal, 'b-', 'LineWidth', 1.5); % Original signal
hold on;
plot(smoothed_signal, 'r-', 'LineWidth', 2); % Smoothed signal
title('Original Signal vs. Smoothed Signal');
xlabel('Sample Index');
ylabel('Amplitude');
legend('Original Signal', 'Smoothed Signal');
grid on;

% Step 6: Plot the Frequency Spectrum of the Smoothed Signal
subplot(2,1,2); % Bottom plot for FFT
plot(frequencies, magnitude, 'LineWidth', 1.5);
title('Frequency Spectrum of Smoothed Signal');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
grid on;
