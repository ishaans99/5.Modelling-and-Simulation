ElecCond = 5 * 10^5;
Rho = 6000;
c = 1000;
ThermCond = 400;
Theta0 = 300;
L = 0.01;
E = [100;0;0];
J = ElecCond*E;
a = 0.9;
FinalT = 1;
deltaT = 10^-5;
BC = [Theta0, Theta0+200];
NumNodes = [3, 11, 21];
for i = 1:3
    position = linspace(0, L, NumNodes(i))';
    HeatTerm = a * J' * E * ones(NumNodes(i), 1);
    A = zeros(NumNodes(i), NumNodes(i));
    for j = 1:NumNodes(i)-2
        A(j+1, :) = [zeros(j-1, 1)', 1, -2, 1, zeros(NumNodes(i)-2-j, 1)'];
    end
    deltaX = position(2) - position(1);
    Abar = ThermCond*A/(deltaX^2);
    for j = 1:2
        HeatTerm(1) = 0;
        HeatTerm(NumNodes(i)) = 0;
        Temp = [ones(NumNodes(i) - 1,1)*Theta0; BC(j)];
        TempMatrix = zeros(5, numel(Temp));
        counter = 0;
        for k = 1:(FinalT/deltaT)
            Temp = Temp + deltaT/(Rho*c)*(HeatTerm + Abar*Temp);
            if rem(k, 20000) == 0
               counter = counter + 1;
               TempMatrix(counter, :) = Temp';
            end
        end
        for k = 1:5
        cmap = colormap(jet(6));
        subplot(3, 2, (i-1)*2 + j)
        hold on
        if k == 1
            plot(position', Theta0 - HeatTerm'.*position'.^2/(2*ThermCond) +(BC(j)-BC(1))*position'/L + HeatTerm' .* L .* position'/(2* ThermCond), 'Color',cmap(k,:),'LineWidth',2)
        end
        plot(position', TempMatrix(k, :), 'Color',cmap(k+1,:))
        xlabel("x (m)")
        ylabel("T (K)")
        title(["Boundary condition:" + j "Nodes:" + NumNodes(i)])
        if k == 5
            lgd = legend(["Steady state", "0.20 s", "0.40 s", "0.60 s", "0.80 s", "1.00 s"], "location", "best");
            %resizeLegend(lgd)
            lgd.NumColumns = 2;
        end
        end
    end
end