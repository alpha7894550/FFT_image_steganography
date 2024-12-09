clear all
% Read the stego image
stegoRgbImage = imread('stego_image_with_hidden_message.png'); % Load the saved stego image

% Convert the stego image to LAB color space
stegoLabImage = rgb2lab(stegoRgbImage);

% Extract the a* channel
decodedA = stegoLabImage(:,:,2);

% Apply 2D FFT to the a* channel
fftDecodedA = fft2(decodedA);
fftDecodedA_shifted = fftshift(fftDecodedA); % Center the zero-frequency component
magnitudeDecodedA = abs(fftDecodedA_shifted); % Compute the magnitude spectrum

% Required as key factors to open the message
% START
% Amplification factor (must match encoding process)
amplification = 1; % Same as used during encoding

% Define the embedding region size (must match encoding process)
embedSizeRows = round(size(magnitudeDecodedA, 1) / 8); % Embedding region height
embedSizeCols = round(size(magnitudeDecodedA, 2) / 8); % Embedding region width

% Define the dimensions of the original hidden message
originalRows = 100; % Height of the hidden message
originalCols = 300; % Width of the hidden message
% END

% Define the rectangular region for decoding (next to the center in the frequency domain)
centerRow = floor(size(magnitudeDecodedA, 1) / 2); % Middle row
centerCol = floor(size(magnitudeDecodedA, 2) / 2); % Middle column
startRow = centerRow - floor(embedSizeRows / 2); % Vertically aligned
startCol = centerCol + embedSizeCols; % Start next to the center horizontally

% Extract the same next-to-center region from the FFT spectrum
extractedRegion = magnitudeDecodedA(startRow:startRow + embedSizeRows - 1, ...
                                     startCol:startCol + embedSizeCols - 1);


% Amplify the extracted region to restore visibility
amplifiedRegion = extractedRegion * amplification;

% Resize the extracted region to the original hidden message dimensions
decodedMessage = imresize(amplifiedRegion, [originalRows, originalCols]);

% Normalize the decoded message for visualization
decodedMessage = rescale(decodedMessage, 0, 1); % Normalize to [0,1]

% Optionally, apply contrast enhancement
decodedMessage = imadjust(decodedMessage, stretchlim(decodedMessage), []);

% Apply thresholding if necessary
decodedMessage = imbinarize(decodedMessage, 0.3);

% Display the decoded hidden message
figure;
imshow(decodedMessage, []);
title('Decoded Hidden Message (Amplified)');

% Visualize the magnitude spectrum of the decoded a* channel
figure;
imagesc(log(1 + magnitudeDecodedA)); % Log scaling for better visualization
colormap jet; colorbar;
title('Magnitude Spectrum of Decoded a* Channel');
