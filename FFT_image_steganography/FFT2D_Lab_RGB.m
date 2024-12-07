% Perform IFFT to reconstruct the modified a* channel
modifiedA = real(ifft2(ifftshift(modifiedFFT_A))); % Inverse FFT to get the spatial domain
modifiedA = rescale(modifiedA, min(a(:)), max(a(:))); % Normalize to original a* range

% Use the original b* channel (no modifications)
modifiedB = b; % Assuming no changes were made to the b* channel

% Combine L*, modified a*, and b* into the LAB color space
stegoLabImage = cat(3, L, modifiedA, modifiedB);

% Convert the LAB image back to RGB color space
stegoRgbImage = lab2rgb(stegoLabImage);

% Save the modified image
outputFileName = 'modified_image_with_hidden_message.png'; % Define the file name
imwrite(stegoRgbImage, outputFileName);

% Display confirmation
disp(['Modified image saved as: ', outputFileName]);

% Optionally, display the saved image
figure;
imshow(stegoRgbImage);
title('Stego Image with Hidden Message');
