close all;
clear;

D = 'Landscapes/classroom'; % directory where the files are saved
S = dir(fullfile(D, '*.jpg')); % pattern to match filenames
N = numel(S); % number of images (frames)
k = 5;

for f = 1:N
    % Read image, convert to grayscale
    F = fullfile(D, S(f).name);
    Img = imread(F);
    I = double(Img);
    S(f).image = I;
    %figure, imshow(I);
    
    % Perform k-means clustering
    clustered = reshape(kmeans(I(:), 5), size(I));
    S(f).clustered = clustered; % cluster indeces
end

% Determine mode cluster for each pixel
[m,n] = size(S(1).image);
modes = zeros(m,n);
for i = 1:m
    for j = 1:n
        acc = zeros(k, 1);
        for f = 1:N
            acc(S(f).clustered(i,j)) = acc(S(f).clustered(i,j)) + 1;
        end
        [maxVal, maxIdx] = max(acc);
        modes(i,j) = maxIdx;
    end
end

% Find median pixel intensity from frames with mode cluster
estimated = zeros(m,n);
for i = 1:m
    for j = 1:n
        intensities = zeros(N, 1);
        for f = 1:N
            if S(f).clustered(i,j) == modes(i,j)
               intensities(f) = S(f).image(i,j);
            end
        end
        
        estimated(i,j) = median(intensities(intensities ~=0));
    end
end

figure, imshow(uint8(estimated), 'InitialMagnification', 300);
