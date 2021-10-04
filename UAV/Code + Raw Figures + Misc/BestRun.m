Params = Lambda(1, :);
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
        while sum(sum(~isinf(InitialTarPos)))/3 > 0 && sum(sum(~isinf(InitialAgentPos)))/3 > 0 && time < 28.8
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