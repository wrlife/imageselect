clear all; close all; clc;
%% choice
database_path = '/playpen/wrlife/UNC_Laryngoscopy_case006/seq1/sfm_results/';
%database_path = '../matchingResults/';
database_name = 'test';
compareWithExhaustiveMatching = 1;
%% use the following system command to fetch data from database file
% the system command ">!", which means overwrite redirection, can be
% different across different systems. Some system uses ">" for overwrite.
if(~exist('./cache', 'dir'))
    mkdir('./cache');
end
delete('./cache/*');
if(~exist('./output', 'dir'))
    mkdir('./output');
end
system(['sqlite3 -csv -header ',database_path, database_name, '.db "SELECT data FROM inlier_matches" > ./cache/result.csv']);
inlier_info = importdata(['./cache/result.csv']);
inlier = inlier_info.data;
system(['sqlite3 -csv -header ',database_path, database_name, '.db "SELECT pair_id FROM inlier_matches" > ./cache/pairid.csv']);
pairid_info = importdata(['./cache/pairid.csv']);
pairid = pairid_info.data;
system(['sqlite3 -csv -header ',database_path, database_name, '.db "SELECT image_id FROM images" > ./cache/images.csv']);
images_info = importdata(['./cache/images.csv']);
image_id = images_info.data;
system(['sqlite3 -csv -header ',database_path, database_name, '.db "SELECT name FROM images" > ./cache/image_names.csv']);
imagesname_info = importdata(['./cache/image_names.csv']);
system(['sqlite3 -csv -header ',database_path, database_name, '.db "SELECT rows FROM keypoints" > ./cache/keypoints.csv']);
keypoints_info = importdata(['./cache/keypoints.csv']);
keypoints = keypoints_info.data;



%% read data from structuresvocab262144_100
Num_Images = length(image_id);
Num_Inlier = length(inlier);
% vocabulary tree matching
Matches = zeros(Num_Images);
for i=1:length(pairid)
    id2 = mod(pairid(i), 2147483647);
    id1 = floor((pairid(i) - id2)/2147483647 + 0.5);
    Matches(id1, id2) = inlier(i);%/(keypoints(id1) + keypoints(id2));
    Matches(id2, id1) = inlier(i);%/(keypoints(id1) + keypoints(id2));
end
%figure('Name', 'Dice Coefficients');
%imshow(mat2gray(Matches));
%% compare VocabTree Matching with Exhaustive matching
if(compareWithExhaustiveMatching)
    exhaustive_faraway_pairs = zeros(Num_In, 3);
    count = 0;
    exhaustivedb_name = 'exhaustivematching';
    system(['sqlite3 -csv -header ',database_path, exhaustivedb_name, '.db "SELECT rows FROM inlier_matches" > ./cache/exhaustiveresult.csv']);
    exhaustiveinlier_info = importdata(['./cache/exhaustiveresult.csv']);
    exhaustiveinlier = exhaustiveinlier_info.data;
    system(['sqlite3 -csv -header ',database_path, exhaustivedb_name, '.db "SELECT pair_id FROM inlier_matches" > ./cache/exhaustivepairid.csv']);
    exhaustivepairid_info = importdata(['./cache/exhaustivepairid.csv']);
    exhaustivepairid = exhaustivepairid_info.data;
    % exhaustive matching
    ExhaustiveMatches = zeros(Num_Images);
    for i=1:length(exhaustivepairid)
        id2 = mod(exhaustivepairid(i), 2147483647);
        id1 = floor((exhaustivepairid(i) - id2)/2147483647 + 0.5);
        ExhaustiveMatches(id1, id2) = exhaustiveinlier(i);%/(keypoints(id1) + keypoints(id2));
        ExhaustiveMatches(id2, id1) = exhaustiveinlier(i);%/(keypoints(id1) + keypoints(id2));
        if(abs(id2 - id1) > 30 && exhaustiveinlier(i) > 0.5)
            count = count + 1;
            exhaustive_faraway_pairs(count, :) = [id1, id2, exhaustiveinlier(i)];
        end
    end
    ax = (1:1:Num_Images);
    matchedImages = zeros(Num_Images, 1);
    exhaustiveImages = zeros(Num_Images, 1);
    for i=1:Num_Images
        matchedImages(i) =  length(find(Matches(:, i)>0.5));
        exhaustiveImages(i) = length(find(ExhaustiveMatches(:, i)>0.5));
    end
    retrivedRatio = sum(matchedImages) / sum(exhaustiveImages);
    fprintf('Average Retrived Ratio = %.2f%%\n', retrivedRatio*100);
    h = figure;
    plot(ax, matchedImages, 'r');
    hold on;
    plot(ax, exhaustiveImages, 'b');
    hold off;
    title(sprintf('Average Retrived Ratio = %.2f%%\n', retrivedRatio*100));
    saveas(h, ['./output/', database_name, '.jpg'], 'jpg');
end
%% delete cache
delete('./cache/*');