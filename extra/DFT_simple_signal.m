% Parameters
N = 128; % Number of samples
x = linspace(0, 1, N); % Normalized time vector (0 to 1)
fs = 1 / (x(2) - x(1)); % Sampling frequency

% Signal definition
g = sin(10*pi*x) + cos(6*pi*x); % g(x) = sin(10*pi*x) + cos(6*pi*x)

% Compute DFT using FFT
G = fft(g); % Fast Fourier Transform
f = (0:N-1) * (fs / N); % Frequency vector

% Extract positive frequency components
G_magnitude = abs(G(1:N/2)); % Magnitude of FFT (positive frequencies only)
frequencies = f(1:N/2); % Positive frequency vector

% Save to CSV file
dft_results = [frequencies', G_magnitude']; % Combine frequency and magnitude
csvwrite('DFT_results.csv', dft_results); % Save as CSV file
disp('DFT results saved to "DFT_results.csv".');
