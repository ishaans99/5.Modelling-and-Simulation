GenCost;
BestCost;
DaParents;
subplot(2,1,1)
loglog(1:100,GenCost,1:100,DaParents,1:100,BestCost);
legend(["Mean Generation Cost", "Mean Parent Cost", "Best Performer Cost"])
xlabel("Generation")
ylabel("Cost")
title("Convergence Plot")

subplot(2,1,2)
loglog(1:100,DaParents,1:100,BestCost);
xlabel("Generation")
ylabel("Cost")
title("Convergence Plot")
legend(["Mean Parent Cost", "Best Performer Cost"])
