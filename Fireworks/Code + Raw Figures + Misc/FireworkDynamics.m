%m_e = 0.015;
%m_f = 2;
%t_e = 5;
% N_p = 100;
% theta = 2 * pi * rand(N_p,1);
% phi = acos(1 - 2*rand(N_p,1));
% x_coords = sin(phi).*cos(theta);
% y_coords = sin(phi).*sin(theta);
% z_coords = cos(phi);
% %global sphere_bois
% sphere_bois = [x_coords,y_coords,z_coords]';


%function return_something = cost_boi(m_e, m_f, t_e)
%Firework modeling
r_initial = [0;0;0];
r = r_initial;
efficiency_boi = 0.05;
explosive_heat = 3 * 10^6;
%This is a genetic string param
%m_f = 2;
%m_s = 2;
%This is a genetic string param
%m_e = 0.01;
%R_p = 0.005;
%Rho_p = 2000;
%N_p = 100;

%m_i = 4/3*pi*R_p^3*Rho_p; 
%m_p = N_p * m_i;
%m_r = m_s + m_e + m_p;
m_r = 2;
%v_initial = [0;0;100];
%v = v_initial;
rho_a = 1.225;

R_firework = 0.2;
mu_a = 1.8*10^-5;
deltaT = 0.01;
%This is a genetic string param
%t_e = 5;
num_steps = round(14.37/deltaT);
time = 0;
r_bois = zeros(1, num_steps);
r_matrix = zeros(10, num_steps);
v_bois = 20:20:200;
for j = 1:10
    v = [0;0;v_bois(j)];
    for i = 1:num_steps
        time = time + deltaT;
        RyanReynolds = 2 * R_firework * rho_a * vecnorm(v)/mu_a;
        Cdr = computeCD(RyanReynolds);
        A_firework = pi * R_firework^2;
        F_dr = rho_a/2*Cdr*A_firework*vecnorm(-v)*(-v);
        F_grav = m_r * -9.81 * [0;0;1];
        F_total = F_dr + F_grav;
        r = r + deltaT * v;
        v = v + deltaT * F_total/m_r;
        if dot(r, [0;0;1]) <=0 && time > deltaT
            r = [r(1);r(2);0];
            r_bois(i:end) = 0;
            break
        end
        r_bois(i) = r(3);
    end
    r_matrix(j,:) = r_bois;
end

time_bois = 0:deltaT:14.36;
figure
hold on
cmap = colormap(jet(10));
legendboi = zeros(10,1);
for i = 1:10
    plot(time_bois, r_matrix(i,:), 'Color',cmap(i,:))
end
boi = ["v_0 = 20 m/s","v_0 = 40 m/s","v_0 = 60 m/s","v_0 = 80 m/s","v_0 = 100 m/s","v_0 = 120 m/s","v_0 = 140 m/s","v_0 = 160 m/s","v_0 = 180 m/s","v_0 = 200 m/s"];
legend(boi)
xlabel("Time (s)")
ylabel("Altitude (m)")
title("Altitude vs. Time for Different Values of v_0")



function Cd = computeCD(x)
if (0 < x) && (x <=1)
    Cd = x/24;
    return
end
if 1 < x && x <= 400
    Cd = 24/(x^0.646);
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