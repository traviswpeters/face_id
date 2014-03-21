faceDB = 'lfw_subset';

%check SGM results to find the bad images
post = 'SGM';
[folderPathSGM,pathImgsSGM]= crawl_database_directories(faceDB, post);
[folderPathGood, pathImgsGood, folderPathBad, pathImgsBad, pathImgsMissing, countMissingSGMs] = identify_bad_segs_and_paths(folderPathSGM,pathImgsSGM);

%check SGM results to find the bad images
post = 'GMM';
[folderPathGMM,pathImgsGMM]= crawl_database_directories(faceDB, post);
[folderPathGoodGMM, pathImgsGoodGMM, folderPathBadGMM, pathImgsBadGMM, pathImgsMissingGMM, countMissingGMMs] = identify_bad_segs_and_paths(folderPathGMM,pathImgsGMM);

for i = 1:length(folderPathBad)
    disp([folderPathBad{i}])
end

for i = 1:length(folderPathBadGMM)
    disp([folderPathBadGMM{i}])
end