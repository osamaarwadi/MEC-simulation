function [avg_uplink, avg_processing, avg_downlink, avg_backhaul, avg_total] = calculateAverageOverallLatency(overall_uplink, overall_processing, overall_downlink, overall_backhaul, overall_total, user_count)
    
    avg_uplink = overall_uplink/user_count;
    avg_processing = overall_processing/user_count;
    avg_downlink = overall_downlink/user_count;
    avg_backhaul = overall_backhaul/user_count;
    avg_total = overall_total/user_count;

end