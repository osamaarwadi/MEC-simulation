function [avg_uplink, avg_disconnected] = runSimulationDisconnections(num_of_sims, BS, user_count, grid, req_size)

    total_overall_uplink = 0;
    total_overall_disconnected = 0;

    for i = 1:num_of_sims
        U = UsersSetup(user_count, grid, req_size);
        U = uplink_greedy(U, BS);
        for j = 1:length(U)
            total_overall_uplink = U(j).uplink_latency + total_overall_uplink;
            if U(i).uplink_basestation == 0
                total_overall_disconnected =  total_overall_disconnected + 1;
            end
        end
    end

    avg_uplink = total_overall_uplink/(num_of_sims*user_count - total_overall_disconnected);
%     avg_processing = total_overall_processing/(num_of_sims*user_count);
%     avg_downlink = total_overall_downlink/(num_of_sims*user_count);
%     avg_backhaul = total_overall_backhaul/(num_of_sims*user_count);
%     avg_total = total_overall_total/(num_of_sims*user_count);
    avg_disconnected = total_overall_disconnected/num_of_sims;
end