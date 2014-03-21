function scores = GMMExpectation(X, k, means, covariances, mcoefficients)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Assign each point in X a score for each Gaussian (cluster), k.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% > Note: a possible error with computing covariances is fixed by adding this
% small value and recomputing the cov. 
covDataFix = 0.0000001;

% Allocate space for scoring (each pt. has a 'score' representing how likely it
% is that it belongs to one of the k clusters). 
scores = zeros(size(X,1), k); 

% For each cluster...
sum_y = 0;
for c=1:k
    
    % Compute the normal distribution for point i with cluster c data
    % > Note: we could just add the covDataFix first and never wait for
    %   the error to crop up - if we are modifying the covariance for each
    %   cluster than every data pt. is treated equally...
    try
        Y = mvnpdf(X, means(c,:), covariances{c,:});
    catch error
        covariances{c,:} = covariances{c,:} + covDataFix;
        Y = mvnpdf(X, means(c,:), covariances{c,:});
    end
    
    % Multiply distribution value by the mixture coefficient (m*Y).
    Ym = mcoefficients(c) * Y;
    
    % Update the sum (each point has it own sum) - you are summing the point across the k-clusters
    sum_y = sum_y + Ym;
    
    % Compute the total cluster's assignment score for the current point
    scores(:, c) = Ym;
    
end

%for each point, you have 1 sum_y (which must be used for the score of that point in each cluster
sum_y = kron(sum_y, ones(1,k));

% Normalize each score by dividing through by sum_y
scores = scores./sum_y;

end

