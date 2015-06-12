%% Set up parameters
N=100000;                
original_s=0.1;
original_alpha=[1.1, 0.9];
dim = length(original_alpha); %dimensionality
%% Generate and save synthetic data
data = gen_synthetic_data(N, original_s, original_alpha);
filename = 'sample_data'
dlmwrite(filename, data);
%%Learn parameters
[s, alpha, data] = paramLearn_nD(filename, dim)
display(sprintf('Parameters learnt are: s = %f and \n', s));
display(alpha)
%plot_contours of data
plotcon(data, 'real_contours', '', 0);
% plot contours analytically
plotcon_syn(s, alpha(1), alpha(2), 0);


