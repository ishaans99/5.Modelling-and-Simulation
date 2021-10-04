muFluid0 = 0.001;
sigmaFluid0 = 0.617;
sigmaParticle0 = 0.13;
rhoFluid0 = 2000;
rhoParticle0 = 4000;
cFluid = 1600;
cParticle = 3800;
c1 = 0.01;
c2 = 2;
R = 0.001;
Q0 = 10^-6;
b = .25;
omega = 12;
h = 10;
theta0 = 300;
thetaA = 300;
thetaDot = 50;
deltaT = 0.01;
T = 2.5;
a = 0.8;
k1 = 0.5;
k2 = 1;
k3 = 2;
v2 = 0:0.05:.25;
phi = 0.5;

t = (deltaT:deltaT:T)';
rhoEff = (1 - v2) .* rhoFluid0 + v2 .* rhoParticle0; 
cEff = (1 - v2) .* cFluid + v2 .* cParticle;
Q = Q0*(1 + b * sin(omega*t));
theta = theta0 + thetaDot * t;

%Meant to be Nt x 6 for some reason?
muFluid = muFluid0 * exp(-k1*((theta-theta0)/theta0));
sigmaFluid = sigmaFluid0 * exp(-k2*((theta-theta0)/theta0));
sigmaParticle = sigmaParticle0 * exp(-k3*((theta-theta0)/theta0));
denom1 = 1./(sigmaParticle - sigmaFluid);
sigmaLower = sigmaFluid + v2./(denom1 + (1-v2)./(3*sigmaFluid));
sigmaUpper = sigmaParticle + (1-v2)./(1./(sigmaFluid - sigmaParticle) + v2./(3*sigmaParticle));
muEff = muFluid.*(1 + 2.5.*(v2./(1-v2)));
sigmaEff = phi*sigmaLower + (1-phi)*sigmaUpper;

S = h*(theta-thetaA)/R;
thetastar = theta + deltaT * thetaDot;
J = sqrt(sigmaEff/a .* (rhoEff .* cEff .* ((thetastar - theta)./deltaT) + S));
gammaEff = 2.*c1.*Q.*rhoEff./(pi.*R.*muEff);
q = (1/2).*((gammaEff + c2) + sqrt((gammaEff + c2).^2 + 8 * gammaEff));
vmax = (Q0.*(q+2))./(pi * R^2 * q);
RyanReynolds = rhoEff.*vmax.*2.*R./muEff;
PressureGrad = -2*muEff.*(q + 2)./(pi * R^4).*Q0;

