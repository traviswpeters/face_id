function [colorLookup, segI] = getROIColors(I, instructions)
%This function allows the user to contour a figure and outputs the RGB values of the contoured regions in a colorLookup table

%Inputs:
% I - Color Image [MxNx3] - uint8 or uint16
% instructions - string which will specify to the user what he/she should be doing

%Outputs:
% colorLookup - [256, 256, 256] color map for uint8 images or [2^16, 2^16, 2^16] color map for uint16 images;
% where colorLookup(R,G,B) is the number of occurences of that particular pixel color in the segmented image regions (ROIs)
% segI - Segmented Image

%show original image
h=figure;
imshow(I);
title(instructions)
set(gcf, 'Name', 'Original Image', 'NumberTitle', 'off');

%ALLOW USERS TO SEGMENT AND RECOVER SEGMENTED PIXELS
%---
binarySegMap = logical(zeros(size(I,1), size(I,2))); %binary map: 1 inside contour; 0 outside
%allow users to draw multiple contours and save them in binarySegMap
while (~waitforbuttonpress) %0 for mousepress; 1 for keyboard press
    h1= imfreehand;
    newContour = createMask(h1); %contour drawn 
    binarySegMap = (newContour==1) | (binarySegMap==1);
end

%DISPLAY SEGMENTMENTED REGIONS
%recover just the segmented part of the image for display purposes
binarySegMap = repmat(uint8(binarySegMap), [1 1 3]);
segI = binarySegMap.*I; 

figure %SHOW segmented regions (blacken out background)
imshow(segI)
set(gcf, 'Name', 'Skin Segments', 'NumberTitle', 'off');

%RECOVER SEGMENTED PIXELS ONLY
binarySegMap_1D = binarySegMap(:,:,1);
[indx indy] = find(binarySegMap_1D==1);
segPixels=I(indx, indy, :); %holds the RGB for all the segmented pixels

%Check image type; get color lookup matrix of the appropriate size
if(isa(I, 'uint16'))
    numColors = 2^16;
elseif(isa(I, 'uint8'))
    numColors = 256;
else
    error('Please input an 8-bit or 16-bit integer image');
end

%CREATE COLOR LOOKUP MATRIX
colorLookup = zeros(numColors, numColors, numColors);
segPixels=reshape(segPixels,[size(segPixels, 1)*size(segPixels, 2) 3]); % Make a vector of all RGB values in the image

%Loop through all segmented pixels and tally up their count in a color lookup matrix: skinColors [numColors, numColors, numColors]
indOffset=1; %Colors range from 0-255; we index our matrix by color value + 1 as matlab is 1-indexed
for i = 1:length(segPixels)
    R = segPixels(i,1); G = segPixels(i,2); B = segPixels(i,3);
    colorLookup(R+indOffset,G+indOffset,B+indOffset) = colorLookup(R+indOffset,G+indOffset,B+indOffset) + 1;
end