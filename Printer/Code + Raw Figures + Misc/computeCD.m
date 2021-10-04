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