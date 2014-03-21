function [uSkinGMM, covSkinGMM, weightSkin, uNotSkinGMM, covNotSkinGMM, weightNotSkin] = gmm_using_training_data(skinColorLookup, non_skinColorLookup)

%All the skin colors possible are tallied in skinColorLookup:  Build the Gaussian distribution for skin pixels
k = 4; %number of the components in the GMM
threshold=1e-3;
maxIters = 250;
[uSkinGMM, covSkinGMM, weightSkin] = GMMEM(skinColorLookup, k, threshold, maxIters); %get skinGMM
[uNotSkinGMM, covNotSkinGMM, weightNotSkin] = GMMEM(non_skinColorLookup, k, threshold, maxIters); %get nonskinGMM
