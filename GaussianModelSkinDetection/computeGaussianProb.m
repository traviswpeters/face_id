function p_x = computeGaussianProb(x, u, cov)

%Given the input image, and a Gaussian model (specified by u and cov), 
%this function computes the prob. of each pixel in x belonging to the gaussian 

%Inputs: 
%x - is a 2D image in normalized rgb space; we are going to compute a probability for each pixel in the image... 

%u - mean for the gaussian distribution model
%cov - covariance matrix for the gaussian distribution model

%Outputs:
%p_x - probability of x

%Create Gaussian Model and compute probability
d = size(x,1); %dimensionality of x
F = (1/((2*pi)^(d/2)))*(1/(det(cov)^0.5)); %Constant Factor (this is a scalar factor)
p_x = F*exp( -0.5*(x-u)'*(cov\(x-u)) ); %probability of x