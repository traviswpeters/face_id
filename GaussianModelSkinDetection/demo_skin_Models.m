%% Train the Gaussian Models: Contours skin in first figure that pops up and non-skin pixels in second figure that pops up
[skinColorLookup, non_skinColorLookup] = trainSkinNonSkin(); %Select image when you get pop-up

%% For an image, produce the SGM and GMM images
testSkinModels(); % please select image using browse or pass in full path to the image.

%% Demonstrate how SGM and GMM are generated (using the training data) - TAKES A FEW MINUTES

data=load('skinModelData.mat'); %skin/non-skin color training data using lfw
skinColorLookup=data.skinColorLookup;
non_skinColorLookup=data.non_skinColorLookup;

%generate SGM
[uSkinSGM, covSkinSGM, uNotSkinSGM, covNotSkinSGM] = sgm_using_training_data(skinColorLookup, non_skinColorLookup);

%generate GMM
[uSkinGMM, covSkinGMM, weightSkin, uNotSkinGMM, covNotSkinGMM, weightNotSkin] = gmm_using_training_data(skinColorLookup, non_skinColorLookup);
