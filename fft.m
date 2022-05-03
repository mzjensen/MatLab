% FFT Example
% Revision 2.1 Brennan Stanyer and Zachri Jensen  2/6/2017

% Creates functions of time and explores various fft implementations

close all; clear all; clc;
clear plot;
sampling_rate = 10000;
number_time_samples=10000;

% Get data from PCI breadboard thing-a-ma-jigger
[d,t]=msgets0(sampling_rate,number_time_samples);
d=d*5/32768;
msstop;

% Now do an FFT on this time domain function
% fft_results contains a complex number pair for each sample 
fft_results = fft(d);

% Create the x axis for frequencies
% Start at DC value (0 Hz)
dc_value = 0;

% We only need to plot the first half of the frequencies because the fft returns
% the same data folded over on itself at maxfreq/2
% Frequency spacing is the sampling rate / by the number of samples
freq_spacing = (sampling_rate/number_time_samples)*10;

% Maximum frequency for the fft is (sampling rate/2) – delta_freq
freq_max = (sampling_rate/2) - freq_spacing;

% Now create the x-axis points
freq_plot_xaxis = dc_value:freq_spacing:freq_max;

% This results in (number of time samples/2) or 500 frequencies
number_freq_samples = number_time_samples/2;

% The magnitude of the fft must be computed from the fft_results
magnitude = abs(fft_results);

% Magnitude must be normalized by dividing by the number of frequency samples
nor_magnitude = magnitude/number_freq_samples;

% Plot the first 50 frequencies using red circles
subplot(3,1,1);
plot(freq_plot_xaxis(1:100),nor_magnitude(1:100),'ro');
axis([0, 500, 0,.02]);
title('Frequency Domain Function');
xlabel('Frequency (Hz)');
ylabel('Normalized Magnitude (V)');
subplot(3,1,2);
plot(freq_plot_xaxis(1:100),nor_magnitude(1:100),'ro');
axis([500, 800, 0,.006]);
title('Frequency Domain Function');
xlabel('Frequency (Hz)');
ylabel('Normalized Magnitude (V)');
subplot(3,1,3);
plot(t,d);
title('Time Domain Function');
ylabel('Voltage (V)');
xlabel('Time (s)');
grid on;
