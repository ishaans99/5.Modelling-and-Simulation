fig = figure;
hold on
for i = 1:6
    PlotBoi = ones(100000,1) * RSS(i, 4)/R0;
    plot(t, PlotBoi, "--") 
end
legend(["\theta = 300","\theta = 400","\theta = 500","\theta = 600","\theta = 700","\theta = 800"], "Location", "Best")
for i = 1:6
    PlotBoi = reshape(R(i,4,:), [100000, 1]);
    plot(t, PlotBoi/R0, 'HandleVisibility','off')
end
xlabel("time")
ylabel("R/R_0 at v_p = 0.15")
title("R/R_0 at v_p = 0.15 as function of time")
print(fig,'Figure6','-dpng', '-r450')