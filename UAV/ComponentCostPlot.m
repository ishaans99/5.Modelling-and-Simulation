for i = 1:100
    BestMap(i) = StringRatios(i, Orig(i,1), 1);
    ParentMap(i) = mean(StringRatios(i, Orig(i,1:6), 1));
    PopulationMap(i) = mean(StringRatios(i, :, 1));
    
    BestTime(i) = StringRatios(i, Orig(i,1), 2);
    ParentTime(i) = mean(StringRatios(i, Orig(i,1:6), 2));
    PopulationTime(i) = mean(StringRatios(i, :, 2));
    
    BestAgent(i) = StringRatios(i, Orig(i,1), 3);
    ParentAgent(i) = mean(StringRatios(i, Orig(i,1:6), 3));
    PopulationAgent(i) = mean(StringRatios(i, :, 3));
end

xval = 1:100;
plot(xval, BestMap, xval, ParentMap, xval, PopulationMap, xval, BestTime, xval, ParentTime, xval, PopulationTime, xval, BestAgent, xval, ParentAgent, xval, PopulationAgent);
legend("Best M*", "Parent M*", "Population M*", "Best T*", "Parent T*", "Population T*", "Best L*", "Parent L*","Population L*");
xlabel("Generation");
ylabel("Proportion");
title("Component Cost vs. Generation");
