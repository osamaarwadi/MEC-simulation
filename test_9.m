clear
clc

rng('shuffle')

grid = [1200, 1200]; % in m
bs_count = 128;
mec_count = 32;
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

user_count = 250;

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

BS_5g = BS;
BS_4g = BS;

for i = 1:length(BS)
    BS_4g(i).is_5g = false;
    BS_5g(i).is_4g = false;
end

  %----- test 9:  -----%

avg = zeros(1,3);
dis= zeros(1,3);

[avg(1), dis(1)] = runSimulationDisconnections(50, BS, user_count, grid, req_size);

[avg(2), dis(2)] = runSimulationDisconnections(50, BS_4g, user_count, grid, req_size);

[avg(3), dis(3)] = runSimulationDisconnections(50, BS_5g, user_count, grid, req_size);

figure(1)

names = {'4G & 5G'; '4G only'; '5G only'};
scatter([1,2,3], avg, "filled");
set(gca,'xtick', 1:3,'xticklabel',names)
xlabel('Wireless Technology')
ylabel('Latency (in s)')
legend({'uplink delay'},'Location','northeast')
title('Uplink Delay with Different Wireless Technologies')
hold off


dis = dis*100/user_count;
figure(2)
names = {'4G & 5G'; '4G only'; '5G only'};
bar(dis)
set(gca,'xtick', 1:3,'xticklabel',names)
xlabel('Wireless Technology')
ylabel('Disconnected Users')
legend({'users'},'Location','northeast')
title('Disconnected Users % with Different Wireless Technologies')
hold off

   %-------------------------------------------------%