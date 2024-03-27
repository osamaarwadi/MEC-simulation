function [avg_uplink, avg_processing, avg_downlink, avg_backhaul, avg_total] = runSimulation_CutOutliers(num_of_sims, BS, user_count, grid, req_size)

    total_overall_uplink = 0;
    total_overall_processing = 0;
    total_overall_downlink = 0;
    total_overall_backhaul = 0;
    total_overall_total = 0;

    for i = 1:num_of_sims
        U = UsersSetup(user_count, grid, req_size);
        U = uplink_greedy(U, BS);
        U = downlink_greedy(U, BS);
        U = backhaul(U, BS);
        U = calculateTotalLatency(U);
        highest = 1;
        for j = 1:user_count
            if U(j).total_latency > U(highest).total_latency
                highest = j;
            end
        end
        U(highest) = [];
        U = uplink_greedy(U, BS);
        U = downlink_greedy(U, BS);
        U = backhaul(U, BS);
        [overall_uplink, overall_processing, overall_downlink, overall_backhaul, overall_total] = calculateOverallLatency(U);
        total_overall_uplink = total_overall_uplink + overall_uplink;
        total_overall_processing = total_overall_processing + overall_processing;
        total_overall_downlink = total_overall_downlink + overall_downlink;
        total_overall_backhaul = total_overall_backhaul + overall_backhaul;
        total_overall_total = total_overall_total + overall_total;
    end

    avg_uplink = total_overall_uplink/(num_of_sims*user_count);
    avg_processing = total_overall_processing/(num_of_sims*user_count);
    avg_downlink = total_overall_downlink/(num_of_sims*user_count);
    avg_backhaul = total_overall_backhaul/(num_of_sims*user_count);
    avg_total = total_overall_total/(num_of_sims*user_count);
end