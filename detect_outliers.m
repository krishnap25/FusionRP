function [  ] = detect_outliers( filename, dim)
%DETECT_OUTLIERS Detect outliers by poisson approximation
%   Refer to paper for details
    
    %estimate params
    option = 1;
    display(filename);
    [start_prob, param1, N, data] = paramLearn_nD(filename, dim);
    n = sum(data(:, dim+1));
    %detect outliers
    nout = 0;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Method is which method to use:
    %1: exact(chi square inverse)
    %2:continuity corrected wald
    %3: wh
    method = 2; 
    for i=1:size(data, 1);
        %logp = log_pdf(data(i, 1), data(i, 2), start_prob, param1(1), param1(2));
        logp = log_pdf2(data(i, :), start_prob, param1);
        lambda = exp(log(n) + logp);
        x = data(i, dim+1);
        alpha = 0.01;
        if (method == 1) % Exact hypothesis test
            lower = chi2inv(alpha/2, 2*data(i,dim+1))/2;
            upper = chi2inv(1-alpha/2, 2+2*data(i,dim+1))/2;
        elseif (method == 2) % Continuity corrected wald test
            za = norminv(1-alpha/2); % z_alpha
            lower = x-0.5 - za* sqrt(x-0.5);
            upper = x+0.5+ za * sqrt(x+0.5);
        elseif (method == 3)
            za = norminv(1-alpha/2);
            lower = x* (1- 1/(9*x) - za/(3*sqrt(x)))^3;
            upper = x* (1- 1/(9*x+9) + za/(3*sqrt(x+1)))^3;
            
        end
        if ~(lambda >= lower && lambda <= upper)
        %if ~(data(i, 3) >= floor(lower)-1 && data(i,3) <= ceil(upper) + 1)
            fprintf('%d\t', data(i, 1:dim));
            fprintf('%d\t', data(i, dim+1));
            fprintf('%f\t', [ lambda, lower, upper]);
            fprintf('\n');
            nout = nout + 1;
        end
    end
    display(sprintf('%d outliers out of %d' ,nout, size(data, 1)));
end

% function [  ] = detect_outliers( filename)
% %DETECT_OUTLIERS Detect outliers by poisson approx
% %   Detailed explanation goes here
%     
%     %estimate params
%     display(filename);
%     [start_prob, param, N, data] = beta_param(filename, 1);
%     n = sum(data(:, 3));
%     param1 = MLEnD(param, data);
%     %param1 = [0.0599; 4.8673];
%     %detect outliers
%     nout = 0;
%     
%     type = 1;
%     
%     for i=1:size(data, 1);
%         logp = log_pdf(data(i, 1), data(i, 2), start_prob, param1(1), param1(2));
%         if (type == 1)
%             lambda = exp(log(n) + logp);
%             alpha = 1e-7;
%             za = norminv(1-alpha/2);
%             pl = poissinv(alpha/2, lambda);
%             pu = poissinv(1-alpha/2, lambda);
%     %         lower = lambda - za* sqrt(lambda);
%     %         upper = lambda + za * sqrt(lambda);
%              lower = pl;
%              upper = pu;
%             if ~(data(i, 3) >= floor(lower)-1 && data(i,3) <= ceil(upper) + 1)
%                 nout = nout + 1;
%                 disp([data(i,1:2) data(i, 3)]);
%                 disp([lambda upper]);
%                 disp('**********');
%             end
%         else
%             lambda = exp(logp);
%             alpha = 1e-7;
%             za = norminv(1-alpha/2);
%             pl = poissinv(alpha/2, lambda);
%             pu = poissinv(1-alpha/2, lambda);
%     %         lower = lambda - za* sqrt(lambda);
%     %         upper = lambda + za * sqrt(lambda);
%              lower = pl;
%              upper = pu;
%             if ~(data(i, 3)/n >= lower && data(i,3) <= upper)
%                 nout = nout + 1;
%             end
%         end
%     end
%     display(sprintf('%d outliers out of %d' ,nout, size(data, 1)));
% 
% end
% 
