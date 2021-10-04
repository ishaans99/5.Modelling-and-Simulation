desired = load("robotprint_data.mat");
desired = desired.ri;
thetadot1bounds = [15, 16];
thetadot2bounds = [15, 16];
thetadot3bounds = [6, 7];
deltaVDbounds = [-3.5, -3];

r0 = [0; 0.5; 0];
theta01 = pi/2;
theta02 = 0;
theta03 = 0;
L1 = 0.3;
L2 = 0.2;
L3 = 0.08;
g = 9.81;
dt = 0.001;
T = 3;
times = dt:dt:T;

parents = 10;
TOL_GA = 2 * 10^-2;
G = 1000;
S = 100;
dv = 4;

Lambda = zeros(S, dv);
Lambda(:, 1) = rand(S,1) + 15;
Lambda(:, 2) = rand(S,1) + 15;
Lambda(:, 3) = rand(S,1) + 6;
Lambda(:, 4) = rand(S,1)/2 - 3.5;

PI = zeros(G, S);
Orig = zeros(G, S);
Fitness = ones(S, 1);
theStrings = Lambda;
OSiteration = ones(2, dv);
OSoverall = ones(parents, dv);

GenerationCost = zeros(G, 1);
ParentCost = zeros(G, 1);
BestCost = zeros(G, 1);

for i = 1:G
    for j = 1:S
        thetadot1 = Lambda(j,1);
        thetadot2 = Lambda(j,2);
        thetadot3 = Lambda(j,3);
        deltaVD = Lambda(j,4);
        
        theta1 = theta01 + thetadot1 * times;
        theta2 = theta02 + thetadot2 * times;
        theta3 = theta03 + thetadot3 * times;

        x = L1 * cos(theta1) + L2 * cos(theta2) + L3 * sin(theta3);
        y = L1 * sin(theta1) + L2 * sin(theta2);
        z = L3 * cos(theta3);

        xdot = -L1 * thetadot1 * sin(theta1) + -L2 * thetadot2 * sin(theta2) + L3 * thetadot3 * cos(theta3);
        ydot = L1 * thetadot1 * cos(theta1) + L2 * thetadot2 * cos(theta2);
        zdot = -L3 * thetadot3 * sin(theta3);

        rd = r0 + [x; y; z];
        vd = [xdot; ydot; zdot];

        ri = rd;
        vi = vd + deltaVD;
        
        tstar = (-vi(2,:) - sqrt(vi(2,:).^2 + 2*ri(2, :) .* g))/-g;
        ri(1,:) = ri(1,:) + vi(1,:).*tstar;
        ri(3,:) = ri(3,:) + vi(3,:).*tstar;
        ri(2,:) = 0;
        vi = vi - (g.* tstar .* [0;1;0]);
        Fitness(j) = sum(vecnorm(desired-ri))/sum(vecnorm(diff(desired, 1, 2)));
    end
    theStrings = Lambda;
    [SortedOrder, IndexArray] = sort(Fitness);
    PI(i, :) = SortedOrder;
    Orig(i, :) = IndexArray;
    GenerationCost(i) = mean(Fitness);
    ParentCost(i) = mean(Fitness(1:parents));
    BestCost(i) = SortedOrder(1);
    for p = 1:parents/2
            theStrings(2*p-1, :) = Lambda(Orig(i, 2*p-1), :);
            theStrings(2*p, :) = Lambda(Orig(i, 2*p), :);
            for q = 1:2
                randomPhi = rand(1,dv);
                OSiteration(q, :) = theStrings(2*p-1, :).*randomPhi + theStrings(2*p, :).*(1-randomPhi);
            end
            OSoverall(2*p-1:2*p, :) = OSiteration;
     end
     theStrings(parents+1:2*parents, :) = OSoverall;
     theStrings(2*parents+1:S, 1) = rand(S-(2*parents),1) + 15;
     theStrings(2*parents+1:S, 2) = rand(S-(2*parents),1) + 15;
     theStrings(2*parents+1:S, 3) = rand(S-(2*parents),1) + 6;
     theStrings(2*parents+1:S, 4) = rand(S-(2*parents),1)/2 - 3.5;
     Lambda = theStrings;
     disp(i)
end




