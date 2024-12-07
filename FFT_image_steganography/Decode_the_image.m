% Read the stego image
stegoRgbImage = imread('stego_image_with_hidden_message.png'); % Load saved stego image

% Convert to LAB and extract the a* channel
stegoLabImage = rgb2lab(stegoRgbImage);
decodedA = stegoLabImage(:,:,2);

% Apply 2D FFT to the a* channel
fftDecodedA = fft2(decodedA);
fftDecodedA_shifted = fftshift(fftDecodedA);
magnitudeDecodedA = abs(fftDecodedA_shifted); % Magnitude spectrum

% Visualize the decoded magnitude spectrum
figure;
imagesc(log(1 + magnitudeDecodedA)); % Log scaling for better visualization
colormap jet; colorbar;
title('Decoded Magnitude Spectrum');

% Extract the hidden message region
embedSizeRows = round(size(magnitudeDecodedA, 1) / 8);
embedSizeCols = round(size(magnitudeDecodedA, 2) / 8);
startRow = 1;
startCol = size(magnitudeDecodedA, 2) - embedSizeCols + 1;

extractedRegion = magnitudeDecodedA(startRow:startRow + embedSizeRows - 1, ...
                                     startCol:startCol + embedSizeCols - 1);

% Visualize the extracted region
figure;
imagesc(log(1 + extractedRegion));
colormap jet; colorbar;
title('Extracted Region from Magnitude Spectrum');
