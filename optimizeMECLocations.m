function [Basestations] = optimizeMECLocations(Users, Basestations, mec_count)
    rng('shuffle')
    min_overall_latency = inf;
    for i = 1:length(Basestations)
        Users = uplink_dummy(Users, Basestations);
%         Users_temp = downlink_dummy(Users, Basestations);
%         Users_temp = backhaul_dummy(Users, Basestations);
        [~, ~, ~, ~, overall_latency] = calculateOverallLatency(Users);
        if overall_latency < min_overall_latency
            min_overall_latency = overall_latency;
        end
        Basestations = shiftMEC(Basestations, mec_count);
    end
end