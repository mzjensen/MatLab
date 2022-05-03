% retrieve the XYZ acceleration data and timestamps from mobiledev object
[a, t] = accellog(m);

% calculate magnitude of acceleration by converting XYZ acceleration
% vectors into scalar values
x = a(:,1);
y = a(:,2);
z = a(:,3);
mag = sqrt(sum(x.^2 + y.^2 + z.^2, 2));

% subtract mean from the data to remove any constant effects
magNoG = mag - mean(mag);

% do an FFT on this time domain function
% fft_results contains a complex number pair for each sample
fft_results = fft(a);

number_time_samples=numel(t);
sampling_rate=10;

% create the x axis for frequencies
% ctart at DC value (0 Hz)
dc_value=0;

% we only need to plot the first half of the frequencies because the fft returns
% the same data folded over on itself at maxfreq/2
% frequency spacing is the sampling rate / by the number of samples
freq_spacing = (sampling_rate/number_time_samples)*5;

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

% plot frequencies using red circles, as well as raw acceleration data
subplot(2,1,1);
plot(t, magNoG);
title('Phone Acceleration While Taking Pictures');
xlabel('Time (s)');
ylabel('Acceleration (m/s^2)');
grid on;
subplot(2,1,2);
plot(freq_plot_xaxis(1:n),nor_magnitude(1:n),'ro');
title('Frequency Domain Function');
xlabel('Frequency (Hz)');
ylabel('Normalized Magnitude');
grid on;
