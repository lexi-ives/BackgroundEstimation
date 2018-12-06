close all;
clear;

D = 'images'; % directory where the files are saved
S = dir(fullfile(D, 'simple_test_*.jpeg')); % pattern to match filenames
N = numel(S); % number of images

for k = 1:N
    % Read image, convert to grayscale
    F = fullfile(D, S(k).name);
    I = imread(F);
    I = rgb2gray(double(I));
    S(k).image = I;
    %figure, imshow(I);
    
    % Perform k-means clustering
    [idx, C] = kmeans(I, 5);
    S(k).idx = idx; % cluster indeces
    S(k).C = C; 	% cluster centroid locations

    
end

% perform clustering on each frame


