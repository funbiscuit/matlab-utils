function [Kcdf] = kdist(x,varargin)
% Returns Kolmogorov distribution for provided x values
% x must be positive

if isempty(x) || ~(isnumeric(x)&&(min(x)>0))
    error('x must be numeric and > 0');
end

parser = inputParser;
% sum up to max terms
addOptional(parser,'MaxTerms',1e4, @(x) isnumeric(x)&&isscalar(x)&&(x>0));
parse(parser,varargin{:});

Nsum=parser.Results.MaxTerms;

FZ=@(Ka) 1-2*sum((-1).^(0:Nsum-1).*exp(-2*(1:Nsum).^2*Ka^2));

N=length(x);
Kcdf=zeros(size(x));
for l=1:N
    Kcdf(l)=FZ(x(l));
end
% can't be zero
Kcdf(Kcdf<0)=0;

