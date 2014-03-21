% Script to demonstrate the use of the imflip.c mex file provided as an
% example.
%
% Alex Hartov, 12/26/08

im=imread('cameraman.tif'); % Part of Matlab demo images
% In the following, data type conversion does not change the values.
% However, you should remember that acceptable pixel vlaues for images
% change with data types.  uint8 is 0 to 255, uin16 is 0 to 65535, double
% is 0.0 to 1.0, etc.
im2=double(im); % data type conversion, note image should be 0.0 to 1.0
max(im2(:))     % which is not the case
B=imflip(im2);  % but imflip fixes that
max(B(:))       % as can be verified here
whos            % Check all variables loaded and data types

figure(1)       % Disploay both images side by side
subplot(121);
imshow(im);
axis image
title('Orignial image');
subplot(122);
imshow(B);
axis image
title('L/R flipped image');

imflip(im);     % Error, uint8 not supported in this program 