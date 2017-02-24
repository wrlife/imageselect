function Subseq_select(inputDir,outputDir, features)

addpath('./tools');

%% Get image list
% get image filenames from directory
image_set = imageSet(inputDir);

%% Initialization
init=0; 
recenter=0;
total_frame_count=1;
keyframes = [];  % store all currently selected frames

%% Loop through images

for i = 1:image_set.Count
    
    % TODO use deep learning to recognize good image
    
    %Read image and perform feature detection
    imgnew = read(image_set,i);
    

    % Detect and extract features
    tmpkeyframe = m_feature_extraction(imgnew,features);
    
    %Determine wether to keep new key frame
    if init==0
        panorama.image = zeros(size(tmpkeyframe.image), 'like', tmpkeyframe.image);
    end

    if recenter==5
        [keyframes,panorama] = determine_center(keyframes);
        recenter=0;
    end
    [keyframes,panorama,init,expended] = check_newkeyframe(keyframes,tmpkeyframe,panorama,init);
    

    %Create panorama
    if expended==1
        %panorama=create_panorama(keyframes,panorama);
        recenter=recenter+1;
        total_frame_count = total_frame_count+1;
        
    end

    fprintf('current frame: %d, selected frame: %d\n',i,total_frame_count);


    if total_frame_count==20
        break;
    end
    
end

panorama=create_panorama(keyframes,panorama);
imshow(panorama.image);