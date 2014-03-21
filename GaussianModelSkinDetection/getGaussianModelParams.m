function [u, cov] = getGaussianModelParams(colorLookup)
%Given skin/non-skin training data, this function generates a Single Gaussian Model and outputs the mean and covariance of the model

%Inputs:
% colorLookup - [256, 256, 256] color map for uint8 images or [2^16, 2^16, 2^16] color map for uint16 images;

%Outputs:
%Gaussian Model parameters
%u - mean for the gaussian distribution model
%cov - covariance matrix

colorSum=zeros(3,1);
colorCount = 0; %number of colors
colorSpace=[]; %all the normalized (rgb) unique colors that were in colorLookup
numColors = size(colorLookup, 1);

for R = 1:numColors
    for G = 1:numColors
        for B = 1:numColors
            if(colorLookup(R,G,B)~=0)
                colorCount = colorCount+1; %number of colors
                x = normalizeRGB(R,G,B); %normalized R, G, B values
                colorSpace = [colorSpace x]; %store all the colors
                colorSum = colorSum + x;
            end
        end
    end
end

%compute the mean for the Gaussian distribution
u = colorSum/colorCount;
% compute D; D is the mean-centered color space (normalized rgb values) 3xcolorCount) for the Gaussian distribution
D = colorSpace - kron(u, ones(1,size(colorSpace,2)));
%compute the covariance for the Gaussian distribution
cov = D*D'/(colorCount-1);