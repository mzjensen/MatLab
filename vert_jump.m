% retrieve the vertical position and time data from .csv file
y=csvread('position.csv');
t=csvread('time.csv');

% do an FFT on this time domain function
% fft_results contains a complex number pair for each sample
fft_results = fft(y);

number_time_samples=numel(t);
sampling_rate=60;

% create the x axis for frequencies
% ctart at DC value (0 Hz)
dc_value=0;

% we only need to plot the first half of the frequencies because the fft returns
% the same data folded over on itself at maxfreq/2
% frequency spacing is the sampling rate / by the number of samples
freq_spacing = (sampling_rate/number_time_samples);

% maximum frequency for the fft is (sampling rate/2)
freq_max = (sampling_rate/2) - freq_spacing;

% Now create the x-axis points
freq_plot_xaxis = dc_value:freq_spacing:freq_max;

number_freq_samples = number_time_samples/2;

% the magnitude of the fft must be computed from the fft_results
magnitude = abs(fft_results);

% magnitude must be normalized by dividing by the number of frequency samples
nor_magnitude = magnitude/number_freq_samples;

% get number of frequencies
n=numel(freq_plot_xaxis);

% plot frequencies using red circles, as well as raw data
subplot(2,1,1);
plot(t, y);
title('Raw Position Data for Vertical Jump');
xlabel('Time (s)');
ylabel('Vertical Position (cm)');
grid on;
subplot(2,1,2);
plot(freq_plot_xaxis(1:n),nor_magnitude(1:n),'ro');
title('Frequency Domain Function');
xlabel('Frequency (Hz)');
ylabel('Normalized Magnitude');
grid on;
