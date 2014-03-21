function bestMatchingIm = kNN_classifier(F1, varargin)

% Inputs:
% F1 - [128xw] (N - number of features descriptors) A feature descriptor in image 1 
% varargin - You can pass in as many features matrices (one corresponding to each image in the training set) as you like...
% Ex: kNN_classifier(F1, F2, F3, F4) would find the best match between F1 and (F2, F3, F4)...

% Outputs:
% bestMatchingIm - Best matching image (feature matrix) - i.e varargin(bestMatchingIm) is the best matching feature set

%make sure they pass in a feature descriptor to compare against
if (length(varargin)<1)
    error('Pass in a feature descriptor to compare probe image to');
end

F_all_cell=varargin; %Cell where the i-th entry is the feature descriptor matrix of image i that was passed in

imageIndex=[]; %will be used later to determine the image that holds a particular feature
for i = 1:length(F_all_cell)
    numFeaturesI = size(F_all_cell{i},2); %get number of features in im i
    imageIndex= [imageIndex i*ones(1, numFeaturesI)];
end

F_all=[]; %matrix with feature matrices of all training images: 128 rows and #cols = (total number of columns in all the feature matrices of all the training images)
for t = 1:size(F_all_cell,2) %for each image in the training image set
    F_all = [F_all F_all_cell{t}]; 
end

distance_F1_F_all=[];

for i = 1:size(F1, 2) %for each descriptor in F1
    for j = 1:size(F_all, 2) %for each descriptor in F2
        distance_F1_F_all(i,j) = norm(double(F1(:,i)) - double(F_all(:,j))); % for each feature vector, there are 128 rows and the columns are the different features
    end
end

[minDist indBestMatchFeature]=min(distance_F1_F_all'); %each row corresponds to a feature in image 1; find its best match in F_all

%indBestMatchFeature currently holds the index of the best matching 'feature' in a matrix that holds all the features of all the images;
%we need to determine the actual image number that the feature belongs to

indBestMatch=[];
for i = 1:length(indBestMatchFeature)
    indBestMatch = [indBestMatch imageIndex(indBestMatchFeature(i))];
end

bestMatchingIm = mode(indBestMatch);
