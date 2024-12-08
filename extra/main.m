% Step 1: Load the CSV File
voltagedata = readtable('Data for testing/VS_P18_R.csv'); % Replace with the voltage file
currentdata = readtable('Data for testing/IS_P18_R.csv');% replace with the current file
% Step 2: Extract 20 Columns
% Assuming the first 20 columns are the ones you want to extract
voltage_data = voltagedata{:, 1:20}; % Extract data from columns 1 to 20
current_data = currentdata{:, 1:4}; % Extract data from columns 1 to 4

fs = 1000; % Sampling frequency
for col = 1:4
    signal = current_data(:, col); % Extract column
    N = length(signal); % Number of samples
    fft_result = fft(signal);
    frequencies = (0:N-1) * (fs / N);
    magnitude = abs(fft_result) / N;

    % Plot Frequency Spectrum
    figure;
    plot(frequencies(1:N/2), magnitude(1:N/2));
    title(['Frequency Spectrum for Column ' num2str(col)]);
    xlabel('Frequency (Hz)');
    ylabel('Magnitude');
    grid on;
end
