% function images = extract_images(video_filepath, new_folder_filepath)
% Extract images - given a video file, return an array of still images 
% uniformly extracted from the video


% folder = 'new_folder_filepath';
folder = 'images\memorial3';
% vid = VideoReader(video_filepath);
vid = VideoReader('videos/memorial_union3.mp4');
n = vid.NumberOfFrames;
step = uint32(n/14);
for k = step : step : n-1
    frames = read(vid,k);
    imwrite(frames, fullfile(folder, sprintf('%06d.jpg', k)));
end
FileList = dir(fullfile(folder, '*.jpg'));
for iFile = 1:length(FileList)
  aFile = fullfile(folder, FileList(iFile).name);
  img   = imread(aFile);
end

% return aFile;
% end