tic
CharArea = 1;
DragCoeff = 0.25;
AgentM = 10;
PropFMag = 200;
AirV = 0;
RhoA = 1.225;
DeltaT = 0.2;
MaxTaskT = 60;

agent_sight = 5;
crash_range = 2;
NumAgent = 15;
NumObj = 25;
NumTar = 100;

children = 6;
parents = 6;
S = 20;
G = 100;
w1 = 70;
w2 = 10;
w3 = 20;

PI = zeros(G, S);
Orig = zeros(G, S);
Fitness = zeros(S, 1);
StringRatios = zeros(G, S, 3);
dv = 15;
OSiteration = ones(2, dv);
OSoverall = ones(parents, dv);


ObjPos = [rand(NumObj, 1)*200-100, rand(NumObj, 1)*200-100, rand(NumObj, 1)*20-10];
TarPos = [rand(NumTar, 1)*200-100, rand(NumTar, 1)*200-100, rand(NumTar, 1)*20-10];
AgentPos = [linspace(-150,-110,NumAgent)', linspace(-10,10,NumAgent)', linspace(-10,10,NumAgent)'];
AgentV = zeros(NumAgent,3);
Lambda = rand(S, dv)*2;

GenerationCost = zeros(G, 1);
ParentCost = zeros(G, 1);
BestCost = zeros(G, 1);

for i = 1:G
    for j = 1:S
        if i > 1 && j < parents + 1
            Fitness(j) = PI(i-1, j);
            StringRatios(i, j, :) = StringRatios(i-1, Orig(i-1, j), :);
            continue
        end
        Params = Lambda(j,:);
        AgentTarWeight = Params(1);
        AgentObjWeight = Params(2);
        AgentAgentWeight = Params(3);
        AttractiveTarWeight = Params(4);
        RepulsiveTarWeight = Params(5);
        AttractiveObjWeight = Params(6);
        RepulsiveObjWeight = Params(7);
        AttractiveAgentWeight = Params(8);
        RepulsiveAgentWeight = Params(9);
        AttractiveTarExp = Params(10);
        RepulsiveTarExp = Params(11);
        AttractiveObjExp = Params(12);
        RepulsiveObjExp = Params(13);
        AttractiveAgentExp = Params(14);
        RepulsiveAgentExp = Params(15);
        time = 0;
        InitialAgentPos = AgentPos;
        InitialTarPos = TarPos;
        InitialV = AgentV;
        while sum(sum(~isinf(InitialTarPos)))/3 > 0 && sum(sum(~isinf(InitialAgentPos)))/3 > 0 && time < MaxTaskT 
            time = time + DeltaT;
            NewAgentPos = InitialAgentPos;
            NewTarPos = InitialTarPos;
            for k = 1:NumAgent
                if (abs(InitialAgentPos(k,1)) > 150) || (abs(InitialAgentPos(k,2)) > 150) || (abs(InitialAgentPos(k,3)) > 60)
                    NewAgentPos(k, :) = Inf;
                end
                AgentTarInt = zeros(1,3);
                AgentObjInt = zeros(1,3);
                AgentAgentInt = zeros(1,3);
                for l = 1:NumTar
                    if any(InitialAgentPos(k, :) == Inf)
                        NewAgentPos(k, :) = Inf;
                        break
                    end
                    if any(InitialTarPos(l, :) == Inf)
                        NewTarPos(l, :) = Inf;
                        continue
                    end
                    diff = InitialAgentPos(k, :) - InitialTarPos(l, :);
                    dist = norm(diff);
                    if dist == Inf || all(isnan(dist))
                        continue
                    end
                    if dist < agent_sight
                        NewTarPos(l, :) = Inf;
                        continue
                    end
                    UnitVec = diff/dist;
                    NormalisedInt = (AttractiveTarWeight*exp(-AttractiveTarExp*dist) ...
                        - RepulsiveTarWeight*exp(-RepulsiveTarExp*dist))*UnitVec;
                    if all(NormalisedInt ~= Inf) && ~(any(isnan(NormalisedInt)))
                        AgentTarInt = AgentTarInt + NormalisedInt;
                    end
                end
                for m = 1:NumAgent
                    if k == m
                        continue
                    end
                    if any(InitialAgentPos(k, :) == Inf)
                        NewAgentPos(k, :) = Inf;
                        break
                    end
                    
                    if any(InitialAgentPos(m, :) == Inf)
                         NewAgentPos(m, :) = Inf;
                         continue
                    end    
                    diff = InitialAgentPos(k, :) - InitialAgentPos(m, :);
                    dist = norm(diff);
                    if dist == Inf || all(isnan(dist))
                        continue
                    end
                    if dist < crash_range
                        NewAgentPos(m, :) = Inf;
                        NewAgentPos(k, :) = Inf;
                        continue
                    end
                    UnitVec = diff/dist;
                    NormalisedInt = (AttractiveAgentWeight*exp(-AttractiveAgentExp*dist) ...
                        - RepulsiveAgentWeight*exp(-RepulsiveAgentExp*dist))*UnitVec;
                    if all(NormalisedInt ~= Inf) && ~(any(isnan(NormalisedInt)))
                        AgentAgentInt = AgentAgentInt + NormalisedInt;
                    end
                end
                for o = 1:NumObj
                    if any(InitialAgentPos(k, :) == Inf)
                        NewAgentPos(k, :) = Inf;
                        break
                    end
                    diff = InitialAgentPos(k, :) - ObjPos(o, :);
                    dist = norm(diff);
                    if dist == Inf || all(isnan(dist))
                        continue
                    end
                    if dist < crash_range
                        NewAgentPos(k, :) = Inf;
                        continue
                    end
                    UnitVec = diff/dist;
                    NormalisedInt = (AttractiveObjWeight*exp(-AttractiveObjExp*dist) ...
                        - RepulsiveObjWeight*exp(-RepulsiveObjExp*dist))*UnitVec;
                    if all(NormalisedInt ~= Inf) && ~(any(isnan(NormalisedInt)))
                        AgentObjInt = AgentObjInt + NormalisedInt;
                    end
                end
                
%                 if any(InitialAgentPos(k, :) == Inf)
%                     NewAgentPos(k, :) = Inf;
%                     break
%                 end 
                
                TotalN = AgentTarWeight*AgentTarInt + AgentAgentWeight*AgentAgentInt + AgentObjWeight*AgentObjInt;
                NormTotalN = norm(TotalN);
                NormailsedTotalN = TotalN/NormTotalN;
                DragForce = 1/2*RhoA*DragCoeff*CharArea*norm(InitialV(k,:) - AirV)*(AirV - InitialV(k,:));
                TotalForce = PropFMag * NormailsedTotalN + 5 * DragForce;
                NewAgentPos(k, :) =  NewAgentPos(k, :) + InitialV(k, :)*DeltaT;
                InitialV(k, :) = InitialV(k, :) + TotalForce*DeltaT/AgentM;
            end
            InitialAgentPos = NewAgentPos;
            InitialTarPos = NewTarPos;
            AgentCrash = sum(sum(isinf(InitialAgentPos(:,1))));
            TarUnmapped =  sum(sum(~isinf(InitialTarPos(:,1))));
        end
        Fitness(j) = w1 * TarUnmapped/NumTar + w2 * time/MaxTaskT + w3 * AgentCrash/NumAgent;
        StringRatios(i, j, :) = [TarUnmapped/NumTar, time/MaxTaskT, AgentCrash/NumAgent];
    end 
theStrings = Lambda;
[SortedOrder, IndexArray] = sort(Fitness);
PI(i, :) = SortedOrder;
Orig(i, :) = IndexArray;

GenerationCost(i) = mean(Fitness);
ParentCost(i) = mean(Fitness(1:parents));
BestCost(i) = SortedOrder(1);
fprintf("Generation %d completed, best cost so far is %d", i, PI(i, 1))
fprintf("\n")
%if PI(i, 1) < 10
%    break
%end
    for p = 1:parents/2
            theStrings(2*p-1, :) = Lambda(Orig(i, 2*p-1), :);
            theStrings(2*p, :) = Lambda(Orig(i, 2*p), :);
            for q = 1:2
                randomPhi = rand(1,dv)*2-0.5;
                OSiteration(q, :) = theStrings(2*p-1, :).*randomPhi + theStrings(2*p, :).*(1-randomPhi);
            end
            OSoverall(2*p-1:2*p, :) = OSiteration;
     end
        theStrings(parents+1:2*parents, :) = OSoverall;
        theStrings(2*parents+1:S, :) = rand(S-(2*parents), dv)*2;
        Lambda = theStrings;
end
toc