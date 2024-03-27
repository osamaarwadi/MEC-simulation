function [latencyArray] = calculateLatencyAverage(overallLatency, user_count)
    latencyArray = zeros(1, length(overallLatency));
    for i = 1:length(latencyArray)
        latencyArray(i) = overallLatency(i)/user_count;
    end
end