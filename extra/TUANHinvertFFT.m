% Step 1: Load the Image
img = imread('C:\Users\Admin\Desktop\z3839424606964_65588983d67437623968773edd9b2cee.jpg');
img_gray = rgb2gray(img); % Convert to grayscale if it's a color image

% Step 2: Compute the 2D Fourier Transform
F = fft2(img_gray); % Compute the Fourier Transform
F_mag = abs(F);     % Magnitude
F_phase = angle(F); % Phase

% Step 3: Apply Log Scaling
F_mag_log = log(1 + F_mag); % Log scale to visualize magnitude

% Step 4: Center the Low Frequencies
F_mag_shifted = fftshift(F_mag_log); % Center the magnitude spectrum
F_phase_shifted = fftshift(F_phase); % Center the phase spectrum

% Step 5: Display the Magnitude Spectrum
figure;
imagesc(F_mag_shifted); % Display the magnitude spectrum
colormap('jet');        % Use a colormap
colorbar;               % Add a colorbar
title('Magnitude Spectrum of Fourier Transform');

% Step 6: Display the Phase Spectrum
figure;
imagesc(F_phase_shifted); % Display the phase spectrum
colormap('jet');
colorbar;
title('Phase Spectrum of Fourier Transform');


% Step 2: Select Harmonics and Embed Message
message = 'Secret';
binaryMessage = reshape(dec2bin(message, 8).'-'0', 1, []); % Convert to binary
F_embedded = F;
for i = 1:length(binaryMessage)
    F_embedded(i+10, i+10) = F(i+10, i+10) + 0.01 * binaryMessage(i); % Modify harmonics
end

%display the F_embedded

% Step 1: Compute the magnitude of the modified Fourier transform
F_embedded_mag = abs(F_embedded);

% Step 2: Apply log scaling for better visualization
F_embedded_log = log(1 + F_embedded_mag); % Log-scaled magnitude

% Step 3: Display the frequency spectrum
figure;
imagesc(F_embedded_log); % Log-scaled magnitude
colormap('jet'); % Color map for visualization
colorbar; % Add color bar
title('Modified Frequency Spectrum (F\_embedded)');

% Step 4: Display centered frequency spectrum
F_embedded_shifted = fftshift(F_embedded_log); % Shift zero-frequency to center
figure;
imagesc(F_embedded_shifted);
colormap('jet');
colorbar;
title('Centered Modified Frequency Spectrum (F\_embedded)');



% Step 3: Transform Back to Spatial Domain
stego_img = real(ifft2(F_embedded));
imshow(uint8(stego_img));

% Step 4: Decode the Message
F_extracted = fft2(stego_img);
decoded_bits = round((F_extracted(11:10+length(binaryMessage), 11:10+length(binaryMessage)) - F(11:10+length(binaryMessage), 11:10+length(binaryMessage))) / 0.01);
decoded_message = char(bin2dec(reshape(char(decoded_bits + '0'), 8, []).')).';
disp(message);
disp(binaryMessage);
