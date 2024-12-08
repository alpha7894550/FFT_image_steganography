% Step 1: Load the CSV File
data = readtable('Data for testing/Test/Normal_PV_pannel.csv'); % Replace with your file name
signal = data{:, 1}; % Extract the signal column (assume first column is signal)
fs = 1000; % Sampling frequency (adjust based on your data)
N = length(signal); % Number of samples
t = (0:N-1) / fs; % Time vector based on sampling frequency

% Plot the Original Signal
figure;
subplot(3, 1, 1);
plot(t, signal, 'r');
title('Original Signal');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;

% Step 2: Apply the Multiple-Pass Moving Average Filter
window_size = 21; % Moving average window size
num_passes = 3; % Number of passes for the moving average filter
filtered_signal = signal; % Initialize filtered signal

for pass = 1:num_passes
    kernel = ones(1, window_size) / window_size; % Rectangular kernel
    filtered_signal = conv(filtered_signal, kernel, 'same'); % Moving average filter
end

% Plot the Filtered Signal
subplot(3, 1, 2);
plot(t, filtered_signal, 'b');
title(['Filtered Signal After ' num2str(num_passes) ' Passes']);
xlabel('Time (s)');
ylabel('Amplitude');
grid on;

% Step 3: Frequency Analysis (FFT)
frequencies = (0:N-1) * (fs / N); % Frequency vector

% FFT of Original Signal
fft_original = fft(signal);
magnitude_original = abs(fft_original) / N;

% FFT of Filtered Signal
fft_filtered = fft(filtered_signal);
magnitude_filtered = abs(fft_filtered) / N;

% Plot Frequency Spectrum
subplot(3, 1, 3);
plot(frequencies(1:N/2), magnitude_original(1:N/2), 'r', 'DisplayName', 'Original Signal');
hold on;
plot(frequencies(1:N/2), magnitude_filtered(1:N/2), 'b', 'DisplayName', 'Filtered Signal');
title('Frequency Spectrum');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
legend;
grid on;
