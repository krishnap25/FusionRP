function vec = MLEnD(param0, data)
%% MLE of dirichlet-multinomial
%% param0: starting guess, provide from dir_param.m
    vec = param0(:);
    dim = length(vec);
    grad = gradient(vec, data, dim);
    iter = 0;
    while ((norm(grad) > 1e-9) && iter < 10)
       vec = vec -  (hessian(vec, data, dim) \ grad);
       grad = gradient(vec, data, dim);
       iter = iter + 1;
       %display([[iter; zeros(dim-1, 1)], [grad], [vec]]);
    end
end

function grad = gradient(vec, data, dim)
    count = data(:, dim+1);
    dp = data(:, 1:dim);
    %disp(vec)
%     temp = sum(count) * (psi(sum(vec))) - ...
%         dot(psi(sum(data, 2) + sum(vec)), count);
%     grad = ones(dim, 1)*temp;
    grad = zeros(dim ,1);
    for i = 1:dim
        grad(i) = dot(psi(data(:, i) + vec(i)), count) - ...
            dot(psi(sum(dp, 2) + sum(vec)), count) + ...
            sum(count) * (psi(sum(vec)) - psi(vec(i)));
    end
%     disp(grad)
end

function hess = hessian(vec, data, dim)
    count = data(:, dim+1);
    dp = data(:, 1:dim);
    temp = sum(count) * psi(1, sum(vec)) - ...
                        dot(count, psi(1, sum(dp, 2) + sum(vec)));
    hess = ones(dim) * temp;
    %hess = zeros(dim);
    for i = 1:dim
       hess(i,i) = temp + dot(psi(1, data(:,i) + vec(i)), count) - ...
        sum(count) *  psi(1, vec(i));
    end
     
% %     for i = 1:dim
% %         for j=i+1:dim
% %             hess(i, j) = temp;
% %             hess(j, i) = temp;
% %         end
% %     end
%     disp(hess);
end