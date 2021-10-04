fig = figure;
for i = 1:6
    hold on
    PlotBoi = ones(100000,1) * RSS(3,i)/R0;
    plot(t, PlotBoi, "--") 
    hold off
end
legend(["v_p = 0","v_p = 0.05","v_p = 0.10","v_p = 0.15","v_p = 0.20","v_p = 0.25"], "Location", "Best")
for i = 1:6
    hold on
    PlotBoi = reshape(R(3,i,:), [100000, 1]);
    plot(t, PlotBoi/R0, 'HandleVisibility','off')
    hold off
end
xlabel("time")
ylabel("R/R_0 at temperature = 500 K")
title("R/R_0 at 500 K as function of time")
print(fig,'Figure5','-dpng', '-r450')