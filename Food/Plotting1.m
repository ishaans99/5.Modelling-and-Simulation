fig = figure;
hold on
for i = 1:6
plot(t,J(:,i))
end
legend({"v_p = 0","v_p = 0.05","v_p = 0.10","v_p = 0.15","v_p = 0.20","v_p = 0.25"})
xlabel("Time")
ylabel("J(t)")
title("Current as function of time")
print(fig,'Figure 2','-dpng', '-r300')