function [ p ] = log_pdf2( x, s, alpha )
%LOG_PDF log of probability mass for d-dimensional case
    if (all (x == 0))
        p = NaN;
    else
        t = 1/(1-s);
        p = log(t) + betaln(sum(x), 1+t);
        p = p + gammaln(sum(alpha)) + gammaln(1+sum(x)) - gammaln(sum(alpha) + sum(x));
        d = length(alpha);
        for i=1:d
          p = p + gammaln(x(i) + alpha(i)) - gammaln(alpha(i)) - gammaln(1+x(i));
        end
    end
end
