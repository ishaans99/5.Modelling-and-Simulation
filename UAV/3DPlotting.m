scatter3(AgentPos(:,1), AgentPos(:,2), AgentPos(:,3), 10, 'r')
hold on
scatter3(TarPos(:,1), TarPos(:,2), TarPos(:,3), 10, 'b', '*')
scatter3(ObjPos(:,1), ObjPos(:,2), ObjPos(:,3), 10, 'g', 'x')
hold off
xlabel("x axis")
ylabel("y axis")
zlabel("z axis")
legend("Agents", "Targets", "Obstacles")
title("Time = 0")