% Input Signal
x = [1, 2, 3, 4, 5, 6, 7, 8];

% Step 1: Compute FFT
X = fft(x); % Use MATLAB's built-in FFT function
N = length(x); % Number of points

% Step 2: Frequency Axis
f = (0:N-1); % Frequency index

% Plotting
figure;

% Time Domain Signal
subplot(3,1,1);
stem(0:N-1, x, 'filled');
title('Time Domain Signal');
xlabel('Sample Index');
ylabel('Amplitude');
grid on;

% Magnitude Spectrum
subplot(3,1,2);
stem(f, abs(X), 'filled');
title('Magnitude Spectrum');
xlabel('Frequency Index');
ylabel('Magnitude');
grid on;

% Phase Spectrum
subplot(3,1,3);
stem(f, angle(X), 'filled');
title('Phase Spectrum');
xlabel('Frequency Index');
ylabel('Phase (radians)');
grid on;
