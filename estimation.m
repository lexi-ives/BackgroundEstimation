close all;
clear;

% Delcare variables
% -----------------
D = 'images/brush';             % directory where the files are saved
S = dir(fullfile(D, '*.jpg'));  % pattern to match filenames
N = numel(S);                   % number of images (frames)

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

% Perform k-means clustering with Gaussian blur
% ---------------------------------------------
sigma = 4;  % for gaussian blur
for f = 1:N
    I = imgaussfilt(I, sigma);
    [clustered, centroids] = kmeans(I(:), k, 'Start', initialCenters);
    clustered = reshape(clustered, size(I));
    S(f).clustered = clustered;     % cluster indeces
end

% Determine mode cluster at each pixel
% -------------------------------------
modes = zeros(m,n); % mode cluster indeces
for i = 1:m
    for j = 1:n
        % accumulate how many times each cluster occurs for this pixel
        acc = zeros(k, 1);
        for f = 1:N
            acc(S(f).clustered(i,j)) = acc(S(f).clustered(i,j)) + 1;
        end
        
        % determine if there is a single mode, if not set mode to 0
        [maxVal, maxIdx] = max(acc);
        numModes = size(find(acc == maxVal));
        if (numModes(1) > 1)
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
        % set pixel to 0 if it does not have a mode cluster
        if modes(i,j) == 0
            estimated(i,j) = 0;
        else
            % build list of intensities for this pixel from each frame
            % (if not in the mode cluster, will be set to 0)
            intensities = zeros(N, 1);
            for f = 1:N
                if S(f).clustered(i,j) == modes(i,j)
                   intensities(f) = S(f).image(i,j);
                end
            end

            % find median of all pixels that belong to mode cluster 
            estimated(i,j) = median(intensities(intensities ~=0));            
        end
    end
end

figure, imshow(uint8(estimated), 'InitialMagnification', 200);
