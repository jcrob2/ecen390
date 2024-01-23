%% Setup
clc, clear, close all;
% Player center frequencies in H
f_players = [1471, 1724, 2000, 2273, 2632, 2941, 3333, 3571, 3846, 4167];
denoms = zeros(11,10);
nums = zeros(11,10);
f_s = 10000; % sampling frequency (remember we have decimated)
BW = 50; % Full bandwidth of filters in Hz

%% Create Filters
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

   
   %plot(f_axis, abs(H1)); % magnitude of the frequency response
    
   %plot the response in dB
   H_db = 20 * log10(abs(H1));
   plot(f_axis, H_db);
end

%% SAVE NUMERATORS AND DENOMINATORS
a_iir = transpose(denoms);
b_iir = transpose(nums);

%% save the files
save a1.txt a_iir -ascii -double;
save b1.txt b_iir -ascii -double;

%% Set up Square wave

Fs = 10e3;                   % The sampling frequency
t = linspace(0, 0.2, 2000);  % The time vector with a length of 0.2 seconds and 2000 total samples
freq = 1471;                 % The frequency of player 1
data_vect = zeros(2000,10);
energy_vals = zeros(10,10);

data_vect(:,1) = square(2*pi*f_players(1)*t);     % Create the time domain square waves
data_vect(:,2) = square(2*pi*f_players(2)*t); 
data_vect(:,3) = square(2*pi*f_players(3)*t); 
data_vect(:,4) = square(2*pi*f_players(4)*t); 
data_vect(:,5) = square(2*pi*f_players(5)*t); 
data_vect(:,6) = square(2*pi*f_players(6)*t); 
data_vect(:,7) = square(2*pi*f_players(7)*t); 
data_vect(:,8) = square(2*pi*f_players(8)*t); 
data_vect(:,9) = square(2*pi*f_players(9)*t); 
data_vect(:,10) = square(2*pi*f_players(10)*t); 

%% Calculate Energies through Filters
for i = 1:10
   sample = data_vect(:,i);
   for j = 1:10
       num = nums(:,j);
       denom = denoms(:,j);
       filtered = filter(num, denom, sample);
       energy_vals(i, j) = sum(abs(filtered).*abs(filtered));
   end
end

%% plot only first filter
figure;
bar(energy_vals(1,:));

%% plotting all 10 energy signals
figure;
for i = 1:10
    subplot(10,1,i);
    bar(energy_vals(i,:));
    xlabel("Filter Number");
    ylabel("Energy Of Signal");
    title("Signal" + i);
end

