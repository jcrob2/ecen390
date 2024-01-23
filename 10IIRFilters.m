%% Setup
clc, clear, close all;
% Player center frequencies in H
f_players = [1471, 1724, 2000, 2273, 2632, 2941, 3333, 3571, 3846, 4167];
denoms = zeros(11,10);
nums = zeros(11,10);
f_s = 10000; % sampling frequency (remember we have decimated)
BW = 50; % Full bandwidth of filters in Hz

%% 3.1
figure;
hold on;
for i = 1:10
   f_lower = f_players(i) - BW/2; % Lower corner frequency of BPF
   f_upper = f_players(i) + BW/2; % Upper corner frequency of BPF
   [b1, a1] = butter(5, [f_lower*2/f_s, f_upper*2/f_s]);
   nums(:, i) = b1;
   denoms(:, i) = a1;
   % IMPORTANT: ‘butter’ takes frequency specifications in half cycles/sample,
   % not Hz, hence the division by f_s and multiplication by 2
   f_axis = linspace(1000, 4500, 2000); % create a freq axis from 1 to 4.5 kHz
   H1 = freqz(b1, a1, f_axis, f_s); % calculates the freq response H1
   % at the frequencies in f axis
   plot(f_axis, abs(H1)); % magnitude of the frequency response
end

hold off;
xlabel("Frequency (Hz)");
ylabel("Magnitude");
title("Frequency Respsonses");
legend("1471 Hz", "1724 Hz", "2000 Hz", "2273 Hz", "2632 Hz", "2941 Hz", "3333 Hz", "3571 Hz", "3846 Hz", "4167 Hz")