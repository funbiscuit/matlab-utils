function [h,p,ksstat,cv] = kstestm(x,varargin)
[h,p,ksstat,~] = kstest(x,varargin{:});
% fprintf('Raw: h=%d,p=%f,ks=%f,cv=%f\n',h,p,ksstat,cv);
% kstest returns actual sup(abs(Fn-F)) in ksstat and uses
% normalised value for cv instead of usual Kalpha

% recalculate Kalpha from Kolmogorov statistic and scale ksstat
N=length(x);
ksstat=ksstat*sqrt(N)+1/(6*sqrt(N));


parser = inputParser;
parser.KeepUnmatched = true;
addOptional(parser,'alpha',0.05);
parse(parser,varargin{:});

alpha=parser.Results.alpha;
% 1e3 values is enough for Ka>0.1
Nsum=1e3;
FZ=@(Ka) -alpha+2*sum((-1).^(0:Nsum-1).*exp(-2*(1:Nsum).^2*Ka^2));
cv=fzero(@(Ka) FZ(Ka), 1);
