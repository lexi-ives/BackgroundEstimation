% function images = extract_images(video_filepath, new_folder_filepath, num_frames)
% Extract images - given a video file, return an array of still images 
% uniformly extracted from the video

num_frames = num_frames+1;
folder = 'new_folder_filepath';
vid = VideoReader(video_filepath);
n = vid.NumberOfFrames;
step = uint32(n/14);
for k = step : step : n-1
    frames = read(vid,k);
    imwrite(frames, fullfile(folder, sprintf('%06d.jpg', k)));
end

end
