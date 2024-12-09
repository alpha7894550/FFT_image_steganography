% Define the parameters
fs = 50; % Sampling rate (samples per second)
T = 8; % Duration of the signal (seconds)
N = fs * T; % Total number of samples
t = linspace(0, T, N); % Time vector

% Define the signal
signal = 5 + 2 * cos(2 * pi * t - pi/2) + 3 * cos(4 * pi * t); % Signal definition

% Perform the DFT using FFT
G = fft(signal); % Fast Fourier Transform
frequencies = (0:N-1) * (fs / N); % Frequency vector

% Extract positive frequencies
half_N = floor(N / 2) + 1; % Number of positive frequencies
positive_frequencies = frequencies(1:half_N);
magnitude = abs(G(1:half_N)) / N; % Normalize the magnitude

% Plot the time-domain signal
figure;
subplot(2, 1, 1);
plot(t, signal, 'b', 'LineWidth', 1.5);
title('Time-Domain Signal');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;

% Plot the frequency-domain magnitude spectrum
subplot(2, 1, 2);
stem(positive_frequencies, magnitude, 'r', 'LineWidth', 1.5, 'MarkerFaceColor', 'r');
title('Frequency-Domain Spectrum');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
grid on;
