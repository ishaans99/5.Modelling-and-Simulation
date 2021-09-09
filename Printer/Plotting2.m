hold off
scatter3(z,x,y, 5, times, "filled")
c = colorbar;
c.Label.String = "Time (in s)";
hold on
scatter3(ri(3,:), ri(1,:), ri(2,:), 5, droptimes, "filled")
xlabel("ri(3,:) coordinates")
ylabel("ri(1,:) coordinates")
zlabel("ri(2,:) coordinates")
title("Figure 3: Extruder and Droplet Locations") 
h = zeros(4);
h(1) = scatter3(z(1),x(1),y(1), 30, 'r', "filled");
h(2) = scatter3(z(end),x(end),y(end), 30, 'y', "filled");
h(3) = scatter3(ri(3,1), ri(1,1), ri(2,1), 30, 'o', "filled");
h(4) = scatter3(ri(3,end), ri(1,end), ri(2,end), 30, 'g', "filled");
legend(h(1:4), "Initial Extruder Position", "Final Extruder Position", "First Droplet Location", "Final Droplet Location")