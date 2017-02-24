function panorama=create_panorama(keyframes,panorama)

% Create the panorama.
for i = 1:numel(keyframes)

    I = keyframes(i).image;

    % Transform I into the panorama.
    warpedImage = imwarp(I, keyframes(i).tform, 'OutputView', panorama.panoramaView);

    % Generate a binary mask.
    mask = imwarp(true(size(I,1),size(I,2)), keyframes(i).tform, 'OutputView', panorama.panoramaView);

    % Overlay the warpedImage onto the panorama.
    panorama.image = step(panorama.blender, panorama.image, warpedImage, mask);
end
