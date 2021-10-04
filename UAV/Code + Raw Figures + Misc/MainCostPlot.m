hold on
plot(1:100, GenerationCost);
plot(1:100, ParentCost);
plot(1:100, BestCost);
xlabel("Generation");
ylabel("Cost");
legend("Mean Population Cost","Mean Parent Cost", "Best Performer Cost");
title("Cost vs. Generation"); 
hold off