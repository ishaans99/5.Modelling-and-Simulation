 scatter(rp(3,:), rp(1,:), 10, "filled")
 hold on
 scatter(ri(3,:), ri(1,:), 7, droptimes, "filled")
 title("Figure 2: Grid points and droplets")
 xlabel("ri(3,:) coordinates")
 ylabel("ri(1,:) coordinates")
 c = colorbar;
 c.Label.String = 'Drop time (in s)';