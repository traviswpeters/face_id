function [folderPathGood,pathImgsGood, folderPathBad, pathImgsBad, pathImgsMissing, countMissingIMs] = identify_bad_segs_and_paths(folderPath,pathImgs)

%Inputs
%filepath - full path to the image file including the name of the image

%Outputs
%filePathsGood - cell array containing the paths to the files that are good segmentations

minDim = 65; %min image height and width that is considered acceptable
countGood = 1;
countBad = 1;
countMissingIMs =0;
pathImgsMissing={};
for i = 1:length(pathImgs) % for each image, check if it's width or height <65 (if so, reject it
    if exist(pathImgs{i})
        I = imread(pathImgs{i});
    else
        countMissingIMs = countMissingIMs+1;
        pathImgsMissing{countMissingIMs} = pathImgs{i};
        continue;
    end
    if( size(I,1)<65 || size(I,2)<65 ) %if either the width or the height is too small
        folderPathBad{countBad} = folderPath{i};
        pathImgsBad{countBad} = pathImgs{i};
        countBad = countBad+1;
        continue
    else
        folderPathGood{countGood} = folderPath{i};
        pathImgsGood{countGood} = pathImgs{i};
        countGood=countGood+1;
    end
end

