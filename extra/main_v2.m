% Step 1: Load the CSV Files
voltagedata = readtable('Data for testing/VS_P18_R.csv'); % Voltage data file
currentdata = readtable('Data for testing/IS_P54_shading67.csv'); % Current data file

% Step 2: Extract Specified Columns
voltage_data = voltagedata{:, 1:20}; % Extract first 20 columns of voltage data
current_data = currentdata{:, 1:4};  % Extract first 4 columns of current data

% Step 3: Define Sampling and Filter Parameters
fs = 1000; % Sampling frequency in Hz
fc = 50; % Low-pass filter cutoff frequency in Hz
alpha = (1/fs) / ((1/fs) + (1/(2*pi*fc))); % Smoothing factor for low-pass filter

% Step 4: Apply Low-Pass Filter and FFT for Current Data
for col = 1:4
    signal = current_data(:, col); % Current data column
    N = length(signal); % Number of samples
    
    % Initialize Filtered Signal
    filtered_signal = zeros(size(signal));
    filtered_signal(1) = signal(1); % First value remains the same (no previous value)
    
    % Apply Recursive Low-Pass Filter
    for n = 2:N
        filtered_signal(n) = alpha * signal(n) + (1 - alpha) * filtered_signal(n-1);
    end
    
    % Compute FFT on Filtered Signal
    fft_result = fft(filtered_signal);
    frequencies = (0:N-1) * (fs / N); % Frequency vector
    magnitude = abs(fft_result) / N; % Normalize magnitude

    % Plot Frequency Spectrum
    figure;
    plot(frequencies(1:N/2), magnitude(1:N/2));
    title(['Frequency Spectrum for Filtered Current Data - Column ' num2str(col)]);
    xlabel('Frequency (Hz)');
    ylabel('Magnitude');
    grid on;
end
