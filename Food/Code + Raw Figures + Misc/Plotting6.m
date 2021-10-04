fig = figure;
hold on
for i = 1:6
    plot(temperatures, RSS(:,i))
end
legend(["v_p = 0","v_p = 0.05","v_p = 0.10","v_p = 0.15","v_p = 0.20","v_p = 0.25"], "Location", "Best")
xlabel("Temperature")
ylabel("RSS")
title("RSS for different v_p")
print(fig,'Figure7','-dpng', '-r450')