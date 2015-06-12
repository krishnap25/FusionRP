function r = drchrnd(a,n)
    % take a sample from a dirichlet distribution
    if size(a,1) > 1
        a = a';
    end    
    p = length(a);
    r = gamrnd(repmat(a,n,1),1,n,p);
    r = r ./ repmat(sum(r,2),1,p);
end