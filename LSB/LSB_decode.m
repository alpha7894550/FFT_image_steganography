% Clear the existing workspace
clear all;

% Clear the command window
clc;

% Read the stego image
stegoImage = imread('stegoImage.png');

%Key factor
% Define the number of bits to extract (length of the embedded message)
messageLength = 14; % 'deathstranding' has 14 characters
len = messageLength * 8; % Total bits in the message
%

% Initialize an empty array to store the extracted binary message
extractedBinMessage = zeros(len, 1);

% Get height and width for traversing through the image
height = size(stegoImage, 1);
width = size(stegoImage, 2);

% Counter for the number of extracted bits
extract_counter = 1;

% Traverse through the image to extract the LSBs
for i = 1 : height
    for j = 1 : width
        
        % If all bits have been extracted, stop
        if extract_counter > len
            break;
        end
        
        % Extract the Least Significant Bit (LSB) of the current pixel
        LSB = mod(double(stegoImage(i, j)), 2);
        
        % Store the LSB in the binary message array
        extractedBinMessage(extract_counter) = LSB;
        
        % Increment the counter
        extract_counter = extract_counter + 1;
    end
    
    % Break the outer loop if all bits have been extracted
    if extract_counter > len
        break;
    end
end

% Reshape the extracted binary message into a matrix of size 8x(messageLength)
extractedBinMatrix = reshape(extractedBinMessage, 8, [])';

% Convert the binary values to decimal (ASCII values)
ascii_values = bin2dec(num2str(extractedBinMatrix));

% Convert the ASCII values to characters to reconstruct the message
decodedMessage = char(ascii_values');

% Display the decoded message
disp('Decoded Message:');
disp(decodedMessage);
