function [U, BS_in_range_5g, BS_in_range_4g] = downlink_random(U, BS)

BS_in_range_5g = findBSinRange5G(U, BS);
BS_in_range_4g = findBSinRange4G(U, BS);

for i = 1:length(U)
    if nnz(BS_in_range_5g(i,:)) > 0
            U(i).downlink_basestation = BS_in_range_5g(i,randi(nnz(BS_in_range_5g(i,:))));
            U(i).downlink_connected_via_5g = true;
            U(i).downlink_connected_via_4g = false;
    elseif nnz(BS_in_range_4g(i,:)) > 0
            U(i).downlink_basestation = BS_in_range_4g(i,randi(nnz(BS_in_range_4g(i,:))));
            U(i).downlink_connected_via_4g = true;
            U(i).downlink_connected_via_5g = false;
    else 
        U(i).downlink_basestation = 0;            
        U(i).downlink_connected_via_5g = false; 
        U(i).downlink_connected_via_4g = false;
    end
end

[connections_5g, connections_4g] = findConnectedUsers(U, BS);

for i = 1:length(U)

    dl = U(i).downlink_basestation;

    if U(i).downlink_connected_via_5g
        fc = BS(dl).downlink_carrier_frequency_5g;
        w = BS(dl).downlink_bandwidth_5g/connections_5g(dl);
        d = sqrt( (U(i).x - 20 )^2 + (U(i).y - 20 )^2 );
        pl = 20*log10(d) + 20*log10(fc) + 32.45;
    elseif U(i).downlink_connected_via_4g
        fc = BS(dl).downlink_carrier_frequency_4g;
        w = BS(dl).downlink_bandwidth_4g/connections_4g(dl);
        d = sqrt( (U(i).x - 20 )^2 + (U(i).y - 20 )^2 );
        pl = 20*log10(d) + 20*log10(fc) + 32.45 - 100;
    else
        return
    end
    pt = BS(dl).downlink_power;
    n0 = BS(dl).noise_spectral_density;

    pr = pt - pl;
    n = n0 + 10*log10(w*10^6);
    snrdb = pr - n;
    snr = db2pow(snrdb);
    capacity = w*10^6*log2(1+snr);

    U(i).downlink_latency = U(i).req_size*10^6/capacity;
end
end


function BS_in_range_5g = findBSinRange5G(U, BS)

BS_in_range_5g = zeros(length(U), length(BS));

for i = 1:length(U)
    last = 1;
    for j = 1:length(BS)
        if sqrt( (U(i).x - BS(j).x)^2 + (U(i).y - BS(j).y)^2) <= BS(j).downlink_radius_5g
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
        if sqrt( (U(i).x - BS(j).x)^2 + (U(i).y - BS(j).y)^2) <= BS(j).downlink_radius_4g
            BS_in_range_4g(i, last) = j;
            last = last + 1;
        end
    end
end

end

function [connections_5g, connections_4g] = findConnectedUsers(U, BS)

connections_5g = zeros(1, length(BS));
connections_4g = zeros(1, length(BS));

for i = 1:length(U)
    if U(i).downlink_basestation ~= 0 && U(i).downlink_connected_via_5g
        connections_5g(U(i).downlink_basestation) = connections_5g(U(i).downlink_basestation) + 1;
    elseif U(i).downlink_basestation ~= 0 && U(i).downlink_connected_via_4g
        connections_4g(U(i).downlink_basestation) = connections_4g(U(i).downlink_basestation) + 1;
    end
end
end