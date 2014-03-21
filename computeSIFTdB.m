faceDB = 'lfw_subset';

%all the images in the database
[folderPath,pathImgs]= crawl_database_directories(faceDB);
post = 'SGM';
[folderPathSGM,pathImgsSGM]= crawl_database_directories(faceDB, post); %SGM paths total
post = 'GMM';
[folderPathGMM,pathImgsGMM]= crawl_database_directories(faceDB, post); %SGM paths total

%compute sift descriptors for each original image
for i = 1:length(pathImgs)
    %if~(exist([pathImgs{i}(1:find(pathImgs{i} == '.')-1) 'sift.mat']))
    [num2str(i) 'orig']
        I=imreadbw(pathImgs{i}) ;
        I=I-min(I(:)) ;
        I=I/max(I(:)) ;
        [frames1,descr,gss1,dogss1] = sift( I, 'Verbosity', 0 ) ; %get sift descriptor
        
        save([pathImgs{i}(1:find(pathImgs{i} == '.')-1) 'sift'], 'descr');
    %end
end

%compute sift descriptors for each sgm image
for i = 1:length(pathImgsSGM)
    [num2str(i) 'sgm']
    %if~(exist([pathImgsSGM{i}(1:find(pathImgsSGM{i} == '.')-1) '_sgm_sift']))
    I=imreadbw(pathImgsSGM{i}) ;
    
    if ( size(I,1)<65 || size(I,2)<65 ) %if the image is not big enough, use original image
        I=imreadbw(pathImgs{i}) ;
    end
        I=I-min(I(:)) ;
        I=I/max(I(:)) ;
        [frames1,descr,gss1,dogss1] = sift( I, 'Verbosity', 0 ) ; %get sift descriptor
        
        save([pathImgsSGM{i}(1:find(pathImgsSGM{i} == '.')-1) '_sgm_sift'], 'descr');
    %end
end

%compute sift descriptors for each gmm image
for i = 1:length(pathImgsGMM)
    [num2str(i) 'gmm']
    I=imreadbw(pathImgsGMM{i}) ;
    %if~(exist([pathImgsGMM{i}(1:find(pathImgsGMM{i} == '.')-1) '_gmm_sift']))
        if ( size(I,1)<65 || size(I,2)<65 ) %if the image is not big enough, use original image
            I=imreadbw(pathImgs{i}) ; %use original image instead
        end
        I=I-min(I(:)) ;
        I=I/max(I(:)) ;
        [frames1,descr,gss1,dogss1] = sift( I, 'Verbosity', 0 ) ; %get sift descriptor
        
        save([pathImgsGMM{i}(1:find(pathImgsGMM{i} == '.')-1) '_gmm_sift'], 'descr');
    %end
end