function BaseStations = getUsersInRange(Users, BaseStations)



    for i = 1:length(BaseStations)
        BaseStations(i).users_4g = 0;
        BaseStations(i).users_5g = 0;
        for j = 1:length(Users)
            if sqrt((Users(j).x - BaseStations(i).x)^2 + (Users(j).y - BaseStations(i).y)^2) <= 100
                BaseStations(i).users_5g = BaseStations(i).users_5g + 1;
            elseif sqrt((Users(j).x - BaseStations(i).x)^2 + (Users(j).y - BaseStations(i).y)^2) <= 1000
                BaseStations(i).users_4g = BaseStations(i).users_4g + 1;
            end   
        end
    end
end