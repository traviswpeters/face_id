function test_image_against_database()
%This function opens up a figure where the user can contour the image and select skin regions; to exit, the user presses any key on the keyboard
%The function then presents a figure where the user has to select the non-skin regions
%INPUTS:
%fname - [optional] full path to an image; if this is not specified, a dialog box pops up and user can select any image they wants

[fname, imPath] = uigetfile({'*.jpg;*.jpeg;*.tif;*.png;*.gif','All Image Files';'*.*','All Files' });
I = imread(fullfile(imPath,fname)); %read in the input image

imNum = str2num(fname(1)); %get the image number

faceDB = 'lfw_subset';

currDir = pwd;

%Navigate through each folder and create feature sets for the original images
dbPath = fullfile(currDir, faceDB);

folder_names = dir(dbPath);

count = 0;
descriptsTrain={};
descriptsTest={};

ind = find(imPath=='\'); m = ind(end-1);
patNum = imPath(m+1:end-1);
    
siftFnameSuffix = {'GMM_gmm_sift', 'SGM_sgm_sift', 'sift'};

for s = 1:3
    siftfnamesuffix = siftFnameSuffix{s};
    for i = 4:length(folder_names) %go through each folder
        pathtofolder = fullfile(currDir,faceDB, folder_names(i).name);
        descr1 = load(fullfile(pathtofolder,['1' siftfnamesuffix]));
        descr2 = load(fullfile(pathtofolder,['2' siftfnamesuffix]));
        descr3 = load(fullfile(pathtofolder,['3' siftfnamesuffix]));
        descr4 = load(fullfile(pathtofolder,['4' siftfnamesuffix]));
        
        count = count+1;
        if (imNum ==1)
            descriptstrain{count} = [descr2.descr descr3.descr descr4.descr];
            descriptstest{count} = descr1.descr;
        elseif(imNum ==2)
            descriptstrain{count} = [descr1.descr descr3.descr descr4.descr];
            descriptstest{count} = descr2.descr;
        elseif(imNum ==3)
            descriptstrain{count} = [descr1.descr descr2.descr descr4.descr];
            descriptstest{count} = descr3.descr;
        elseif(imNum ==4)
            descriptstrain{count} = [descr1.descr descr2.descr descr3.descr];
            descriptstest{count} = descr4.descr;
        end
    end
    indMatch{s} = kNN_classifierCell(descriptstrain{imNum}, descriptstest);
    
    
    if s ==1
        disp([num2str(patNum) ' matched to ' num2str(indMatch{s}) ' using GMM' ])
    elseif s==2
        disp([num2str(patNum) ' matched to ' num2str(indMatch{s}) ' using SGM'])
    elseif s==3
        disp([num2str(patNum) ' matched to ' num2str(indMatch{s}) ' using SIFT on original images'])
    end
end
