function Users = backhaul(Users, Basestations)
% Variable conversion
users = [];
basestations = [];

for i = 1:length(Users)
    users.x(i) = Users(i).x;
    users.y(i) = Users(i).y;
    users.req_size(i) = Users(i).req_size;
    users.processed_req_size(i) = Users(i).processed_req_size;
    users.uplink_basestation(i) = Users(i).uplink_basestation;
    users.downlink_basestation(i) = Users(i).downlink_basestation;
    users.MEC_basestation(i) = Users(i).MEC_basestation;
end

for i = 1:length(Basestations)
    basestations.x(i) = Basestations(i).x;
    basestations.y(i) = Basestations(i).y;
end
basestations.backhaul_power = Basestations.backhaul_power;
basestations.noise_spectral_density = Basestations.noise_spectral_density;


basestations.backhaul_carrier_frequency_4g = Basestations.backhaul_carrier_frequency_4g;
basestations.backhaul_bandwidth_4g = Basestations.backhaul_bandwidth_4g;
basestations.backhaul_radius_4g = Basestations.backhaul_radius_4g;

basestations.backhaul_carrier_frequency_5g = Basestations.backhaul_carrier_frequency_5g;
basestations.backhaul_bandwidth_5g = Basestations.backhaul_bandwidth_5g;
basestations.backhaul_radius_5g = Basestations.backhaul_radius_5g;

basestations.is_4g = Basestations.is_4g;
basestations.is_5g = Basestations.is_5g;
%end of Conversion

%Unit Conversions
req_size = users.req_size * 10^6;
processed_req_size = users.processed_req_size*10^6;
uplinks = users.uplink_basestation;
downlinks = users.downlink_basestation;
MECs = users.MEC_basestation;


Pt = basestations.backhaul_power; %dBm
Nzero = basestations.noise_spectral_density; %dBm
BSs = basestations;

if BSs.is_5g == 1
    frequency = BSs.backhaul_carrier_frequency_5g; %in GHz
    d_max = BSs.backhaul_radius_5g; %in meters
    bandwidth = BSs.backhaul_bandwidth_5g; %in MHz
else
    frequency = BSs.backhaul_carrier_frequency_4g; %in GHz
    d_max = BSs.backhaul_radius_4g; %in meters
    bandwidth = BSs.backhaul_bandwidth_4g; %in MHz
end

bitrates = zeros(length(BSs.x), length(BSs.y));
for i = 1:length(bitrates) %finds maximum channel capacity between all base stations(some may be zero)
    for j = 1:length(bitrates)
        pointOne = [BSs.x(i) BSs.y(i)];
        pointTwo = [BSs.x(j) BSs.y(j)];
        [bitrates(i,j), distance] = findBitRate(pointOne, pointTwo, frequency, bandwidth, Pt, Nzero);
        if (distance > d_max)
            bitrates(i,j) = 0;
        end
    end
end

bitratesArray = reshape((bitrates).',1,[]); %turns bitrates into linear array
bitratesArray = 1./bitratesArray; %because we want highest channel capacity path
G = prepareG(length(BSs.x),bitratesArray); %turns bitratesArray into graph format
% plot(G,'EdgeLabel',G.Edges.Weight)

uplinkToMecPaths = zeros;
mecToDownlinkPaths = zeros;
for userN = 1:(length(users.x))
    uplinkToMecPath = shortestpath(G,uplinks(userN),MECs(userN)); %uplink to MEC path
    uplinkToMecPaths(userN,1:length(uplinkToMecPath)) = uplinkToMecPath;
    mecToDownLinkPath = shortestpath(G,MECs(userN),downlinks(userN)); %MEC to downlink path
    mecToDownlinkPaths(userN,1:length(mecToDownLinkPath)) = mecToDownLinkPath;
end
concurrentPaths = concatenate(uplinkToMecPaths,mecToDownlinkPaths); %BS to MEC, MEC to BS
[~, numColumns] = size(concurrentPaths);
BSNumberAtEachInstance = zeros(numColumns, length(BSs.x));
for BSN = 1:length(BSs.x)
    for instance = 1:numColumns
        if (instance < numColumns)
            BSNumberAtEachInstance(instance, BSN) = countN(concurrentPaths(:,instance),concurrentPaths(:,instance+1), BSN);
        end
    end
end

[numRowsBSNI, ~] = size(BSNumberAtEachInstance);
channelDivisionMatrix = BSNumberAtEachInstance(1:(numRowsBSNI-1),:);

[rowsN, ~] = size(uplinkToMecPaths);

overall = findLatency(uplinkToMecPaths,mecToDownlinkPaths, rowsN, channelDivisionMatrix, BSs, bandwidth,frequency,Pt,Nzero,req_size, processed_req_size);
users.backhaul_latency = overall';

%Output Conversion
for i = 1:length(Users)
    Users(i).backhaul_latency = users.backhaul_latency(i);
end
end
function Latencies = findLatency(uplinkToMecPaths,mecToDownlinkPaths, rowsN, channelDivisionMatrix, BSs, bandwidth,frequency,Pt,Nzero,uplinkToMecSizes, mecTomecToDownlinkSizes)
for user = 1:(rowsN) %find channel capacity for each user(first uplinks then downlinks)
    userUplinkToMecPath = uplinkToMecPaths(user,:);
    userUplinkToMecLatency = 0;
    for currentBS = 1:(length(userUplinkToMecPath)-1)
        channelDivArray = channelDivisionMatrix(currentBS,:);
        if userUplinkToMecPath(currentBS) ~= 0 && userUplinkToMecPath(currentBS + 1) ~= 0
            firstBS = userUplinkToMecPath(currentBS);
            secondBS = userUplinkToMecPath(currentBS+1);
            channelDiv = channelDivArray(firstBS);
            pointOne = [BSs.x(firstBS) BSs.y(firstBS)];
            pointTwo = [BSs.x(secondBS) BSs.y(secondBS)];
            [currentCap, ~] = findBitRate(pointOne, pointTwo, frequency, bandwidth/channelDiv, Pt, Nzero);
            uplinkToMecSize = uplinkToMecSizes(user);
            currentUplinkToMecLatency = uplinkToMecSize/currentCap;
            userUplinkToMecLatency = userUplinkToMecLatency + currentUplinkToMecLatency;
        end
    end
    uplinkToMecLatencies(user,1) = userUplinkToMecLatency;
    %***********************************
    userMecToDownlinkPath = mecToDownlinkPaths(user,:);
    userMecToDownlinkLatency = 0;
    for currentBS = 1:(length(userMecToDownlinkPath)-1)
        channelDivArray = channelDivisionMatrix(currentBS,:);
        if userMecToDownlinkPath(currentBS) ~= 0 && userMecToDownlinkPath(currentBS + 1) ~= 0
            firstBS = userMecToDownlinkPath(currentBS);
            secondBS = userMecToDownlinkPath(currentBS+1);
            channelDiv = channelDivArray(firstBS);
            pointOne = [BSs.x(firstBS) BSs.y(firstBS)];
            pointTwo = [BSs.x(secondBS) BSs.y(secondBS)];
            [currentCap, ~] = findBitRate(pointOne, pointTwo, frequency, bandwidth/channelDiv, Pt, Nzero);
            mecToDownlinkSize = mecTomecToDownlinkSizes(user);
            currentDownlinkLatency = mecToDownlinkSize/currentCap;
            userMecToDownlinkLatency = userMecToDownlinkLatency + currentDownlinkLatency;
        end
    end
    mecToDownlinkLatencies(user,1) = userMecToDownlinkLatency;
end

Latencies = uplinkToMecLatencies + mecToDownlinkLatencies;
end

function G = prepareG(NumberOfPoints, weights)
s = []; 
t = [];
for i=1:NumberOfPoints % connects all nodes
    s = [s (ones(1, (NumberOfPoints)))*i];
    t = [t 1:NumberOfPoints];
end

G = graph(s,t,weights);
end

% w = bandwidth
% Pt = transmitted power (dBm)
% Nz = N0 (dBm)
function [bitrate, dist] = findBitRate(firstPoint, secondPoint, f, w, Pt, Nz)
%w = w * 10^-6; %converts to MHz
bandwidth = w * 10^6;
if(firstPoint == secondPoint)
    bitrate = 0;
    d = 0;
else
    %distance in km
    d = sqrt((firstPoint(1) - secondPoint(1))^2 + (firstPoint(2) - secondPoint(2))^2) * 10^-3;
    FSPL = 32.4 + 20*log10(f) + 20*log10(d);
    Pr = Pt - FSPL; % Received Power (dBm)
    NdBm = Nz + 10*log10(bandwidth); %double check
    SNRdB = Pr - NdBm;
    SNR = 10^(SNRdB);
    bitrate = bandwidth * log2(1 + SNR);
end
dist = d * 1000; %distance in meters
end

function repeated = countN(firstArray, secondArray, N)
indices = find(firstArray == N);
repeated = length(indices);

%don't count the BS if it is a destination
for i = 1:length(indices)
    if (secondArray(indices(i)) == 0)
        if (repeated > 0)
            repeated = repeated - 1;
        end
    end
end
end

function concurrentPaths = concatenate(firstMarix, secondMatrix)
    [row1, column1] = size(firstMarix);
    [row2, column2] = size(secondMatrix);
    if column1 > column2
        difference = column1 - column2;
        adjuster = zeros(row1, difference);
        secondMatrix = [secondMatrix adjuster];
    elseif column1 < column2
        difference = column2 - column1;
        adjuster = zeros(row1, difference);
        firstMarix = [firstMarix adjuster];
    end
    concurrentPaths = [firstMarix; secondMatrix];
end

