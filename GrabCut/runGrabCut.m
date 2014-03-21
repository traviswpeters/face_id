function AutoSeg
% AutoSeg  - This function opens a file dialog, loads a image file,
% displays the image in the figure and calls SegmentGC (Main GC Seg Fn)
% Authors - Mohit Gupta, Krishnan Ramnath
% Affiliation - Robotics Institute, CMU, Pittsburgh
% 2006-05-15

% Call built-in file dialog to select image file
[filename,pathname]=uigetfile('images/*.*','Select image file');

% Load  Image file
longfilename = strcat(pathname,filename);
Im = imread(longfilename);

% Main GrabCut Segmentation Function
[SegNewImage] = grabCut(ImName);