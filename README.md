FaceID
===========
FaceID is a Computer Vision project done in the Fall of 2013 for Computer Science 183 @ Dartmouth College.

Description
--
computeGaussianProb.m

> Given the input image, and a Gaussian model (specified by u and cov), this function computes the prob. of each pixel in x belonging to the gaussian

getGaussianModelParams.m

> Given skin/non-skin training data, this function generates a Single Gaussian Model and outputs the mean and covariance of the model

getROIColors.m

> This function allows the user to contour a figure and outputs the RGB values of the contoured regions in a colorLookup table

GMMEM.m

> Initiate the Expectation-Maximization algorithm to compute model parameters for the Gaussian Mixture Model.

GMMExpectation.m

> Assign each point in X a score for each Gaussian (cluster), k.

GMMMaximization.m

> Given a score for each point in X, adjust the mean, variance, and mixture coefficient for each Gaussian (cluster), k. 

GMMLogLikelihood.m

> Determine how "good" the current model parameters fit the data.

normalizeRGB.m

> Given an RGB color, compute the normalized value. 

testSkinModels.m

> For an image, this function will use the stored SGM and GMM models to segment the face in the image

trainSkinNonSkin.m

> This function opens up a figure where the user can contour the image and select skin regions; to exit, the user presses any key on the keyboard. The function then presents a figure where the user has to select the non-skin regions

sgm_using_training_data.m

> Compute the model parameters for the skin and non-skin SGMs.

gmm_using_training_data.m

> Compute the model parameters for the skin and non-skin GMMs.

###Testing the whole system: SIFT + GMM + SGM and classifiers

test_image_against_database.m

> When this file is run, you can select a photo from the database (navigate to lfw_subset and go to a subfolder and pick one of the photos named 1.jpeg, 2.jpeg, 3.jpeg and 4.jpeg).

> The script will compare the photo selected to all the photos in the database.

> It will output saying which person the test subject was matched to in the database using the original image, SGM and GMM

Installation
--

Features
--

TODO
--

Usage
--
System paths in the crawl_database_directories.m & crossValidationTesting.m files will have to be changed to run on your system until the database file path is retrieved in a system-independent fashion. 

Testing (Demo for training the Gaussian Models.)
--
Simply call the 'demo_skin_Models' function in the enclosed folder named GaussianModelSkinDetection and a window will pop up allowing
you to browse your file system - pick a file. 

A window will appear with the image displayed and ask you to define contours 
that represent 'skin'. In order to do this, click once - the cursor should change. 
You can then click again (but hold down the mouse) and draw a contour - 
release the mouse button when you are satisfied with the contour. You can draw
multiple contours by clicking once more to activate the contour drawing tool and
then draw the contour just as before. Do this as many times as you want. 

Press <enter> when you are done defining 'skin' contours. 

Another image will open and ask you to define contours that represent 
'non-skin' regions - draw contours as described before. 

You will do this process TWICE (once to train the SGM and once to train the 
GMM). 

Once you've done this, the models may take a few minutes to be generated, but
when they are finished you will see a few images pop up that show the predicted
skin regions that the SGM and GMM identified. 

License
--

Co-Author:: Travis Peters <traviswp@gmail.com>
Co-Author:: Haider Syed <haider.syed@dartmouth.edu>

Copyright:: Copyright (c) 2013
License:: Apache License, Version 2.0

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

Credits
--

