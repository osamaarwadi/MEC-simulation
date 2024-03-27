function [uplink, processing, downlink, backhaul, total] = calculateOverallLatency(Users)
    uplink = 0;
    processing = 0;
    downlink = 0;
    backhaul = 0;
    total = 0;
    Users = calculateTotalLatency(Users);
    for i = 1:length(Users)
        if ~isnan(Users(i).uplink_latency)
            uplink = uplink + Users(i).uplink_latency;
        end        
        if ~isnan(Users(i).processing_latency)
            processing = processing + Users(i).processing_latency;
        end
        if ~isnan(Users(i).downlink_latency)
            downlink = downlink + Users(i).downlink_latency;
        end
        if ~isnan(Users(i).backhaul_latency)
            backhaul = backhaul + Users(i).backhaul_latency;
        end
        if ~isnan(Users(i).total_latency)
            total = total + Users(i).total_latency;
        end
    end
end