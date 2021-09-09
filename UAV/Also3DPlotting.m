scatter3(InitialAgentPos(:,1), InitialAgentPos(:,2), InitialAgentPos(:,3), 10, 'r')
hold on
scatter3(InitialTarPos(:,1), InitialTarPos(:,2), InitialTarPos(:,3), 10, 'b', '*')
scatter3(ObjPos(:,1), ObjPos(:,2), ObjPos(:,3), 10, 'g', 'x')
hold off
xlabel("x axis")
ylabel("y axis")
zlabel("z axis")
legend("Agents", "Targets", "Obstacles")
title("Time = 28.6")