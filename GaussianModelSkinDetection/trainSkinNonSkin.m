function [skinColorLookup, non_skinColorLookup] = trainSkinNonSkin(fname)
%This function opens up a figure where the user can contour the image and select skin regions; to exit, the user presses any key on the keyboard
%The function then presents a figure where the user has to select the non-skin regions
%INPUTS:
%fname - [optional] full path to an image; if this is not specified, a dialog box pops up and user can select any image they wants

%OUTPUTS:
%skinColorLookup - A 256x256x256 histogram that holds the RGB values of the segmented skin pixels
%non_skinColorLookup - A 256x256x256 histogram that holds the RGB values of the segmented non-skin pixels

%Example Function Call:
%[skinColorLookup, non_skinColorLookup] = trainSkinNonSkin('1.jpeg');

if(nargin==0)
    [fname, imPath] = uigetfile({'*.jpg;*.jpeg;*.tif;*.png;*.gif','All Image Files';'*.*','All Files' });
    I = imread(fullfile(imPath,fname)); %read in the input image
else
    I = imread(varargin{1}); %read in the input image
end

%get the skin colors
instructions = 'Please segment the skin regions in the image';
skinColorLookup = getROIColors(I, instructions);

%get the non-skin colors
instructions = 'Please segment the non-skin regions in the image';
non_skinColorLookup = getROIColors(I, instructions);

%save(fname(1:find(fname=='.')-1), 'skinColorLookup', 'non_skinColorLookup');
