function [U, BS_in_range_5g, BS_in_range_4g] = uplink_greedy(U, BS)

for i = 1:length(U)
    U(i).uplink_latency = 0;
    U(i).uplink_basestation = 0;
    U(i).processed_req_size = (rand()+0.5)*U(i).req_size;
    U(i).MEC_basestation = 0;
    U(i).processing_latency = 0;
    U(i).uplink_connected_via_4g = false;
    U(i).uplink_connected_via_5g = false;
end

BS_in_range_5g = findBSinRange5G(U, BS);
BS_in_range_4g = findBSinRange4G(U, BS);

for i = 1:length(U)
    [connections_5g, connections_4g] = findConnectedUsers(U, BS);
    if nnz(BS_in_range_5g(i,:)) > 0
        best = BS_in_range_5g(i,1);
        for j = 1:nnz(BS_in_range_5g(i,:))
            if connections_5g(BS_in_range_5g(i,j)) < connections_5g(best)
                best = BS_in_range_5g(i,j);
            end
        end
            U(i).uplink_basestation = best;
            U(i).uplink_connected_via_5g = true;
    elseif nnz(BS_in_range_4g(i,:)) > 0
        best = BS_in_range_4g(i,1);
        for j = 1:nnz(BS_in_range_4g(i,:))
            if connections_5g(BS_in_range_4g(i,j)) < connections_4g(best)
                best = BS_in_range_4g(i,j);
            end
        end
            U(i).uplink_basestation = best;
            U(i).uplink_connected_via_4g = true;
    end
end

MECs = [];
for i = 1:length(BS)
    if BS(i).is_MEC
        MECs(end + 1) = i;
    end
end

users_in_mecs = zeros(1, length(MECs));

for i = 1:length(U)
    mec = MECs(1);
    for j = 1:length(users_in_mecs)
        if users_in_mecs(j) < users_in_mecs(mec)
            mec = MECs(j);
        end
    end
    U(i).MEC_basestation =  mec;
    users_in_mecs(mec) = users_in_mecs(mec) + 1;
end

% for i = 1:length(U)
%     closest_MECs = [];
%     for j = 1:length(MECs)
%         distance = sqrt( (BS((U(i).uplink_basestation)).x - BS(j).x )^2) + (( BS((U(i).uplink_basestation)).y - BS(j).y))^2;
%         if distance <= (BS(1).grid_length/2) *sqrt(2)
%             closest_MECs(end + 1) = j;
%         end
%     end
%     if isempty(closest_MECs)
%         random = randi(length(MECs));
%         U(i).MEC_basestation = MECs(random);
%         users_in_mecs(MECs(random)) = users_in_mecs(MECs(random)) + 1;
%     else
%         best = closest_MECs(1);
%         if length(closest_MECs) > 1
%             connections_MEC = findConnectedtoMEC(U, MECs);
%             for m = 1:length(closest_MECs)
%                 for k = 1:length(connections_MEC)
%                     if connections_MEC(closest_MECs(m)) < connections_MEC(best)
%                         best = closest_MECs(m);
%                     end
%                 end
%             end
%         end
%         U(i).MEC_basestation = best;
%         users_in_mecs(best) = users_in_mecs(best) + 1;
%     end
% end


[connections_5g, connections_4g] = findConnectedUsers(U, BS);


for i = 1:length(U)

    ul = U(i).uplink_basestation;
    mec = U(i).MEC_basestation;
    conec = false;

    if U(i).uplink_connected_via_5g
        fc = BS(ul).uplink_carrier_frequency_5g;
        w = BS(ul).uplink_bandwidth_5g/connections_5g(ul);
        d = sqrt( (U(i).x - 20 )^2 + (U(i).y - 20 )^2 );
        pl = 20*log10(d) + 20*log10(fc) + 32.45;
        conec = true;
    elseif U(i).uplink_connected_via_4g
        fc = BS(ul).uplink_carrier_frequency_4g;
        w = BS(ul).uplink_bandwidth_4g/connections_4g(ul);
        d = sqrt( (U(i).x - 20 )^2 + (U(i).y - 20 )^2 );
        pl = 20*log10(d) + 20*log10(fc) + 32.45 - 100;
        conec = true;
    end
    if conec == true
        pt = BS(ul).uplink_power;
        n0 = BS(ul).noise_spectral_density;
    
        pr = pt - pl;
        n = n0 + 10*log10(w*10^6);
        snrdb = pr - n;
        snr = db2pow(snrdb);
        capacity = w*10^6*log2(1+snr);
    
        U(i).uplink_latency = U(i).req_size*10^6/capacity;
    
        cpb = randi(8)*2;
        U(i).processing_latency = (U(i).req_size*1e6*cpb)/(BS(mec).processor_clockspeed*1e9/users_in_mecs(mec)) ;
    end
end
end

function BS_in_range_5g = findBSinRange5G(U, BS)

BS_in_range_5g = zeros(length(U), length(BS));

for i = 1:length(U)
    last = 1;
    for j = 1:length(BS)
        if sqrt( (U(i).x - BS(j).x)^2 + (U(i).y - BS(j).y)^2) <= BS(j).uplink_radius_5g && BS(j).is_5g
            BS_in_range_5g(i, last) = j;
            last = last + 1;
        end
    end
end
end

function BS_in_range_4g = findBSinRange4G(U, BS)

BS_in_range_4g = zeros(length(U), length(BS));

for i = 1:length(U)
    last = 1;
    for j = 1:length(BS)
        if sqrt( (U(i).x - BS(j).x)^2 + (U(i).y - BS(j).y)^2) <= BS(j).uplink_radius_4g && BS(j).is_4g
            BS_in_range_4g(i, last) = j;
            last = last + 1;
        end
    end
end
end

function connected_to_MEC = findConnectedtoMEC(U, MECs)

connected_to_MEC = zeros(1, length(MECs));
for i = 1:length(U)
    if U(i).MEC_basestation ~= 0
        connected_to_MEC(U(i).MEC_basestation) = connected_to_MEC(U(i).MEC_basestation)+1;
    end
end

end

function [connections_5g, connections_4g] = findConnectedUsers(U, BS)

connections_5g = zeros(1, length(BS));
connections_4g = zeros(1, length(BS));

for i = 1:length(U)
    if U(i).uplink_basestation ~= 0 && U(i).uplink_connected_via_5g
        connections_5g(U(i).uplink_basestation) = connections_5g(U(i).uplink_basestation) + 1;
    elseif U(i).uplink_basestation ~= 0 && U(i).uplink_connected_via_4g
        connections_4g(U(i).uplink_basestation) = connections_4g(U(i).uplink_basestation) + 1;
    end
end
end