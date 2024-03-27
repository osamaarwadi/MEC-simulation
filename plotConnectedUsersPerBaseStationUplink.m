function plotConnectedUsersPerBaseStationUplink(Users, BaseStations)

    y = zeros(1, length(BaseStations));
    for i = 1:length(Users)
        x = Users(i).uplink_basestation;
        if isnumeric(x)
            y(x) = y(x) + 1;
        end
    end

    bar(y);
end