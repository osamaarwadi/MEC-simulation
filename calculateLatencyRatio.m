function [Users] = calculateLatencyRatio(Users, avgUplink, avgProcessing, avgDownlink, avgBackhaul, avgLatency)

    for i = 1:length(Users)
        Users(i).uplink_latency_ratio = Users(i).uplink_latency / avgUplink;
        Users(i).processing_latency_ratio = Users(i).processing_latency / avgProcessing;
        Users(i).downlink_latency_ratio = Users(i).downlink_latency / avgDownlink;
        Users(i).backhaul_latency_ratio = Users(i).backhaul_latency / avgBackhaul;
        Users(i).total_latency_ratio = Users(i).total_latency / avgLatency;
    end

end