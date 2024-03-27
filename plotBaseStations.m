function plotBaseStations(BS)
    
    bs_x = [];
    bs_y = [];

    bsmec_x = [];
    bsmec_y = [];

    for i = 1:length(BS)
        if ~BS(i).is_MEC
            bs_x(end + 1) = BS(i).x;
            bs_y(end + 1) = BS(i).y;
        else
            bsmec_x(end + 1) = BS(i).x;
            bsmec_y(end + 1) = BS(i).y;
        end
    end
    scatter(bs_x, bs_y, 75, [0.6350 0.0780 0.1840], '^');
    hold on
    scatter(bsmec_x, bsmec_y, 75, [0.6350 0.0780 0.1840], 'filled', '^');

    title('Grid');
    xlabel('X grid (m)'); 
    ylabel('Y grid (m)');
    legend({'Connected Users', 'Disconnected Users', 'BaseStations', 'MEC'},'Location','northeast')

end
