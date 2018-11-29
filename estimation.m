close all;
clear;

D = 'images'; % directory where the files are saved
S = dir(fullfile(D, 'simple_test_*.jpeg')); % pattern to match filenames
N = numel(S); % number of images

for k = 1:N
    F = fullfile(D, S(k).name);
    I = imread(F);
    %figure, imshow(I);
    S(k).data = I;
end
