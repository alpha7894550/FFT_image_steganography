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

