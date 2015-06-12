function [ alpha ] = dir_param( data,  dim)
%DIR_PARAM Method of moments estimator for Dirichlet Distribution. 
%   See Minka for more details



    
    %data(:, 1:dim) = data(:, 1:dim) + .3;
    %data = data(sum(data ~= 0,2 ) >= size(data, 2), :); %remove zeros
    %normalize
    data2 = data(:, 1:dim);
    counts = data(:, dim+1);
    N = sum(counts);
    data2 = bsxfun(@times, data2, 1./(sum(data2, 2)));
    
    e1 = sum(data2 .* repmat(counts, 1, size(data2, 2)))' /sum(counts) ;
    e2 = sum((data2 .^ 2).* repmat(counts, 1, size(data2, 2)))' / sum(counts);
    i = 1;
    es = (e1(i) - e2(i)) / (e2(i) - e1(i)^2);
    alpha = e1 * es;
    
%     
%     data2 = log(data2);
%     C =  sum(data2.* repmat(counts, 1, size(data2, 2)))'; %sufficient statistics
%     
%     for iter=1:10
%        grad = gradient(alpha, C, N);
%        hess = hessian(alpha, N);
%        step  = hess\grad;
%        alpha = alpha - step;
% %        display(iter);
% %        display(grad);
% %        display(alpha);
% %        display('******************');
%     end
    

end

%function [grad] = gradient(alpha, C, N)
%    
%    grad = -C + N * psi(alpha);
%    grad = grad - N * psi(sum(alpha));
%end
%
%function [hess] = hessian(alpha, N)
%    vec =  N * psi(1, alpha);
%    z =  -N * psi(1, sum(alpha));
%    hess = diag(vec) + z * ones(size(alpha)) * ones(size(alpha))' ;
%end
