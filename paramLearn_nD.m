function [ start_prob, alphas, data ] = paramLearn_nD( filename, dim )
%Learn all parameters of FusionRP
%   dim: dimensionality of data

    data = dlmread(filename);
    %data = load(filename); data = data.data;
    data2 = data(:, 1:dim);
    counts = data(:, dim+1);
    
    len = sum(counts);
    N = dot(sum(data2, 2), counts);
    start_prob = len / N;
    
    alpha0 = dir_param(data, dim);
    alphas = MLEnD(alpha0, data);


end

