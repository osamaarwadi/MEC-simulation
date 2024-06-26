function Users = UsersSetup(user_count, grid, req_size)

Users = struct('x', 0, 'y', 0, 'direction', 0, 'req_size', [], 'processed_req_size', [], ...
    'uplink_connected_via_4g', [], 'uplink_connected_via_5g', [], ...
    'downlink_connected_via_4g', [], 'downlink_connected_via_5g', [], ...
    'uplink_basestation', [], ...
    'MEC_basestation', [], ...
    'downlink_basestation', 0, ...
    'uplink_latency', [], ...
    'processing_latency', [], ...
    'downlink_latency', [], ...
    'backhaul_latency', [], ...
    'total_latency', 0, ...
    'uplink_latency_ratio', [], ...
    'processing_latency_ratio', [], ...
    'downlink_latency_ratio', [], ...
    'backhaul_latency_ratio', [], ...
    'total_latency_ratio', []);

    for i = 1:user_count
        Users(i).x = randi(grid(1));
        Users(i).y = randi(grid(2));
        Users(i).direction = randi(5)-1;
        if req_size == 0
        size_temp = str2double(input("Enter the desired Request Size for User #" + i + " (in MB): ", 's'));
            if isnan(size_temp)
                Users(i).req_size = 100;
            else
                Users(i).req_size = size_temp;
            end
        else
            Users(i).req_size = req_size;
        end
    end
end

