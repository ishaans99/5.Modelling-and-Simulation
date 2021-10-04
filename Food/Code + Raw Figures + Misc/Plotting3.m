fig = figure;
hold on
for i = 1:6
plot(t,RyanReynolds(:,i))
end
legend({"v_p = 0","v_p = 0.05","v_p = 0.10","v_p = 0.15","v_p = 0.20","v_p = 0.25"}, "Location", "Best")
xlabel("Time")
ylabel("Reynolds number Rec")
title("Reynolds number as function of time")
print(fig,'Figure4','-dpng', '-r600')