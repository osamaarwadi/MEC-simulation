function Users = calculateTotalLatency(Users)
    for i = 1:length(Users)
        if ~isnan(Users(i).uplink_latency) && ~isnan(Users(i).processing_latency) && ~isnan(Users(i).downlink_latency) && ~isnan(Users(i).backhaul_latency)
            Users(i).total_latency = Users(i).uplink_latency + Users(i).processing_latency + Users(i).downlink_latency + Users(i).backhaul_latency;
        end        
    end
end