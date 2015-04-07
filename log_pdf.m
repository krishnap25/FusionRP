function [ p ] = log_pdf( x, y, s, a, b )
%LOG_PDF log of probability mass for 2-D case
% (a,b) -> parameters of beta distribution
    if (x == 0 && y == 0)
        p = NaN;
    else
        p = -log(1-s) - log(x+y+1);
        t = 1/(1-s);
        p = p + betaln(x+y, 1+t) + betaln(x+a, y+b);
        p = p - betaln(x+1, y+1) - betaln(a, b);
    end
end

