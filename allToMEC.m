function [BaseStations] = allToMEC(BaseStations)

for i = 1:length(BaseStations)
    BaseStations(i).is_MEC = true;
end

end