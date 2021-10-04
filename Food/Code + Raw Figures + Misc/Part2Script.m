R0 = 0.001;
q = 2;
vm = 0.01;
Q0 = pi * R0^2 * vm;
muFluid0 = 0.001;
rhoFluid = 2000;
rho1 = rhoFluid;
rhoParticle = 4000;
rho2 = rhoParticle;
theta0 = 300;
critShear = 0.001;
nu = 10^-5/3600;
c1 = 0.01;
c2 = 2;
deltaT2 = 3.6;
T = 360000;
k1 = 0.5;
k2 = 1;
k3 = 2;
v2 = 0:0.05:0.25;
thetaBar = 500;
t = deltaT2:deltaT2:T;
%Temperature is fixed
%rhoEff = (1 - v2) .* rhoFluid + v2 .* rhoParticle;
temperatures = 300:100:800;
muEff = zeros(numel(temperatures), numel(v2));
RSS = zeros(numel(temperatures), numel(v2));
R = zeros(numel(temperatures), numel(v2),numel(t));

for i = 1:numel(temperatures)
    for j = 1:numel(v2)
        muFluid = muFluid0 * exp(-k1*((temperatures(i)-theta0)/theta0));
        muEff(i,j) = muFluid.*(1 + 2.5.*(v2(j)./(1-v2(j))));
        RSS(i,j) = (muEff(i,j) * Q0 * (q+2)/(pi * critShear)).^(1/3);
        Rcopy = R0;
        for k = 1:numel(t)
            Rdot = nu*max((muEff(i,j) .* Q0 .* (q+2))/(pi .* critShear .* Rcopy.^3) -1, 0);
            Rcopy = Rcopy + Rdot * deltaT2;
            R(i,j,k) = Rcopy;
        end  
    end
end
