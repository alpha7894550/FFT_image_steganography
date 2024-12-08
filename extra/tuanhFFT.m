% Step 1: Load Image
original_image = imread('C:\Users\Admin\Desktop\z3839424606964_65588983d67437623968773edd9b2cee.jpg');
grayscale_image = rgb2gray(original_image); % Ensure it's grayscale
grayscale_image = im2double(grayscale_image); % Normalize pixel values to [0, 1]

% Step 2: Transform the Image to the Frequency Domain
fft_image = fft2(grayscale_image); % 2D FFT
fft_shifted = fftshift(fft_image); % Shift zero-frequency component to the center

% Step 3: Convert the Message to Binary
message = 'Hello World'; % Example message
binary_message = reshape(dec2bin(message, 8).' - '0', 1, []); % Flatten binary array
message_length = length(binary_message);

% Step 4: Embed the Binary Message into High-Frequency Coefficients
% Select a region in the frequency domain (e.g., high frequencies)
[m, n] = size(fft_shifted);
rows_to_modify = m-50:m; % Example: Last 50 rows
cols_to_modify = n-50:n; % Example: Last 50 columns
freq_region = fft_shifted(rows_to_modify, cols_to_modify); % Extract high-frequency region

% Embed binary data by slightly modifying the magnitude
magnitude = abs(freq_region);
phase = angle(freq_region);
flat_magnitude = magnitude(:); % Flatten to 1D

% Check if the message length fits into the modifiable frequency region
if message_length > length(flat_magnitude)
    error('Message too long to embed in selected frequency region.');
end

% Embed binary message into the magnitude
% Make sure binary_message is a column vector with matching size
binary_message = binary_message(:); % Convert to column vector
flat_magnitude(1:message_length) = flat_magnitude(1:message_length) + binary_message * 0.001;


% Reconstruct the frequency region
modified_magnitude = reshape(flat_magnitude, size(magnitude));
modified_freq_region = modified_magnitude .* exp(1i * phase);

% Replace the modified region back into the FFT matrix
fft_shifted(rows_to_modify, cols_to_modify) = modified_freq_region;

% Step 5: Transform Back to the Spatial Domain
fft_unshifted = ifftshift(fft_shifted); % Reverse the shift
stego_image = real(ifft2(fft_unshifted)); % IFFT to spatial domain

% Step 6: Save and Display the Stego Image
imshow(stego_image, []);
title('Stego Image with Embedded Message');
imwrite(im2uint8(stego_image), 'C:\Users\Admin\Desktop\stego_image.png'); % Save as PNG
