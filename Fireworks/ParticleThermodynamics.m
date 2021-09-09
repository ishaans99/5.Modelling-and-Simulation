%index_boi = find(flight_times == max(flight_times));
Rho_p = 2000;
R_p = 0.005;
m_i = 4/3*pi*R_p^3*Rho_p; 
Num_time_steps = 10000;
deltaT = 0.01;
R_p = 0.005;
surface_area = 4 * pi * R_p^2;
time_temp_array = ones(1, Num_time_steps);
Q_r = ones(1, Num_time_steps);
Q_c = ones(1, Num_time_steps);
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
while increment < Num_time_steps + 1
    theta_dot = ((Q_r(increment) + Q_c(increment))/(m_i * C_p));
    increment = increment + 1;
    time_temp_array(increment) = time_temp_array(increment - 1) + deltaT * theta_dot;
    Q_r(increment) = eps*sigma*surface_area*(theta_a^4 - time_temp_array(increment)^4);
    Q_c(increment) = h*surface_area*(theta_a - time_temp_array(increment));
end
%interpolated_temp = interp1(0:deltaT:max(flight_times), time_temp_array, flight_times);
q_time_bois = 0:deltaT:100;
%plot(q_time_bois, time_temp_array)
%xlabel("Time (s)");
%ylabel("Temperature (K)");
%title("Temperature vs. Time for a Particle")
% subplot(2,1,1)
% semilogy(q_time_bois, Q_r)
% hl = title("$\dot{Q}_r vs. Time$");
% xlabel("Time (s)");
% hhh = ylabel("$\dot{Q}_r (W)$");
% set(hl, 'Interpreter', 'latex');
% set(hhh, 'Interpreter', 'latex');
 subplot(2,1,2)
 plot(q_time_bois, Q_c)
% hl = title("$\dot{Q}_c vs. Time$");
% xlabel("Time (s)");
% ylabel("$\dot{Q}_c (W)$", 'interpreter', 'latex')
% hhh = ylabel("$\dot{Q}_c (W)$");
% set(hhh, 'Interpreter', 'latex');
% set(hl, 'Interpreter', 'latex');



