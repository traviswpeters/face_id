function [new_means, new_covariances, new_mcoefficients ] = GMMMaximization(X, k, scores)%, means, covariances, mcoefficients)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Given a score for each point in X, adjust the mean, variance, and 
% mixture coefficient for each Gaussian (cluster), k. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Update the cluster data for each cluster...
for c = 1:k
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Compute new cluster mean         %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Compute the cluster's scores * datapoints
    %sum([scores(:,c).*X(:,1) scores(:,c).*X(:,2)])./sum(scores(:,c))
%    nkx = 0;
%     for i = 1:size(X,1)
%         nkx = nkx + (scores(i,c) * X(i,:));
%     end
%     
    nkx = sum(kron(scores(:,c),ones(1, 2)) .* X);
    
    % Store the new mean
    new_means(c,:) = nkx / sum(scores(:,c));
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Compute new covariance ***       %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % TODO: CHECK covariance stuff...
%     nkx = zeros(2,2);
%     for i = 1:size(X,1)
%         deltaX = (X(i,:) - new_means(c,:));
%         %xxp = deltaX * deltaX';
%         xxp = deltaX' * deltaX;
%         nkx = nkx + (scores(i,c) * xxp);
%     end
%    
%     % Store the new covariance
%     sk = nkx / sum(scores(:,c));

    deltaX = X - kron(new_means(c,:), ones(size(X,1), 1));
    sqrtScore = kron(sqrt(scores(:,c)), ones(1,2));
    deltaX = sqrtScore.*deltaX;
    xxp = deltaX' * deltaX;
    sk = xxp / sum(scores(:,c)); %cov
    
    new_covariances{c,:} = sk;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Compute new mixture coefficients %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    new_mcoefficients(c,1) = sum(scores(:,c)) / size(X,1);
    
end

end

