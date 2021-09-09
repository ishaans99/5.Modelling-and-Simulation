tic
r0 = [0; 0.5; 0];
theta01 = pi/2;
theta02 = 0;
theta03 = 0;
thetadot1 = 0.2;
thetadot2 = -0.2;
thetadot3 = 10;
Lbed = 0.8;
L1 = 0.3;
L2 = 0.2;
L3 = 0.08;
g = 9.81;
epsilon = 8.854 * 10^-12;
R = 0.001;
volume = 4/3*pi*R^3;
v2 = 0.25;
rho1 = 2000;
rho2 = 7000;
q1 = 0;
q2 = 0.001;
deltaVD = [0; -1.2; 0];
qp = -8 * 10^-5;
vf = [0.5; 0; 0.5];
rhoA = 1.225;
muf = 1.8 * 10^-5;
dragArea = pi * R^2;
dt = 0.001;
T = 3;
%CONSIDER INCLUDING SEARCH BOUNDS HERE?
rhoEff = (1 - v2) * rho1 + v2 * rho2;
qEff = (1 - v2) * q1 + v2 * q2;
mass = volume * rhoEff;
qi = volume * qEff;
times = dt:dt:T;
gForce = mass * [0;-g;0];

xvalues = linspace(-Lbed/2, Lbed/2, 10);
zvalues = linspace(-Lbed/2, Lbed/2, 10);
rp = zeros(3, 100);
for j = 1:10
    for k = 1:10
        rp(:, 10*(j-1)+k) = [xvalues(j);0;zvalues(k)];
    end
end

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

sized = size(times);
flagArray = ones(1,sized(2));
droptimes = zeros(1,sized(2));

time = 0;

while true
    time = time + dt;
    diffbois = vf - vi(:, flagArray == 1);
    normedbois = vecnorm(diffbois);
    RyanReynolds = 2*R*rhoA*normedbois/muf;
    Cd = ones(1, numel(normedbois));
    %Cd(1:end) = computeCD(RyanReynolds(1:end));
    for j = 1:numel(normedbois)
        Cd(j) = computeCD(RyanReynolds(j));
    end
    dragForce = rhoA/2.*Cd.*normedbois.*dragArea.*diffbois; 
    validDrops = ri(:, flagArray == 1);
    [rownum,colnum]=size(validDrops);
    electroForce = ones(rownum, colnum);
    for i = 1:colnum
        rdiffbois = validDrops(:, i) - rp;
        electroForce(:,i) =  qi*qp*rdiffbois/(4*pi*epsilon*vecnorm(rdiffbois).^3);
    end
    totalF = electroForce + dragForce + gForce;
    ri(:, flagArray == 1) = ri(:, flagArray == 1) + dt * vi(:, flagArray == 1);
    vi(:, flagArray == 1) = vi(:, flagArray == 1) + totalF*dt/mass;
    e2values = ri(2, :);
    e2indices = find(e2values <= 0);
    if numel(e2indices) > 0
        ri(2, e2indices) = 0;
        droptimes(droptimes(e2indices) == 0) = time;
        flagArray(e2indices) = 0;
    end
    if all(ri(2, :) == 0)
        break
    end
    disp(time)
end
toc

function Cd = computeCD(x)
if (0 < x) && (x <=1)
    Cd = x/24;
    return
end
if 1 < x && x <= 400
    Cd = 24/(x^0.0646);
    return
end
if 400 < x && x <= 3*10^5
    Cd = 0.5;
    return
end
if 3*10^5 < x && x <= 2 * 10^6
    Cd = 0.000366*x^0.4275;
    return
end
Cd = 0.18;
end


