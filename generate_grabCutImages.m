faceDB = 'lfw_subset';

%check SGM results to find the bad images
post = 'SGM';
[folderPathSGM,pathImgsSGM]= crawl_database_directories(faceDB, post);

for i = 1:length(pathImgsSGM) %for each image in database, compute the grabcut image
    [SegNewImage] = grabCut(pathImgsSGM{i});
end