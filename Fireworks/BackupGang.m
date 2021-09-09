m_e = 0.015;
m_f = 2;
t_e = 5;
N_p = 100;
theta = 2 * pi * rand(N_p,1);
phi = acos(1 - 2*rand(N_p,1));
x_coords = sin(phi).*cos(theta);
y_coords = sin(phi).*sin(theta);
z_coords = cos(phi);
%global sphere_bois
sphere_bois = [x_coords,y_coords,z_coords]';


%function return_something = cost_boi(m_e, m_f, t_e)
%Firework modeling
r_initial = [0;0;0];
r = r_initial;
efficiency_boi = 0.05;
explosive_heat = 3 * 10^6;
%This is a genetic string param
%m_f = 2;
m_s = 2;
%This is a genetic string param
%m_e = 0.01;
R_p = 0.005;
Rho_p = 2000;
N_p = 100;

m_i = 4/3*pi*R_p^3*Rho_p; 
m_p = N_p * m_i;
m_r = m_s + m_e + m_p;
v_initial = [0;0;sqrt((2*efficiency_boi*explosive_heat*m_f)/m_r)];
v = v_initial;
rho_a = 1.225;

R_firework = 0.2;
mu_a = 1.8*10^-5;
deltaT = 0.05;
%This is a genetic string param
%t_e = 5;
num_steps = t_e/deltaT;
time = 0;

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
        break
    end   
end

%Ejecta modelling gang
%global sphere_bois
scaled_bois = R_firework * sphere_bois;
r_i = r + scaled_bois;
deltaV = sqrt(2*efficiency_boi*explosive_heat*m_e/m_p);
v_i = v + deltaV*sphere_bois;
A_p = pi * R_p ^ 2;
F_grav_ejecta = -9.81*m_i*[0;0;1];
flag_boi = ones(1,N_p);
flight_times = inf * ones(1,N_p);
projectile_time = 0;
while any(isinf(flight_times))    
    projectile_time = projectile_time + deltaT;
    boolean_boi = (flag_boi == 1);
    diff_bois = r_i(:, boolean_boi) - r;
    vec_bois = vecnorm(diff_bois);
    norm_bois = diff_bois./vec_bois;
    RyanReynolds = 2 * R_p * rho_a * vec_bois/mu_a;
    Cdr_ejecta = arrayfun(@computeCD,RyanReynolds);
    F_dr_ejecta = A_p/2*rho_a*Cdr_ejecta.*vecnorm(-v_i(:, boolean_boi)).*(-v_i(:, boolean_boi));
    F_total_ejecta = F_dr_ejecta + F_grav_ejecta;
    r_i(:, boolean_boi) = r_i(:, boolean_boi) + deltaT * v_i(:, boolean_boi);
    v_i(:, boolean_boi) = v_i(:, boolean_boi) + deltaT * F_total_ejecta/m_i;
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
%end
%norm_bois = sphere_bois/
scatter3(x_coords, y_coords, z_coords)
scatter3(r_i(1,:),r_i(2,:),r_i(3,:))

index_boi = find(flight_times == max(flight_times));
surface_area = 4 * pi * R_p^2;
time_temp_array = ones(1, round(max(flight_times)/deltaT));
Q_r = ones(1, round(max(flight_times)/deltaT));
Q_c = ones(1, round(max(flight_times)/deltaT));
increment = 1;
theta_0 = 2000;
theta_a = 300;
time_temp_array(increment) = theta_0;
eps = 1;
sigma =5.67*10^-8;
Q_r(increment) = eps*sigma*surface_area*(theta_a^4 - time_temp_array(increment)^4);
h = 100;
Q_c(increment) = h*surface_area*(theta_a - time_temp_array(increment));
C_p = 200;
while increment < round(max(flight_times)/deltaT) + 1
    theta_dot = ((Q_r(increment) + Q_c(increment))/(m_i * C_p));
    increment = increment + 1;
    time_temp_array(increment) = time_temp_array(increment - 1) + deltaT * theta_dot;
    Q_r(increment) = eps*sigma*surface_area*(theta_a^4 - time_temp_array(increment)^4);
    Q_c(increment) = h*surface_area*(theta_a - time_temp_array(increment));
end
interpolated_temp = interp1(0:deltaT:max(flight_times), time_temp_array, flight_times);

m_e_max = 1;
w1 = 10;
w2 = 1;
w3 = 10;
w4 = 100;
w5 = weight_func(m_e, m_e_max);
h_goal = 500;
r_goal = 100;
theta_goal = theta_a;
Cost123 = w1* (m_e+m_f) + w2 * (max(vecnorm(r_i))-r_goal)^2 + w3 * (vecnorm(r(3))-h_goal)^2; 
Cost45 = w4 * (max(interpolated_temp) - theta_goal)^2 + w5 * (m_e - m_e_max);
Cost = Cost123 + Cost45;
%Don't allow negative parameters
%Check if velocity is too much

% theStrings = Lambda;
% OSiteration = ones(2, dv);
% OSoverall = ones(parents, dv);
% % Fitness(1:end) = costFunction(Lambda(1:end,:));
% [SortedOrder, IndexArray] = sort(Fitness);
% PI(i, :) = SortedOrder;
% Orig(i, :) = IndexArray;
% if PI(i, 1) < 15
%     break
% end
%     for p = 1:parents/2
%             theStrings(2*p-1, :) = Lambda(Orig(i, 2*p-1), :);
%             theStrings(2*p, :) = Lambda(Orig(i, 2*p), :);
%             for q = 1:2
%                 randomPhi = rand(1,dv);
%                 OSiteration(q, :) = theStrings(2*p-1, :).*randomPhi + theStrings(2*p, :).*(1-randomPhi);
%             end
%             OSoverall(2*p-1:2*p, :) = OSiteration;
%      end
%         theStrings(parents+1:2*parents, :) = OSoverall;
%         theStrings(2*parents+1:S, :) = rand(S-(2*parents), dv)*2;
%         Lambda = theStrings;       
% end


%arrayfun(@computeCD,[2;3])
function w5 = weight_func(m_e_boi, m_e_max)
if m_e_boi > m_e_max
    w5 = 10;
else
    w5 = 0;
end
end


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