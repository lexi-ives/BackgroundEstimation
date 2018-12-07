close all;
clear;

D = 'Landscapes/desert'; % directory where the files are saved
S = dir(fullfile(D, '*.jpg')); % pattern to match filenames
N = numel(S); % number of images (frames)
k = 5; % for k-means clustering
sigma = 4;  % for gaussian blur

for f = 1:N
    % Read image, convert to grayscale
    F = fullfile(D, S(f).name);
    Img = imread(F);
    %Img = rgb2gray(Img);
    I = double(Img);
    S(f).image = I;
    %figure, imshow(I);
    
    % Perform k-means clustering
    I = imgaussfilt(I, sigma);
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
        
        z = size(find(acc == maxVal));
        if (z(1) > 1)
            modes(i,j) = 0;
        else
            modes(i,j) = maxIdx;
        end
    end
end

% Find median pixel intensity from frames with mode cluster
estimated = zeros(m,n);
for i = 1:m
    for j = 1:n
        if modes(i,j) ~= 0 
            intensities = zeros(N, 1);
            for f = 1:N
                if S(f).clustered(i,j) == modes(i,j)
                   intensities(f) = S(f).image(i,j);
                end
            end

            estimated(i,j) = median(intensities(intensities ~=0));
        else
           estimated(i,j) = 0; 
        end
    end
end

figure, imshow(uint8(estimated), 'InitialMagnification', 200);
