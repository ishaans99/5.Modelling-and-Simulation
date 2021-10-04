hold on
loglog(1:1000, GenerationCost);
loglog(1:1000, ParentCost);
loglog(1:1000, BestCost);
xlabel("Generation");
ylabel("Cost");
legend("Mean Population Cost","Mean Parent Cost", "Best Performer Cost");
title("Cost vs. Generation"); 
hold off