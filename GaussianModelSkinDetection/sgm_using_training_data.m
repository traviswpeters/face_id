function [uSkinSGM, covSkinSGM, uNotSkinSGM, covNotSkinSGM] = sgm_using_training_data(skinColorLookup, non_skinColorLookup)

[uSkinSGM, covSkinSGM] = getGaussianModelParams(skinColorLookup);
[uNotSkinSGM, covNotSkinSGM] = getGaussianModelParams(non_skinColorLookup );