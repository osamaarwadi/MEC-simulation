clear
clc

rng('shuffle')

grid = [1000, 1000]; % in m
bs_count = 128;
mec_count = 64;
mec_clock = 4*2.6; % GHz

uplink_bandwidth_4g = 10; % in MHz
uplink_bandwidth_5g = 200; % in MHz

downlink_bandwidth_4g = 10; % in MHz
downlink_bandwidth_5g = 200; % in MHz

backhaul_bandwidth_4g = 20; % in MHz
backhaul_bandwidth_5g = 1000; % in MHz

uplink_carrier_frequency_4g = 2.6; % in GHz 
uplink_carrier_frequency_5g = 28; % in GHz 

downlink_carrier_frequency_4g = 2.6; % in GHz
downlink_carrier_frequency_5g = 28; % in GHz

backhaul_carrier_frequency_4g = 3.4; % in GHz
backhaul_carrier_frequency_5g = 60; % in GHz

uplink_power = 23; % in dBm
downlink_power = 30; % in dBm
backhaul_power = 40; %in dBm

noise_spectral_density = -174; % in dBm/Hz

user_count = [50, 100, 150, 200, 250];

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



  %----- test 1:  -----%
avg = [];
[avg(1,1), avg(1,2), avg(1,3), avg(1,4), avg(1,5)] = runSimulation(10, BS, user_count(1), grid, req_size);

[avg(2,1), avg(2,2), avg(2,3), avg(2,4), avg(2,5)] = runSimulation(10, BS, user_count(2), grid, req_size);

[avg(3,1), avg(3,2), avg(3,3), avg(3,4), avg(3,5)] = runSimulation(10, BS, user_count(3), grid, req_size);

[avg(4,1), avg(4,2), avg(4,3), avg(4,4), avg(4,5)] = runSimulation(10, BS, user_count(4), grid, req_size);

[avg(5,1), avg(5,2), avg(5,3), avg(5,4), avg(5,5)] = runSimulation(10, BS, user_count(5), grid, req_size);

ratio_uplink = [];
ratio_processing = [];
ratio_downlink = [];
ratio_backhaul = [];

for i =1:5
    ratio_uplink(i) = avg(i,1)/avg(i,5);
    ratio_processing(i) = avg(i,2)/avg(i,5);
    ratio_downlink(i) = avg(i,3)/avg(i,5);
    ratio_backhaul(i) = avg(i,4)/avg(i,5);
end
avg(:,5) = [];
figure(1)
bar(user_count, avg, 'stacked');
legend({'uplink delay', 'processing delay', 'downlink delay', 'backhaul delay'},'Location','northeast')
title('Average Delays vs Increasing # of Users')
xlabel('# of Users') 
ylabel('Latency (in s)') 
hold off

figure(2)
plot(user_count, ratio_uplink);
hold on
plot(user_count, ratio_processing);
hold on
plot(user_count, ratio_downlink);
hold on
plot(user_count, ratio_backhaul);
legend({'uplink ratio', 'processing ratio', 'downlink ratio', 'backhaul ratio'},'Location','northeast')
title('Average Ratios vs Increasing # of Users')
xlabel('# of Users') 
ylabel('Individual:Overall Latency Ratio') 
hold off

   %-------------------------------------------------%

% U = UsersSetup(user_count(1), grid, req_size);
% 
% U = uplink_greedy(U, BS);
% [U, bs_in_range_5g, bs_in_range_4g] = downlink_greedy(U, BS);
% U = backhaul(U, BS);
% U = calculateTotalLatency(U);
% [overall_uplink, overall_processing, overall_downlink, overall_backhaul, overall_total] = calculateOverallLatency(U);
% [avg_uplink, avg_processing, avg_downlink, avg_backhaul, avg_total] = calculateAverageOverallLatency(overall_uplink, overall_processing, overall_downlink, overall_backhaul, overall_total, user_count(1));
% U = calculateLatencyRatio(U, avg_uplink, avg_processing, avg_downlink, avg_backhaul, avg_total);

% BS2 = BS;
% BS2(1) = [];
% U2 = uplink_6(U, BS2);
% U2 = downlink(U2, BS2);
% U2 = backhaul(U2, BS2);
% overall2 = calculateOverallLatency(U2);
% [overall_uplink_2, overall_processing_2, overall_downlink_2, overall_backhaul_2, overall_total_2] = calculateOverallLatency(U2);
% [avg_uplink_2, avg_processing_2, avg_downlink_2, avg_backhaul_2, avg_total_2] = calculateAverageOverallLatency(overall_uplink_2, overall_processing_2, overall_downlink_2, overall_backhaul_2, overall_total_2, user_count);
% U2 = calculateLatencyRatio(U2, avg_uplink_2, avg_processing_2, avg_downlink_2, avg_backhaul_2, avg_total_2);

% BS3 = BS2;
% BS3(4) = [];
% U3 = uplink(U, BS3);
% overall3 = calculateOverallLatency(U3);

  %----- graphing -----%

% graph og(1) and post mec(2) optimisation
% figure(1);
% plotUsers(U);
% hold on
% plotBaseStations(BS);
% hold off
