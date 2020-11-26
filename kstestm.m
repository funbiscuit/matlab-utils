function [h,p,ksstat,cv,difStat] = kstestm(x,varargin)
[h,p] = kstest(x,varargin{:});
% fprintf('Raw: h=%d,p=%f,ks=%f,cv=%f\n',h,p,ksstat,cv);
% kstest returns actual sup(abs(Fn-F)) in ksstat and uses
% normalised value for cv instead of usual Kalpha
% we calculate ksstat and cv from scratch since we need to return index of
% maximal deviation from cdf

% recalculate Kalpha from Kolmogorov statistic and scale ksstat
N=length(x);

parser = inputParser;
parser.KeepUnmatched = true;
addOptional(parser,'alpha',0.05);
addOptional(parser,'cdf',makedist('normal'));
parse(parser,varargin{:});

alpha=parser.Results.alpha;
% 1e3 values is enough for Ka>0.1
Nsum=1e3;
FZ=@(Ka) -alpha+2*sum((-1).^(0:Nsum-1).*exp(-2*(1:Nsum).^2*Ka^2));
cv=fzero(@(Ka) FZ(Ka), 1);

% find where deviation is maximal
ec=sort(x);
[ecd, ecdx]=ecdf(x);
nc=cdf(parser.Results.cdf,ec);
%fixme doesn't work if x contains repeating values
[s1,i1]=max(abs(ecd(2:end)-nc));
[s2,i2]=max(abs(ecd(1:end-1)-nc));
ksstat=max(s1,s2)*sqrt(N)+1/(6*sqrt(N));

difStat.dist=max(s1,s2);

if s1>s2
    difStat.x=ecdx(i1+1);
    difStat.y=ecd(i1+1);
else
    difStat.x=ecdx(i2+1);
    difStat.y=ecd(i2);
end
