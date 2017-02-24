
function [keyframes,panorama,init,expended] = check_newkeyframe(keyframes,tmpkeyframe,panorama,init)

    if init==0
        keyframes = [keyframes,tmpkeyframe];
        keyframes.tform = projective2d(eye(3));
        init=1;
        expended=0;
    else
        % Find correspondences between images
        indexPairs = matchFeatures(tmpkeyframe.features, keyframes(end).features, 'Unique', true);
        matchedPoints2 = tmpkeyframe.points(indexPairs(:,1), :);
        matchedPoints1 = keyframes(end).points(indexPairs(:,2), :);


        % Estimate the transformation between images
        if matchedPoints2.Count >= 10 && matchedPoints1.Count >= 10
            [tmpkeyframe.tform,~,~] = estimateGeometricTransform(matchedPoints2, matchedPoints1,...
                'projective', 'Confidence', 99.9, 'MaxNumTrials', 5000);
        end
        tmpkeyframe.tform.T = keyframes(end).tform.T*tmpkeyframe.tform.T;

        % Check for expension
        [panorama,expended]=determine_expend(keyframes,tmpkeyframe,panorama);
        if expended == 1
            keyframes = [keyframes,tmpkeyframe];
        end

    end

end





function [panorama,expended]=determine_expend(keyframes,tmpkeyframe,panorama)

    expended=0;
    imageSize = size(tmpkeyframe.image);
    tmpframes = [keyframes,tmpkeyframe];

    %% Initialize the Panorama
    for i = 1:numel(tmpframes)
        [xlim(i,:), ylim(i,:)] = outputLimits(tmpframes(i).tform, [1 imageSize(2)], [1 imageSize(1)]);
    end

    % Find the minimum and maximum output limits
    xMin = min([1; xlim(:)]);
    xMax = max([imageSize(2); xlim(:)]);

    yMin = min([1; ylim(:)]);
    yMax = max([imageSize(1); ylim(:)]);

    % Width and height of panorama.
    width  = round(xMax - xMin);
    height = round(yMax - yMin);

    %if width-size(panorama.image,2)>5||height-size(panorama.image,1)>5
        % Initialize the "empty" panorama.
        tmppanorama.image = zeros([height width 3], 'like', tmpkeyframe.image);
    %    expended = 1;
    %else
    %    expended=0;
    %end

    %% Create the Panorama
    tmppanorama.blender = vision.AlphaBlender('Operation', 'Binary mask', ...
    'MaskSource', 'Input port');

    % Create a 2-D spatial reference object defining the size of the panorama.
    xLimits = [xMin xMax];
    yLimits = [yMin yMax];
    tmppanorama.panoramaView = imref2d([height width], xLimits, yLimits);

    % Create the panorama from old frames.
    for i = 1:numel(keyframes)

        I = keyframes(i).image;

        % Transform I into the panorama.
        warpedImage = imwarp(I, keyframes(i).tform, 'OutputView', tmppanorama.panoramaView);

        % Generate a binary mask.
        mask = imwarp(true(size(I,1),size(I,2)), keyframes(i).tform, 'OutputView', tmppanorama.panoramaView);

        % Overlay the warpedImage onto the panorama.
        tmppanorama.image = step(tmppanorama.blender, tmppanorama.image, warpedImage, mask);
    end

    %new key frame
    I = tmpkeyframe.image;

    % Transform I into the panorama.
    warpedImage = imwarp(I, tmpkeyframe.tform, 'OutputView', tmppanorama.panoramaView);

    % Generate a binary mask.
    mask = imwarp(true(size(I,1),size(I,2)), tmpkeyframe.tform, 'OutputView', tmppanorama.panoramaView);
    
    newregion = xor(mask,rgb2gray(tmppanorama.image));
    newregion = newregion.*mask;
    
    intersectregion = and(mask,rgb2gray(tmppanorama.image))

    if sum(sum(newregion)>6000)
        tmppanorama.image = step(tmppanorama.blender, tmppanorama.image, warpedImage, mask);
        expended = 1;
        panorama = tmppanorama;
    end
        

end


