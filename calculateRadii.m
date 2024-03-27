function BaseStations = calculateRadii(BaseStations, ...
    uplink_power, downlink_power, backhaul_power, ...
    uplink_carrier_frequency_4g, downlink_carrier_frequency_4g, backhaul_carrier_frequency_4g, ...
    uplink_carrier_frequency_5g, downlink_carrier_frequency_5g, backhaul_carrier_frequency_5g, ...
    uplink_bandwidth_4g, uplink_bandwidth_5g, ...
    downlink_bandwidth_4g, downlink_bandwidth_5g, ...
    backhaul_bandwidth_4g, backhaul_bandwidth_5g, ...
    noise_spectral_density)

% sensitivity = noise spectral density (dBm/Hz) + Noise Figure (in dB) + SNR (in dB) + 10 * log10(Bit Rate/Channel Bandwidth) (in bps/Hz) + System Margin (in dB)

receiver_sensitivity_ul_4g = noise_spectral_density + 3 + 12 + 10 * log10(uplink_bandwidth_4g*10^6) + 3;
receiver_sensitivity_ul_5g = noise_spectral_density + 3 + 12 + 10 * log10(uplink_bandwidth_5g*10^6) + 3;
receiver_sensitivity_dl_4g = noise_spectral_density + 3 + 12 + 10 * log10(downlink_bandwidth_4g*10^6) + 3;
receiver_sensitivity_dl_5g = noise_spectral_density + 3 + 12 + 10 * log10(downlink_bandwidth_5g*10^6) + 3;
receiver_sensitivity_bh_4g = noise_spectral_density + 3 + 12 + 10 * log10(backhaul_bandwidth_4g*10^6) + 3;
receiver_sensitivity_bh_5g = noise_spectral_density + 3 + 12 + 10 * log10(backhaul_bandwidth_5g*10^6) + 3;

for i = 1:length(BaseStations)
    BaseStations(i).uplink_radius_4g = 1000 * 10^((uplink_power - receiver_sensitivity_ul_4g - 20*log10(uplink_carrier_frequency_4g) - 92.45)/20);
    BaseStations(i).uplink_radius_5g = 1000 * 10^((uplink_power - receiver_sensitivity_ul_5g - 20*log10(uplink_carrier_frequency_5g) - 92.45)/20);
    BaseStations(i).downlink_radius_4g = 1000 * 10^((downlink_power - receiver_sensitivity_dl_4g - 20*log10(downlink_carrier_frequency_4g) - 92.45)/20);
    BaseStations(i).downlink_radius_5g = 1000 * 10^((downlink_power - receiver_sensitivity_dl_5g - 20*log10(downlink_carrier_frequency_5g) - 92.45)/20);
    BaseStations(i).backhaul_radius_4g = 1000 * 10^((backhaul_power - receiver_sensitivity_bh_4g - 20*log10(backhaul_carrier_frequency_4g) - 92.45)/20);
    BaseStations(i).backhaul_radius_5g = 1000 * 10^((backhaul_power - receiver_sensitivity_bh_5g - 20*log10(backhaul_carrier_frequency_5g) - 92.45)/20);
end