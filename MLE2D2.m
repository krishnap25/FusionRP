function vec = MLE2D2(param0, data)
    a0 = param0(1); b0 = param0(2);
    x = data; 
    vec = [a0; b0];
    grad = gradient(vec, data);
    iter = 0;
    while ((norm(grad) > 1e-20) && iter < 20)
       vec = vec -  hessian(vec, data) \ grad;
       grad = gradient(vec, data);
       iter = iter + 1;
       %display([[iter; 0], [grad], [vec]]);
    end
end

function grad = gradient(vec, data)
    males = data(:, 1); females = data(:, 2); count = data(:, 3);
    a = vec(1); b = vec(2);
    grad = zeros(2, 1);
    temp1 = dot(psi(males + a), count) - ...
        dot(psi(males + females + a + b), count) + ...
        sum(count) * (psi(a+b) - psi(a));
    grad(1) = temp1;
    grad(2) = dot(psi(females + b), count) - ...
        dot(psi(males + females + a + b), count) + ...
        sum(count) * (psi(a+b) - psi(b));
    %disp(grad);
end

function hess = hessian(vec, data)
    males = data(:, 1); females = data(:, 2); count = data(:, 3);
    a = vec(1); b = vec(2);
    hess = zeros(2);
    hess(1,1) = dot(psi(1, males + a), count) - ...
        dot(psi(1, males + females + a + b), count) + ...
        sum(count) * (psi(1, a+b) - psi(1, a));
    hess(2,2) = dot(count, psi(1, females + b)) - ...
        dot(count, psi(1, males + females + a + b)) + ...
        sum(count) * (psi(1, a+b) - psi(1, b));
    hess(1, 2) = sum(count) * psi(1, a+b) - ...
        dot(count, psi(1, males + females + a + b));
    hess(2, 1) = hess(1,2);
%     disp(hess);
end