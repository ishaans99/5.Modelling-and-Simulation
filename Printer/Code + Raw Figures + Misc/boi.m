xvalues = linspace(-Lbed/2, Lbed/2, 10);
zvalues = linspace(-Lbed/2, Lbed/2, 10);
rp = zeros(3, 100);
for j = 1:10
    for k = 1:10
        rp(:, 10*(j-1)+k) = [xvalues(j);0;zvalues(k)];
    end
end