clear
clc

rng('shuffle')

grid = [1000, 1000]; % in m
bs_count = 64;
mec_count = 16;
mec_clock = 4*2.6; % GHz

uplink_bandwidth_4g = 10; % in MHz
uplink_bandwidth_5g = 200; % in MHz

downlink_bandwidth_4g = 10; % in MHz
downlink_bandwidth_5g = 200; % in MHz

backhaul_bandwidth_4g = 20; % in MHz
backhaul_bandwidth_5g = 1000; % in MHz

uplink_carrier_frequency_4g = 3.7; % in GHz 
uplink_carrier_frequency_5g = 40; % in GHz 

downlink_carrier_frequency_4g = 3.3; % in GHz
downlink_carrier_frequency_5g = 28; % in GHz

backhaul_carrier_frequency_4g = 4.5; % in GHz
backhaul_carrier_frequency_5g = 60; % in GHz

uplink_power = 23; % in dBm
downlink_power = 30; % in dBm
backhaul_power = 40; %in dBm

noise_spectral_density = -174; % in dBm/Hz

user_count = 200;

req_size = 10; % in MB

BS = BaseStationsSetup(grid, 16, bs_count, mec_count, mec_clock, ...
    uplink_bandwidth_4g, uplink_bandwidth_5g, ...
    downlink_bandwidth_4g, downlink_bandwidth_5g, ...
    backhaul_bandwidth_4g, backhaul_bandwidth_5g, ...
    uplink_carrier_frequency_4g, uplink_carrier_frequency_5g, ...
    downlink_carrier_frequency_4g, downlink_carrier_frequency_5g, ...
    backhaul_carrier_frequency_4g, backhaul_carrier_frequency_5g, ...
    uplink_power, downlink_power, backhaul_power, noise_spectral_density);

BS = calculateRadii(BS, ...
    uplink_power, downlink_power, backhaul_power, ...
    uplink_carrier_frequency_4g, downlink_carrier_frequency_4g, backhaul_carrier_frequency_4g, ...
    uplink_carrier_frequency_5g, downlink_carrier_frequency_5g, backhaul_carrier_frequency_5g, ...
    uplink_bandwidth_4g, uplink_bandwidth_5g, ...
    downlink_bandwidth_4g, downlink_bandwidth_5g, ...
    backhaul_bandwidth_4g, backhaul_bandwidth_5g, ...
    noise_spectral_density);


  %----- test 10:  -----%

avg = [];


[avg(1,1), avg(1,2), avg(1,3), avg(1,4), avg(1,5)] = runSimulation_CutOutliers(25, BS, user_count, grid, req_size);

[avg(2,1), avg(2,2), avg(2,3), avg(2,4), avg(2,5)] = runSimulation(25, BS, user_count, grid, req_size);


figure(1)

avg(:,5) = [];
figure(1)
names = {'50 disconnected'; 'None disconnected'};
bar(avg, 'stacked');
set(gca,'xtick', 1:2,'xticklabel',names)
ylabel('Latency (in s)')
legend({'uplink', 'processing', 'downlink', 'backhaul'},'Location','northeast')
title('Average Total Delay when Disconnecting Users')
hold off



figure(2)
x = [1 2];
plot(x, avg(1:2,:))
legend({'uplink', 'processing', 'downlink', 'backhaul'},'Location','northeast')
title('Delay Ratio Trend When Disconnecting Users')
xlabel('All connected vs Not all connected') 
ylabel('Latency (in s)') 
hold off
   %-------------------------------------------------%