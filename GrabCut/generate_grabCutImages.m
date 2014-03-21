faceDB = 'lfw_subset';

%check SGM results to find the bad images
post = 'SGM';
[folderPath,pathImgs]= crawl_database_directories(faceDB); %original images
[folderPathSGM,pathImgsSGM]= crawl_database_directories(faceDB, post); %sgm images
%[folderPathGood, pathImgsGood, folderPathBad, pathImgsBad, pathImgsMissing, countMissingSGMs] = identify_bad_segs_and_paths(folderPathSGM,pathImgsSGM);

%go through each image in the database
for i = 1:length(pathImgsSGM) % for each image, check if it's width or height <65 (if so, reject it
    if exist(pathImgsSGM{i})
        I = imread(pathImgsSGM{i});
    else
        continue;
    end
    if ~( size(I,1)<65 || size(I,2)<65 ) %run grabCut if image is large enough
       load(pathImgsSGM{i}(1:max(find(pathImgsSGM{i}=='.'))-1)); %get rectangle coordinates
       [SegNewImage, segImageBoxed] = grabCut(pathImgs{i}, xMin, xMax, yMin, yMax, boundingBox); 
       
    end
end
