%efficiency_boi = 0.05;
%explosive_heat = 3 * 10^6;
Rho_p = 2000;
R_p = 0.005;
m_i = 4/3*pi*R_p^3*Rho_p; 
rho_a = 1.225;
N_p = 100;
R_firework = 0.2;
r = [0;0;0];
theta = 2 * pi * rand(N_p,1);
phi = acos(1 - 2*rand(N_p,1));
x_coords = sin(phi).*cos(theta);
y_coords = sin(phi).*sin(theta);
z_coords = cos(phi);
%global sphere_bois
sphere_bois = [x_coords,y_coords,z_coords]';
scaled_bois = R_firework * sphere_bois;
r_i = r + scaled_bois;
%deltaV = sqrt(2*efficiency_boi*explosive_heat*m_e/m_p);
deltaV = 300;
deltaT = 0.01;
tf = 100;
v = [0;0;0];
v_i = v + deltaV*sphere_bois;
velocity_boi = zeros(10001, 1);
poisition_boi = zeros(10001, 1);
velocity_boi(1) = vecnorm(v_i(:,1));
position_boi(1) = vecnorm(r_i(:,1));
counter = 1;
A_p = pi * R_p ^ 2;
F_grav_ejecta = -9.81*m_i*[0;0;1];
flag_boi = ones(1,N_p);
flight_times = inf * ones(1,N_p);
projectile_time = 0;
mu_a = 1.8*10^-5;

while counter < 10001
    counter = counter + 1;
    projectile_time = projectile_time + deltaT;
    boolean_boi = (flag_boi == 1);
    diff_bois = r_i(:, boolean_boi) - r;
    vec_bois = vecnorm(diff_bois);
    norm_bois = diff_bois./vec_bois;
    RyanReynolds = 2 * R_p * rho_a * vec_bois/mu_a;
    Cdr_ejecta = arrayfun(@computeCD,RyanReynolds);
    F_dr_ejecta = A_p/2*rho_a*Cdr_ejecta.*vecnorm(-v_i(:, boolean_boi)).*(-v_i(:, boolean_boi));
    F_total_ejecta = F_dr_ejecta; 
    %+ F_grav_ejecta;
    r_i(:, boolean_boi) = r_i(:, boolean_boi) + deltaT * v_i(:, boolean_boi);
    v_i(:, boolean_boi) = v_i(:, boolean_boi) + deltaT * F_total_ejecta/m_i;
    position_boi(counter) = vecnorm(r_i(:,1));
    velocity_boi(counter) = vecnorm(v_i(:,1));
    vertical_component = r_i(3,:);
    special_boolean_boi = boolean_boi & vertical_component <= 0;
    r_i(3, special_boolean_boi) = 0;
    flight_times(special_boolean_boi) = projectile_time;
    flag_boi(special_boolean_boi) = 0;
    if projectile_time > 200
        flight_times(isinf(flight_times)) = projectile_time;
        break
    end
end
time_bois = 0:deltaT:100;
subplot(2,1,1)
semilogy(time_bois,velocity_boi(1:10001))
ylabel("Velocity (m/s)")
xlabel("Time (s)")
title("Semilog Plot of Velocity vs. Time")

subplot(2,1,2)
plot(time_bois,position_boi(1:10001))
ylabel("Distance (m/s)")
xlabel("Time (s)")
title("Plot of Distance vs. Time")


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