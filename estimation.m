close all;
clear;

D = 'images'; % directory where the files are saved
S = dir(fullfile(D, 'simple_test_*.jpeg')); % pattern to match filenames
N = numel(S); % number of images (frames)
k = 5;

for f = 1:N
    % Read image, convert to grayscale
    F = fullfile(D, S(f).name);
    Img = imread(F);
    I = double(rgb2gray(Img));
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

% Find average pixel intensity from frames with mode cluster
estimated = zeros(m,n);
for i = 1:m
    for j = 1:n
        count = 0;
        for f = 1:N
            if S(f).clustered(i,j) == modes(i,j)
               estimated(i,j) = estimated(i,j) + S(f).image(i,j);
               count = count + 1;
            end
        end
        
        if count == 0
            estimated(i,j) = 0;
        else
            estimated(i,j) = estimated(i,j) / count;
        end
    end
end

figure, imshow(uint8(estimated));
