function [BaseStations] = BaseStationsSetup(grid, g, bs_count, mec_count, mec_clock, ...
    uplink_bandwidth_4g, uplink_bandwidth_5g, ...
    downlink_bandwidth_4g, downlink_bandwidth_5g, ...
    backhaul_bandwidth_4g, backhaul_bandwidth_5g, ...
    uplink_carrier_frequency_4g, uplink_carrier_frequency_5g, ...
    downlink_carrier_frequency_4g, downlink_carrier_frequency_5g, ...
    backhaul_carrier_frequency_4g, backhaul_carrier_frequency_5g, ...
    uplink_power, downlink_power, backhaul_power, noise_spectral_density)

BaseStations = struct('x', 0, ...
                      'y', 0, ...
                      'grid_length', grid(1), ...
                      'is_MEC', 0, ...
                      'processor_clockspeed', 0, ...
                      'is_4g', true, ...
                      'is_5g', true, ...
                      'uplink_bandwidth_4g', uplink_bandwidth_4g, ...
                      'uplink_bandwidth_5g', uplink_bandwidth_5g, ...
                      'downlink_bandwidth_4g', downlink_bandwidth_4g, ...
                      'downlink_bandwidth_5g', downlink_bandwidth_5g, ...
                      'backhaul_bandwidth_4g', backhaul_bandwidth_4g, ...
                      'backhaul_bandwidth_5g', backhaul_bandwidth_5g, ...
                      'uplink_power', uplink_power, ...
                      'downlink_power', downlink_power, ...
                      'backhaul_power', backhaul_power, ...
                      'noise_spectral_density', noise_spectral_density, ...
                      'uplink_carrier_frequency_4g', uplink_carrier_frequency_4g, ...
                      'uplink_carrier_frequency_5g', uplink_carrier_frequency_5g, ...                      
                      'downlink_carrier_frequency_4g', downlink_carrier_frequency_4g, ...
                      'downlink_carrier_frequency_5g', downlink_carrier_frequency_5g, ...                      
                      'backhaul_carrier_frequency_4g', backhaul_carrier_frequency_4g, ...
                      'backhaul_carrier_frequency_5g', backhaul_carrier_frequency_5g, ...
                      'uplink_radius_4g', [], ...
                      'uplink_radius_5g', [], ...
                      'downlink_radius_4g', [], ...
                      'downlink_radius_5g', [], ...
                      'backhaul_radius_4g', [], ...
                      'backhaul_radius_5g', [] ...
                      );

switch g
    case 1
        BaseStations = PlaceBaseStations1(bs_count, BaseStations, grid);
    case 4
        BaseStations = PlaceBaseStations4(bs_count, BaseStations, grid);
    case 9
        BaseStations = PlaceBaseStations9(bs_count, BaseStations, grid);
    case 16
        BaseStations = PlaceBaseStations16(bs_count, BaseStations, grid);
end
for i = 1:bs_count
    if mec_count>0
        BaseStations(i).is_MEC = true;
        mec_count=mec_count-1;
    else
        BaseStations(i).is_MEC = false;
    end
    if isempty(mec_clock) || mec_clock == 0
        clk_temp = str2double(input("Enter the desired Clock Speed for MEC #" + i + " (in GHz): ", 's'));
        if isnan(clk_temp)
            BaseStations(i).processor_clockspeed = 2;
        else
            BaseStations(i).processor_clockspeed = clk_temp;
        end
    else
        BaseStations(i).processor_clockspeed = mec_clock;
    end
    BaseStations(i).is_4g = true;
    BaseStations(i).is_5g = true;

    BaseStations(i).uplink_bandwidth_4g = uplink_bandwidth_4g;
    BaseStations(i).uplink_bandwidth_5g = uplink_bandwidth_5g;
    BaseStations(i).downlink_bandwidth_4g = downlink_bandwidth_4g;    
    BaseStations(i).downlink_bandwidth_5g = downlink_bandwidth_5g;
    BaseStations(i).backhaul_bandwidth_4g = backhaul_bandwidth_4g;    
    BaseStations(i).backhaul_bandwidth_5g = backhaul_bandwidth_5g;

    BaseStations(i).uplink_carrier_frequency_4g = uplink_carrier_frequency_4g;    
    BaseStations(i).uplink_carrier_frequency_5g = uplink_carrier_frequency_5g;
    BaseStations(i).downlink_carrier_frequency_4g = downlink_carrier_frequency_4g;    
    BaseStations(i).downlink_carrier_frequency_5g = downlink_carrier_frequency_5g;
    BaseStations(i).backhaul_carrier_frequency_4g = backhaul_carrier_frequency_4g;    
    BaseStations(i).backhaul_carrier_frequency_5g = backhaul_carrier_frequency_5g;

    BaseStations(i).uplink_power = uplink_power;
    BaseStations(i).downlink_power = downlink_power;
    BaseStations(i).backhaul_power = backhaul_power;
    BaseStations(i).noise_spectral_density = noise_spectral_density;
end

end

function BaseStations = PlaceBaseStations1(bs_count, BaseStations, grid)

    for i = 1:bs_count
        BaseStations(i).x = randi(round(grid(1)));
        BaseStations(i).y = randi(round(grid(2)));
    end

end

function BaseStations = PlaceBaseStations4(bs_count, BaseStations, grid)

q = 1;
    for i = 1:bs_count
        switch q
            case 1
                BaseStations(i).x = (randi(round(grid(1)/2)));
                BaseStations(i).y = round(grid(2)/2) + randi(round(grid(2)/2));
                q=q+1;
            case 2
                BaseStations(i).x = round(grid(1)/2) + randi(round(grid(1)/2));
                BaseStations(i).y = round(grid(2)/2) + randi(round(grid(2)/2));
                q=q+1;
            case 3
                BaseStations(i).x = (randi(round(grid(1)/2)));
                BaseStations(i).y = (randi(round(grid(2)/2)));
                q=q+1;
            case 4
                BaseStations(i).x = round(grid(1)/2) + randi(round(grid(1)/2));
                BaseStations(i).y = (randi(round(grid(2)/2)));
                q=1;
        end
    end
end

function BaseStations = PlaceBaseStations9(bs_count, BaseStations, grid)

q = 1;
    for i = 1:bs_count
        switch q
            case 1
                BaseStations(i).x = randi(round(grid(1)/3));
                BaseStations(i).y = randi(round(grid(2)/3)) + 2*round(grid(2)/3);
                q=q+1;
            case 2
                BaseStations(i).x = randi(round(grid(1)/3)) + round(grid(1)/3);
                BaseStations(i).y = randi(round(grid(2)/3)) + 2*round(grid(2)/3);
                q=q+1;
            case 3
                BaseStations(i).x = randi(round(grid(1)/3)) + 2*round(grid(1)/3);
                BaseStations(i).y = randi(round(grid(2)/3)) + 2*round(grid(2)/3);
                q=q+1;
            case 4
                BaseStations(i).x = randi(round(grid(1)/3));
                BaseStations(i).y = randi(round(grid(2)/3)) + round(grid(2)/3);
                q=q+1;
           case 5
                BaseStations(i).x = randi(round(grid(1)/3)) + round(grid(1)/3);
                BaseStations(i).y = randi(round(grid(2)/3)) + round(grid(2)/3);
                q=q+1;
           case 6
                BaseStations(i).x = randi(round(grid(1)/3)) + 2*round(grid(1)/3);
                BaseStations(i).y = randi(round(grid(2)/3)) + round(grid(2)/3);
                q=q+1;
           case 7
                BaseStations(i).x = randi(round(grid(1)/3));
                BaseStations(i).y = randi(round(grid(2)/3));
                q=q+1;
           case 8
                BaseStations(i).x = randi(round(grid(1)/3)) + round(grid(1)/3);
                BaseStations(i).y = randi(round(grid(2)/3));
                q=q+1;
           case 9
                BaseStations(i).x = randi(round(grid(1)/3)) + 2*round(grid(1)/3);
                BaseStations(i).y = randi(round(grid(2)/3));
                q=1;
        end
    end
end

function BaseStations = PlaceBaseStations16(bs_count, BaseStations, grid)

q = 1;
    for i = 1:bs_count
        switch q
            case 1
                BaseStations(i).x = randi(round(grid(1)/4));
                BaseStations(i).y = randi(round(grid(2)/4)) + 3*round(grid(2)/4);
                q=q+1;
            case 2
                BaseStations(i).x = randi(round(grid(1)/4)) + round(grid(1)/4);
                BaseStations(i).y = randi(round(grid(2)/4)) + 3*round(grid(2)/4);
                q=q+1;
            case 3
                BaseStations(i).x = randi(round(grid(1)/4)) + 2*round(grid(1)/4);
                BaseStations(i).y = randi(round(grid(2)/4)) + 3*round(grid(2)/4);
                q=q+1;
            case 4
                BaseStations(i).x = randi(round(grid(1)/4)) + 3*round(grid(1)/4);
                BaseStations(i).y = randi(round(grid(2)/4)) + 3*round(grid(2)/4);
                q=q+1;
           case 5
                BaseStations(i).x = randi(round(grid(1)/4));
                BaseStations(i).y = randi(round(grid(2)/4)) + 2*round(grid(2)/4);
                q=q+1;
           case 6
                BaseStations(i).x = randi(round(grid(1)/4)) + round(grid(1)/4);
                BaseStations(i).y = randi(round(grid(2)/4)) + 2*round(grid(2)/4);
                q=q+1;
           case 7
                BaseStations(i).x = randi(round(grid(1)/4)) + 2*round(grid(1)/4);
                BaseStations(i).y = randi(round(grid(2)/4)) + 2*round(grid(2)/4);
                q=q+1;
           case 8
                BaseStations(i).x = randi(round(grid(1)/4)) + 3*round(grid(1)/4);
                BaseStations(i).y = randi(round(grid(2)/4)) + 2*round(grid(2)/4);
                q=q+1;
            case 9
                BaseStations(i).x = randi(round(grid(1)/4));
                BaseStations(i).y = randi(round(grid(2)/4)) + round(grid(2)/4);
                q=q+1;
            case 10
                BaseStations(i).x = randi(round(grid(1)/4)) + round(grid(1)/4);
                BaseStations(i).y = randi(round(grid(2)/4)) + round(grid(2)/4);
                q=q+1;
            case 11
                BaseStations(i).x = randi(round(grid(1)/4)) + 2*round(grid(1)/4);
                BaseStations(i).y = randi(round(grid(2)/4)) + round(grid(2)/4);
                q=q+1;
            case 12
                BaseStations(i).x = randi(round(grid(1)/4)) + 3*round(grid(1)/4);
                BaseStations(i).y = randi(round(grid(2)/4)) + round(grid(2)/4);
                q=q+1;
            case 13
                BaseStations(i).x = randi(round(grid(1)/4));
                BaseStations(i).y = randi(round(grid(2)/4));
                q=q+1;
            case 14
                BaseStations(i).x = randi(round(grid(1)/4)) + round(grid(1)/4);
                BaseStations(i).y = randi(round(grid(2)/4));
                q=q+1;
            case 15
                BaseStations(i).x = randi(round(grid(1)/4)) + 2*round(grid(1)/4);
                BaseStations(i).y = randi(round(grid(2)/4));
                q=q+1;
            case 16
                BaseStations(i).x = randi(round(grid(1)/4)) + 3*round(grid(1)/4);
                BaseStations(i).y = randi(round(grid(2)/4));
                q=1;
        end
    end
end