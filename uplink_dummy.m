function Users = uplink_dummy(Users, Basestations)
    for i = 1:length(Users)
        Users(i).uplink_latency = rand(1)*5;
        Users(i).processing_latency = rand(1)*3;
    end

end