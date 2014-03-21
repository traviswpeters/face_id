function testSkinModels(varargin)
%For an image, this function will use the stored SGM and GMM models to segment the face in the image

%INPUTS
%fname - [optional] full path to an image; if this is not specified, a dialog box pops up and user can select any image they wants

load('SGM'); % load in the SGM model parameters
load('GMM')  % load in the GMM model parameters

if(nargin==0)
    [fname, imPath] = uigetfile({'*.jpg;*.jpeg;*.tif;*.png;*.gif','All Image Files';'*.*','All Files' });
    I = imread(fullfile(imPath,fname)); %read in the input image
else
    I = imread(varargin{1}); %read in the input image
end

%compute the probability of skin and not skin for every pixel in the image using the SGM model
threshold_SGM = 3; %Threshold for the SGM
p_x_skinSGM = zeros(size(I,1),size(I,2));
p_x_not_skinSGM = zeros(size(I,1),size(I,2));
k = size(weightSkin,1);
for i = 1:size(I,1)
    for j = 1:size(I,2)
        x = normalizeRGB(I(i,j,1), I(i,j,2), I(i,j,3));
        p_x_skinSGM(i,j)=computeGaussianProb(x, uSkin, covSkin); %for each pixel, compute its likelihood of being a skin
        p_x_not_skinSGM(i,j)=computeGaussianProb(x, uNotSkin, covNotSkin); %for each pixel, compute its likelihood of being a non-skin
    end
end

%for each pixel in our 'probe' image, compute p(x|skin)/p(x|!skin) = X, if X>=thres, it means pixel is skin. binarySkin = likelihood
binarySkinSGM = (p_x_skinSGM./p_x_not_skinSGM)>=threshold_SGM; %likelihood 1 where it's >=threshold

%compute the probability of skin and not skin for every pixel in the image using the SGM model
threshold_GMM = 2; %Threshold for the GMM
p_x_skinGMM = zeros(size(I,1),size(I,2));
p_x_not_skinGMM = zeros(size(I,1),size(I,2));
for i = 1:size(I,1)
    for j = 1:size(I,2)
        x = normalizeRGB(I(i,j,1), I(i,j,2), I(i,j,3));
        x = x(1:2);
        for c = 1:k %for each component of the gaussian mixture model get a probability
            p_x_skinGMM(i,j)=p_x_skinGMM(i,j)+weightSkin(c)*computeGaussianProb(x, uSkinGMM(c,:)', covSkinGMM{c}); %for each pixel, compute its likelihood of being a skin
            p_x_not_skinGMM(i,j)=p_x_not_skinGMM(i,j)+weightNotSkin(c)*computeGaussianProb(x, uNotSkinGMM(c,:)', covNotSkinGMM{c}); %for each pixel, compute its likelihood of being a non-skin
        end
    end
end

%for each pixel in our 'probe' image, compute p(x|skin)/p(x|!skin) = X, if X>=thres, it means pixel is skin. binarySkin = likelihood
binarySkinGMM = (p_x_skinGMM./p_x_not_skinGMM)>=threshold_GMM; %likelihood 1 where it's >=threshold

%
[skinPredictSGM, filledISGM, boundingBoxSGM,ISGM] = computeSkin(I, binarySkinSGM);
[skinPredictGMM, filledIGMM, boundingBoxGMM, IGMM] = computeSkin(I, binarySkinGMM);

%SGM SHOW PREDICTED SKIN REGIONS
h1=figure; 
subplot(141)
imshow(I)
subplot(142)
imshow(skinPredictSGM)
title('Skin recovered by SGM')
subplot(143)
imshow(filledISGM)
title('Recovered Skin after eroding & filling in holes')
subplot(144)
imshow(I)
title('SGM')
set(gcf, 'Name', 'Predicted Skin Regions: Using the SGM model', 'NumberTitle', 'off');
hold on;
h=rectangle('Position', boundingBoxSGM, 'EdgeColor','r');

%GMM SHOW PREDICTED SKIN REGIONS
h1=figure; 
subplot(141)
imshow(I)
subplot(142)
imshow(skinPredictGMM)
title('Skin recovered by GMM')
subplot(143)
imshow(filledIGMM)
title('Recovered Skin after eroding & filling in holes')
subplot(144)
imshow(I)
title('GMM')
set(gcf, 'Name', 'Predicted Skin Regions: Using the GMM model', 'NumberTitle', 'off');
hold on;
h=rectangle('Position', boundingBoxGMM, 'EdgeColor','r');

figure
subplot(131)
imshow(I);
title('Original Image');
subplot(132)
imshow(ISGM);
title('Face predicted using SGM')
subplot(133);
imshow(IGMM);
title('Face predicted using GMM')

function [skinPredict, filledI, boundingBox, Icropped] = computeSkin(I, binarySkin)

%DISPLAY PREDICTED SKIN REGIONS
skinPredict = repmat(uint8(binarySkin), [1 1 3]).*I;
skinBinary = im2bw(rgb2gray(skinPredict), 0.1);

filledI = imfill(skinBinary, 'holes'); %fill in holes in the image

se = strel('disk',2);
erodedI = imerode(filledI,se); %erode away noise

L = bwlabel(erodedI); % does something

regionStats = regionprops(L,'BoundingBox', 'Area');

[~,indBestBox] = max(cell2mat({regionStats(:).Area}));
boundingBox=regionStats(indBestBox).BoundingBox; %[x y w h] - (x,y) - top-left corner of rectangle; w h = width and height, respectively
xMin = ceil(boundingBox(1)); yMin = ceil(boundingBox(2)); xMax = floor(boundingBox(1)+boundingBox(3)); yMax = floor(boundingBox(2)+boundingBox(4));
Icropped = I(yMin:yMax, xMin:xMax, :);