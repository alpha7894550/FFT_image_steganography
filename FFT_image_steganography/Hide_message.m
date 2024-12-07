% Create a grayscale image of the message
message = 'Death Standing';
fontSize = 20; % Adjust font size
hiddenMessageImage = insertText(zeros(100, 300), [10, 40], message, ...
    'FontSize', fontSize, 'BoxOpacity', 0, 'TextColor', 'white');
hiddenMessageImage = rgb2gray(hiddenMessageImage); % Convert to grayscale
hiddenMessageImage = im2double(hiddenMessageImage); % Normalize to [0,1]

% Display the message image
figure;
imshow(hiddenMessageImage, []);
title('Hidden Message Image');

% Resize the hidden message to a smaller size for embedding
[hiddenRows, hiddenCols] = size(hiddenMessageImage);
embedSizeRows = round(size(magnitudeA, 1) / 8); % Size of the rectangular region
embedSizeCols = round(size(magnitudeA, 2) / 8);
hiddenMessageResized = imresize(hiddenMessageImage, [embedSizeRows, embedSizeCols]);

% Define the rectangular embedding region (top-right in high-frequency)
startRow = 1; % Start embedding at the top rows
startCol = size(magnitudeA, 2) - embedSizeCols + 1; % Top-right corner

% Embed the hidden message in the defined rectangular region
for i = 1:embedSizeRows
    for j = 1:embedSizeCols
        magnitudeA(startRow + i - 1, startCol + j - 1) = hiddenMessageResized(i, j);
    end
end

% Visualize the modified magnitude spectrum
figure;
imagesc(log(1 + abs(magnitudeA))); % Log scaling for better visualization
colormap jet;
colorbar;
title('Modified Magnitude Spectrum with Hidden Message');
