faceDB = 'lfw_subset';

%Navigate through each folder and create feature sets for the original images
dbPath = fullfile('C:\Users\Haider\Documents\CS_Phd\Fall_2013\CS_183_ComputerVision\Project\Databases', faceDB);

%In the database folder, we have folders of patients images - the folders names are: 1 2 3 4 ... 100 
% there are a total of 100 image sets (each with 4 images inside

%Inside these folders, we have mat files that contain the descriptors for each image stored as well:
% In each folder, we have sift descriptors stored for the original image, SGM image and GMM images; so for each folder, we have:
% sift descriptors for original image: 1sift.mat             2sift.mat           3sift.mat           4sift.mat
% sift descriptors for SGM seg. image: 1SGM_sgm_sift.mat     2SGM_sgm_sift.mat   3SGM_sgm_sift.mat   4SGM_sgm_sift.mat
% sift descriptors for SGM seg. image: 1GMM_gmm_sift.mat     2GMM_gmm_sift.mat   3GMM_gmm_sift.mat   4GMM_gmm_sift.mat

%We want to perform cross-validation using these datasets:
% So we would have:
%Test1 - 



folder_names = dir(dbPath);

count = 0;
descriptsTrain=[];
descriptsTest=[];
for i = 3:length(folder_names) %go through each folder
    pathToFolder = fullfile(dbPath, folder_names(i).name);
    
    descr1 = load(fullfile(pathToFolder,'1SGM_sgm_sift'));
    descr2 = load(fullfile(pathToFolder,'2SGM_sgm_sift'));
    descr3 = load(fullfile(pathToFolder,'3SGM_sgm_sift'));
    descr4 = load(fullfile(pathToFolder,'4SGM_sgm_sift'));
    
    count = count+1;
    descriptsTrain{count} = [descr1.descr descr2.descr descr3.descr];
    descriptsTest{count} = descr4.descr;
end

indMatch = kNN_classifierCell(descriptsTest{4}, descriptsTrain)