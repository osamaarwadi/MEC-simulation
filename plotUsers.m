function plotUsers(U)

not_connected_x = [];
not_connected_y = [];
connected_x = [];
connected_y = [];

    for i = 1:length(U)
        if ~isnumeric(U(i).uplink_basestation)
            not_connected_x(end + 1) = U(i).x;
            not_connected_y(end + 1) = U(i).y;
        else
            connected_x(end + 1) = U(i).x;
            connected_y(end + 1) = U(i).y;
        end
    end

    scatter(connected_x, connected_y, 15, [0 0.486 0.788], 'filled');
    hold on
    scatter(not_connected_x, not_connected_y, 15, [0.176, 0.271, 0.329], 'filled');


end