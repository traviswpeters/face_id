function bestMatchingIm = kNN_classifierCell(F1, F_all)

% Inputs:
% F1 - [128xw] (N - number of features descriptors) A feature descriptor in image 1 
% varargin - You can pass in as many features matrices (one corresponding to each image in the training set) as you like...
% Ex: kNN_classifier(F1, F2, F3, F4) would find the best match between F1 and (F2, F3, F4)...

% Outputs:
% bestMatchingIm - Best matching image (feature matrix) - i.e varargin(bestMatchingIm) is the best matching feature set

%make sure they pass in a feature descriptor to compare against
if (length(F_all)<1)
    error('Pass in a feature descriptor to compare probe image to');
end

imageIndex=[]; %will be used later to determine the image that holds a particular feature
for i = 1:length(F_all)
    numFeaturesI = size(F_all{i},2); %get number of features for person i {the matrix at position i is a concatenation of features for all of person i's images.
    imageIndex= [imageIndex i*ones(1, numFeaturesI)];
end

%matrix with feature matrices of all training images: 128 rows and #cols = (total number of columns in all the feature matrices of all the training images)
F_all = cell2mat(F_all); %F_all comes in as a cell where the i-th entry is the feature descriptor matrix of image i that was passed in)

%really slow
% for i = 1:size(F1, 2) %for each descriptor in F1
%     for j = 1:size(F_all, 2) %for each descriptor in F2
%         
%         distance_F1_F_all(i,j) = norm(double(F1(:,i)) - double(F_all(:,j))); % for each feature vector, there are 128 rows and the columns are the different features
%     end
% end

%pretty slow
% for i = 1:size(F1, 2) %for each descriptor in F1
%     distance_F1_F_all(i,:) = sum(bsxfun(@minus,double(F1(:,i)), double(F_all)).^2); %compare feature i of test image against all the features in the training set
% end

numFeaturesImTest = size(F1, 2);
numFeaturesTrain = size(F_all, 2);

distance_F1_F_all=zeros(numFeaturesImTest, numFeaturesTrain);
distance_F1_F_all = cell2mat(arrayfun(@(x) sum(bsxfun(@minus, double(F1(:,x)), double(F_all)).^2), 1 : numFeaturesImTest, 'UniformOutput', false)');

[~, indBestMatchFeature]=min(distance_F1_F_all'); %each row corresponds to a feature in image 1; find its best match in F_all

%indBestMatchFeature currently holds the index of the best matching 'feature' in a matrix that holds all the features of all the images;
%we need to determine the actual image number that the feature belongs to

indBestMatch=[];
for i = 1:length(indBestMatchFeature)
    indBestMatch = [indBestMatch imageIndex(indBestMatchFeature(i))];
end

bestMatchingIm = mode(indBestMatch);
