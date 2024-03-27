% avg step 0.7m
% 1.67 steps/s
% 1 step/ 0.6 s
% update every 0.6 sec, and move user 0.7m in direction 

function Users = moveUsers(Users, time, grid)
    steps = time/0.6;
    distance = steps*0.7;
    for i = 1:length(Users)
        x = rand(1)*distance; % rand double between 0->distance
        y = sqrt(power(distance,2) - power(x,2));
        switch Users(i).direction
            case 0
                return
            case 1
                Users(i).x = Users(i).x - x;
                Users(i).y = Users(i).y + y;
            case 2
                Users(i).x = Users(i).x + x;
                Users(i).y = Users(i).y + y;
            case 3
                Users(i).x = Users(i).x + x;
                Users(i).y = Users(i).y - y;
            case 4
                Users(i).x = Users(i).x - x;
                Users(i).y = Users(i).y - y;
        end
    if Users(i).x > grid(1)
        Users(i).x = grid(1);
        Users(i).direction = 0;
    elseif Users(i).y > grid(2)
        Users(i).y = grid(2);
        Users(i).direction = 0;
    end
    end
end

