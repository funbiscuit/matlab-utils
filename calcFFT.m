function [Xf, f] = calcFFT(t,x)
%CALCFFT Calculate fft of time series, return shifted result with freqs

freq=1/(t(2)-t(1));

N=length(x);
f=(-N/2:(N/2-1))/N*freq;
Xf = fftshift(fft(x))/N;

end

