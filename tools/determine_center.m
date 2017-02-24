function [keyframes,panorama] = determine_center(keyframes)

    %% Automatically determine center frame
    imageSize = size(keyframes(1).image);  % all the images are the same size
    
    

    % Compute the output limits  for each transform
    for i = 1:numel(keyframes)
        [xlim(i,:), ylim(i,:)] = outputLimits(keyframes(i).tform, [1 imageSize(2)], [1 imageSize(1)]);
    end

    avgXLim = mean(xlim, 2);

    [~, idx] = sort(avgXLim);

    centerIdx = floor((numel(keyframes)+1)/2);

    centerImageIdx = idx(centerIdx);

    Tinv = invert(keyframes(centerImageIdx).tform);

    for i = 1:numel(keyframes)
        keyframes(i).tform.T = Tinv.T * keyframes(i).tform.T;
    end
    
    panorama = recompute_panorama(keyframes);
    

end


function panorama = recompute_panorama(keyframes)
    imageSize = size(keyframes(1).image);

    %% Initialize the Panorama
    for i = 1:numel(keyframes)
        [xlim(i,:), ylim(i,:)] = outputLimits(keyframes(i).tform, [1 imageSize(2)], [1 imageSize(1)]);
    end

    % Find the minimum and maximum output limits
    xMin = min([1; xlim(:)]);
    xMax = max([imageSize(2); xlim(:)]);

    yMin = min([1; ylim(:)]);
    yMax = max([imageSize(1); ylim(:)]);

    % Width and height of panorama.
    width  = round(xMax - xMin);
    height = round(yMax - yMin);

    % Initialize the "empty" panorama.
    panorama.image = zeros([height width 3], 'like', keyframes(1).image);

    %% Create the Panorama
    panorama.blender = vision.AlphaBlender('Operation', 'Binary mask', ...
    'MaskSource', 'Input port');

    % Create a 2-D spatial reference object defining the size of the panorama.
    xLimits = [xMin xMax];
    yLimits = [yMin yMax];
    panorama.panoramaView = imref2d([height width], xLimits, yLimits);


end