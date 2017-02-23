function align_all(inputDir, outputDir, startFrame, endFrame, features,blendmethod)


    %Add poisson image editing 
    %addpath('./PoissonEdiitng20151105/');
    addpath('./ModifiedPoisson20160622/ModifiedPoisson');


    % start timer
    tic
    
    % get image filenames from directory
    image_set = imageSet(inputDir);
    startFrame = max(1, startFrame);
    endFrame = min(endFrame, image_set.Count);
    
    % create output directory
    mkdir(outputDir);
    
    % Read the first image
    im2 = read(image_set, startFrame);
    gray2 = rgb2gray(im2);

    % Detect and extract features
    if strcmpi(features,'BRISK')
        points2 = detectBRISKFeatures(gray2); 
    elseif strcmpi(features,'FAST')
        points2 = detectFASTFeatures(gray2);
    elseif strcmpi(features,'HARRIS')
        points2 = detectHarrisFeatures(gray2);
    elseif strcmpi(features,'SURF')
        points2 = detectSURFFeatures(gray2,'MetricThreshold',100);
    end
    [features2, points2] = extractFeatures(gray2, points2);
    
    % Initialize all the transforms to the identity matrix. Note that the
    % projective transform is used here because the building images are fairly
    % close to the camera. Had the scene been captured from a further distance,
    % an affine transform would suffice.
    numImages = endFrame-startFrame+1;
    tforms(numImages) = projective2d(eye(3));
    

    % Iterate over remaining image pairs
    for frame = startFrame+1:endFrame

        % Store info for previous image
        im1 = im2;
        points1 = points2;
        features1 = features2;

        % Read next image
        im2 = read(image_set, frame);
        gray2 = rgb2gray(im2);

        % Detect and extract features 
        if strcmp(features,'BRISK')
            points2 = detectBRISKFeatures(gray2); 
        elseif strcmp(features,'FAST')
            points2 = detectFASTFeatures(gray2);
        elseif strcmp(features,'HARRIS')
            points2 = detectHarrisFeatures(gray2);
        elseif strcmp(features,'SURF')
            points2 = detectSURFFeatures(gray2,'MetricThreshold',100);
        end
        [features2, points2] = extractFeatures(gray2, points2);

        % Find correspondences between images
        indexPairs = matchFeatures(features2, features1, 'Unique', true);
        matchedPoints2 = points2(indexPairs(:,1), :);
        matchedPoints1 = points1(indexPairs(:,2), :);
        
        %show matched features
        %figure;showMatchedFeatures(im1,im2,matchedPoints1,matchedPoints2);

        % Estimate the transformation between images

        if matchedPoints2.Count >= 10 && matchedPoints1.Count >= 10
            [tforms(frame),~,~] = estimateGeometricTransform(matchedPoints2, matchedPoints1,...
                'projective', 'Confidence', 99.9, 'MaxNumTrials', 5000);
        end
        
        
        % Compute T(1) * ... * T(n-1) * T(n)
        tforms(frame).T = tforms(frame-1).T * tforms(frame).T;
        

    
    % end timer
    toc
    end

    
    %% Automatically determine center frame
    imageSize = size(im2);  % all the images are the same size

    % Compute the output limits  for each transform
    for i = 1:numel(tforms)
        [xlim(i,:), ylim(i,:)] = outputLimits(tforms(i), [1 imageSize(2)], [1 imageSize(1)]);
    end

    avgXLim = mean(xlim, 2);

    [~, idx] = sort(avgXLim);

    centerIdx = floor((numel(tforms)+1)/2);

    centerImageIdx = idx(centerIdx);

    Tinv = invert(tforms(centerImageIdx));

    for i = 1:numel(tforms)
        tforms(i).T = Tinv.T * tforms(i).T;
    end


    %% Initialize the Panorama
    for i = 1:numel(tforms)
        [xlim(i,:), ylim(i,:)] = outputLimits(tforms(i), [1 imageSize(2)], [1 imageSize(1)]);
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
    panorama = zeros([height width 3], 'like', im2);
    
    
    %% Create the Panorama
    blender = vision.AlphaBlender('Operation', 'Binary mask', ...
    'MaskSource', 'Input port');

% Create a 2-D spatial reference object defining the size of the panorama.
xLimits = [xMin xMax];
yLimits = [yMin yMax];
panoramaView = imref2d([height width], xLimits, yLimits);



% Create the panorama.
for i = startFrame:endFrame
    
    I = read(image_set, i);

    % Transform I into the panorama.
    warpedImage = imwarp(I, tforms(i), 'OutputView', panoramaView);

    % Generate a binary mask.
    mask = imwarp(true(size(I,1),size(I,2)), tforms(i), 'OutputView', panoramaView);
    
    
    if strcmpi(blendmethod,'poisson')
          
        if i==startFrame
            panorama=warpedImage;
        else
            poissonfuse;
        end
    else
        
        % Overlay the warpedImage onto the panorama.
        panorama = step(blender, panorama, warpedImage, mask);
    end
end

%figure
%imshow(uint8(panorama))
imwrite(uint8(panorama),'test.jpg');
