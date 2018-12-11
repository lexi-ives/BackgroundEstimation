close all;
clear;

% Delcare variables
% -----------------
D = 'Landscapes/classroom'; % directory where the files are saved
S = dir(fullfile(D, '*.jpg')); % pattern to match filenames
N = numel(S); % number of images (frames)

% Read images
% -----------
for f = 1:N
    F = fullfile(D, S(f).name);
    Img = imread(F);
    %Img = rgb2gray(Img);   % uncomment for rgb images
    
    I = double(Img);
    S(f).image = I;
end
[m,n] = size(S(1).image);

% Determine cluster seed starting locations for k-means
% -----------------------------------------------------
k = 5;                              % number of clusters
initialCenters = zeros(k, 1);       % inital centroid locations
partitionSize = floor((m*n) / k);   % distance between centroids
for i = 1:k
    initialCenters(i) = i * partitionSize;
end

% Perform k-means clustering
% --------------------------
sigma = 4;  % for gaussian blur
for f = 1:N
    I = imgaussfilt(I, sigma);
    [clustered, centroids] = kmeans(I(:), k, 'Start', initialCenters);
    clustered = reshape(clustered, size(I));
    S(f).clustered = clustered; % cluster indeces
end

% Determine mode cluster at each pixel
% -------------------------------------
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
% ---------------------------------------------------------
estimated = zeros(m,n);
for i = 1:m
    for j = 1:n
        if modes(i,j) == 0
            estimated(i,j) = 0;
        else
            intensities = zeros(N, 1);
            for f = 1:N
                if S(f).clustered(i,j) == modes(i,j)
                   intensities(f) = S(f).image(i,j);
                end
            end

            estimated(i,j) = median(intensities(intensities ~=0));            
        end
    end
end

figure, imshow(uint8(estimated), 'InitialMagnification', 200);
