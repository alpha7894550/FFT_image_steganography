% Clear the workspace and command window
clear all;
clc;

% Load the signal from a CSV file
% Ensure the CSV file has a single column with signal values
filename = 'signal.csv'; % Replace with your CSV file name
signal = csvread(filename);

% Define sampling frequency and signal properties
Fs = 100; % Sampling frequency in Hz (modify as per your signal)
T = 1 / Fs; % Sampling period
L = length(signal); % Length of the signal
t = (0:L-1) * T; % Time vector

% Plot the signal
figure;
plot(t, signal);
title('Input Signal in Time Domain');
xlabel('Time (s)');
ylabel('Amplitude (V)');

% Frequency domain analysis
% Perform FFT
Y = fft(signal);
P2 = abs(Y / L); % Two-sided amplitude spectrum
P1 = P2(1:L/2+1); % Single-sided spectrum
P1(2:end-1) = 2 * P1(2:end-1);
f = Fs * (0:(L/2)) / L; % Frequency vector

% Plot FFT
figure;
plot(f, P1);
title('Frequency Domain Analysis (FFT)');
xlabel('Frequency (Hz)');
ylabel('Amplitude |P1(f)|');

% Check for faults in the frequency domain
faultIndices = f > 2; % Frequencies greater than 2 Hz
faultMagnitudes = P1(faultIndices); % Magnitudes at fault frequencies

% Define a threshold for significant noise
faultThreshold = 0.1 * max(P1); % 10% of max magnitude
if any(faultMagnitudes > faultThreshold)
    disp('Fault Detected: Significant Noise Above 2 Hz in Frequency Domain');
else
    disp('No Fault Detected in Frequency Domain');
end

% Extract the noise in the frequency domain (frequencies > 2 Hz)
[b, a] = butter(4, [2, Fs/2-1] / (Fs/2), 'bandpass'); % Bandpass filter
faultSignal = filter(b, a, signal);

% Plot the reconstructed fault signal in time domain
figure;
plot(t, faultSignal);
title('Fault Signal Isolated in Time Domain');
xlabel('Time (s)');
ylabel('Amplitude (V)');

% Check for faults in the time domain
voltageLowerLimit = 30; % Lower voltage range
voltageUpperLimit = 50; % Upper voltage range
outOfRangeIndices = (signal < voltageLowerLimit) | (signal > voltageUpperLimit);

if any(outOfRangeIndices)
    disp('Fault Detected: Voltage Out of Range in Time Domain');
else
    disp('No Voltage Fault Detected in Time Domain');
end

% Plot the time-domain signal with fault regions highlighted
figure;
plot(t, signal, 'b'); hold on;
plot(t(outOfRangeIndices), signal(outOfRangeIndices), 'ro');
title('Signal with Voltage Faults Highlighted');
xlabel('Time (s)');
ylabel('Amplitude (V)');
legend('Signal', 'Faults');
