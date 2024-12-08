clear all
% Read an RGB image
rgbImage = imread('caycon.jpg');

% Convert the RGB image to L*a*b* color space
labImage = rgb2lab(rgbImage);

% Split into individual channels
L = labImage(:,:,1); % Luminance channel
a = labImage(:,:,2); % Chrominance a* channel
b = labImage(:,:,3); % Chrominance b* channel

% Display the channels
figure;
subplot(2,2,1), imshow(rgbImage), title('Original RGB Image');
subplot(2,2,2), imshow(L, []), title('L* (Luminance Channel)');
subplot(2,2,3), imshow(a, []), title('a* (Chrominance Channel)');
subplot(2,2,4), imshow(b, []), title('b* (Chrominance Channel)');

%plot channel a and b 

% Create meshgrid for image coordinates
[x, y] = meshgrid(1:size(a,2), 1:size(a,1));

% 3D surface plot for a* channel
figure;
subplot(1,2,1);
surf(x, y, a, 'EdgeColor', 'none');
colorbar;
title('3D Surface Plot of a* Channel');
xlabel('X');
ylabel('Y');
zlabel('a* Value');
view(3);

% 3D surface plot for b* channel
subplot(1,2,2);
surf(x, y, b, 'EdgeColor', 'none');
colorbar;
title('3D Surface Plot of b* Channel');
xlabel('X');
ylabel('Y');
zlabel('b* Value');
view(3);

% Apply 2D FFT to a* channel
fftA = fft2(a); % Compute FFT
fftA_shifted = fftshift(fftA); % Shift zero-frequency component to center
magnitudeA = abs(fftA_shifted); % Magnitude spectrum
phaseA = angle(fftA_shifted); % Phase spectrum

% Apply 2D FFT to b* channel
fftB = fft2(b); % Compute FFT
fftB_shifted = fftshift(fftB); % Shift zero-frequency component to center
magnitudeB = abs(fftB_shifted); % Magnitude spectrum
phaseB = angle(fftB_shifted); % Phase spectrum

% Visualize results for a* channel
figure;
subplot(2,2,1);
imshow(a, []);
title('a* Channel');

subplot(2,2,2);
imagesc(log(1 + magnitudeA)); % Log scaling for better visibility
colormap jet; colorbar;
title('Magnitude Spectrum of a*');

subplot(2,2,3);
imagesc(phaseA);
colormap jet; colorbar;
title('Phase Spectrum of a*');

% Visualize results for b* channel
figure;
subplot(2,2,1);
imshow(b, []);
title('b* Channel');

subplot(2,2,2);
imagesc(log(1 + magnitudeB)); % Log scaling for better visibility
colormap jet; colorbar;
title('Magnitude Spectrum of b*');

subplot(2,2,3);
imagesc(phaseB);
colormap jet; colorbar;
title('Phase Spectrum of b*');

% Normalize the magnitude for visualization (Log scaling for better contrast)
magnitudeA_log = log(1 + magnitudeA);
magnitudeB_log = log(1 + magnitudeB);

% Create meshgrid for plotting
[rowA, colA] = size(magnitudeA);
[Xa, Ya] = meshgrid(1:colA, 1:rowA);

[rowB, colB] = size(magnitudeB);
[Xb, Yb] = meshgrid(1:colB, 1:rowB);

% Plot 3D FFT magnitude spectrum for a* channel
figure;
surf(Xa, Ya, magnitudeA_log, 'EdgeColor', 'none'); % 3D surface plot
colormap jet; % Set colormap
colorbar; % Add color bar for reference
title('3D FFT Magnitude Spectrum of a* Channel');
xlabel('Frequency Component (X)');
ylabel('Frequency Component (Y)');
zlabel('Magnitude (Log Scale)');
view(3); % 3D view angle

% Plot 3D FFT magnitude spectrum for b* channel
figure;
surf(Xb, Yb, magnitudeB_log, 'EdgeColor', 'none'); % 3D surface plot
colormap jet; % Set colormap
colorbar; % Add color bar for reference
title('3D FFT Magnitude Spectrum of b* Channel');
xlabel('Frequency Component (X)');
ylabel('Frequency Component (Y)');
zlabel('Magnitude (Log Scale)');
view(3); % 3D view angle

% Create a grayscale image of the message
message = 'Death Stranding';
fontSize = 20; % Adjust font size
hiddenMessageImage = insertText(zeros(100, 300), [10, 40], message, ...
    'FontSize', fontSize, 'BoxOpacity', 0, 'TextColor', 'white');
hiddenMessageImage = rgb2gray(hiddenMessageImage); % Convert to grayscale
hiddenMessageImage = im2double(hiddenMessageImage); % Normalize to [0,1]

% Display the message image
figure;
imshow(hiddenMessageImage, []);
title('Hidden Message Image');

% Resize the hidden message to match the embedding region
[hiddenRows, hiddenCols] = size(hiddenMessageImage);
embedSizeRows = round(size(magnitudeA, 1) / 8); % Size of the rectangular region
embedSizeCols = round(size(magnitudeA, 2) / 8);
hiddenMessageResized = imresize(hiddenMessageImage, [embedSizeRows, embedSizeCols]);

% Amplification factor
amplification = 8; % Increase embedding strength (adjust as needed)

% Normalize and scale the hidden message to the FFT range
maxMagnitude = max(magnitudeA(:));
hiddenMessageResized = hiddenMessageResized * maxMagnitude / amplification;

% Define the rectangular embedding region next to the center
centerRow = floor(size(magnitudeA, 1) / 2); % Middle row
centerCol = floor(size(magnitudeA, 2) / 2); % Middle column
startRow = centerRow - floor(embedSizeRows / 2); % Vertically aligned
startCol = centerCol + embedSizeCols; % Start next to the center horizontally

% Embed the hidden message into the next-to-center region
for i = 1:embedSizeRows
    for j = 1:embedSizeCols
        magnitudeA(startRow + i - 1, startCol + j - 1) = ...
            magnitudeA(startRow + i - 1, startCol + j - 1) + hiddenMessageResized(i, j);
    end
end

% Visualize the modified magnitude spectrum
figure;
imagesc(log(1 + abs(magnitudeA))); % Log scaling for better visualization
colormap jet;
colorbar;
title('Modified Magnitude Spectrum with Hidden Message on Right of Center');

% Combine the modified magnitude spectrum with the original phase spectrum
modifiedFFT_A = magnitudeA .* exp(1i * phaseA);

% Perform IFFT to reconstruct the modified a* channel
modifiedA = real(ifft2(ifftshift(modifiedFFT_A))); % Apply inverse FFT
modifiedA = rescale(modifiedA, min(a(:)), max(a(:))); % Normalize back to original a* range

% Use the original b* channel (unchanged)
modifiedB = b;

% Combine the original L* channel with the modified a* and original b* channels
stegoLabImage = cat(3, L, modifiedA, modifiedB);

% Convert the modified LAB image back to RGB
stegoRgbImage = lab2rgb(stegoLabImage);

% Save the modified image
outputFileName = 'stego_image_with_hidden_message.png'; % Define the output file name
imwrite(stegoRgbImage, outputFileName);

% Display confirmation
disp(['Modified image saved as: ', outputFileName]);

% Optionally, display the saved image
figure;
imshow(stegoRgbImage);
title('Stego Image with Hidden Message');
