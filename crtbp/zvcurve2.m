%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% zvcurve2.m
% Andy Kim - Nov 17 2020
% Plot zero relative velocity curves for user-defined mass ratio and 
% contour values for the circular-restricted Earth-Moonthree body problem
% Orbital Mechanics with Matlab
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all; clc;
global ilp mu

fprintf('\n      -zvcurve2-\n');
fprintf('\n---Graphics Display of User-Defined');
fprintf('\n Zero Relative Velocity Curves---\n\n');

while(1)
    fprintf('\nInput the value for the mass ratio: ');
    mu = input(' ');
    if (mu > 0)
        break;
    end
end

while(1)

    fprintf('\n     -contour level input menu-\n');
    fprintf('\n <1> lower value, increment, upper value\n\n');
    fprintf(' <2> discrete contour values\n\n');
    fprintf('Select (1 or 2): ');
    icflg = input(' ');

    if (icflg >= 1 && icflg <= 2)
        break;
    end
end

if (icflg == 1)
    while(1)
        fprintf('\nInput the lower contour value: ');
        v1 = input(' ');

        if (v1 > 0)
            break;
        end
    end

    while(1)
        fprintf('\nInput the contour increment: ');

        dv = input(' ');

        if (dv > 0)
            break;
        end
    end

    while(1)
        fprintf('\nInput the upper contour value: ');
        v2 = input(' ');

        if (v2 > v1)
            break;
        end
    end

    v = [v1: dv: v2];

end

if (icflg == 2)
    while(1)
        fprintf('\n\nInput the number of discrete contour levels: ');
        nc = input(' ');

        if (nc > 0)
            break;
        end
    end

    for i = 1:1:nc
        fprintf('\nInput the value for contour level %.0f', i);
        clevel = input(' ');
        v(i) = clevel;
        
    end

end

while(1)
    fprintf('\nWould you like to label the contours (y = yes, n = no): ');
    slct = lower(input(' ', 's'));
    if (slct == 'y' || slct == 'n')
        break;
    end
end

while(1)
    fprintf('\nInput the minimum value for the x and y coordinates: ');
    xmin = input(' ');
    ymin = xmin;

    break;
end

while(1)
    fprintf('\nInput the maximum value for the x and y coordinates: ');
    xmax = input(' ');
    ymax = xmax;

    break;
end

while(1)
    fprintf('\nInput the mesh grid value for x and y (a value between 0.01 and 0.005 is recommended): ');
    delta = input(' ');

    if (delta > 0)
        break;
    end
end

fprintf('\n\n  working ...\n');

% compute coordinates of libration points

xm1 = - mu;
xm2 = 1 - mu;

% L1 libration point

ilp = 1;

xr1 = -2;
xr2 = +2;

rtol = 1.0e-8;
[xl1, froot] = brent ('clpfunc', xr1, xr2, rtol);
yl1 = 0;

% L2 libration point

ilp = 2;
xr1 = -2;
xr2 = +2;

rtol = 1.0e-8;
[xl2, froot] = brent ('clpfunc', xr1, xr2, rtol);
yl2 = 0;

% L3 libration point

ilp = 3;

xr1 = -2;
xr2 = +2;

rtol = 1.0e-8;
[xl3, froot] = brent ('clpfunc', xr1, xr2, rtol);
yl3 = 0;

% L4

xl4 = 0.5 - mu;
yl4 = 0.5 * sqrt(3);

% L5

xl5 = 0.5 - mu;
yl5 = - 0.5 * sqrt(3);

% create x and y mesh data points

[x, y] = meshgrid(xmin: delta: xmax, ymin: delta: ymax);

% create z data

x1 = - mu;
x2 = 1 - mu;

for i = 1: 1: size(x)
    for j = 1: 1: size(x)

        r1sqr = (x(i, j) - x1)^2 + y(i, j)^2;
        r2sqr = (x(i, j) - x2)^2 + y(i, j)^2;

        z(i, j) = (1 - mu) * (r1sqr + 2 / sqrt(r1sqr)) + mu * (r2sqr + 2 / sqrt(r2sqr)) - mu * (1 - mu);
    end
end

% plot zero relative-velocity contours

if (slct == 'y')
    [c, h] = contour(x, y, z, v);
    clabel(c, v);
    
else
    contour (x, y, z, v);
end

axis square;
axis ([xmin xmax ymin ymax]);
grid off;
hold on;

% plot body locations

plot(-mu, 0, '*b');
plot(1 - mu, 0, '*b');

% plot location of libration points

plot(xl1, yl1, '*r');
plot(xl2, yl2, '*r');
plot(xl3, yl3, '*r');
plot(xl4, yl4, '*r');
plot(xl5, yl5, '*r');

% label plot

ttext = ['Zero Relative Velocity Curves for Mass Ratio = ' num2str(mu)];
title(ttext, 'FontSize', 16);
xlabel('x coordinate');
ylabel('y coordinate');
print -depsc -tiff -r300 zvcurve2.eps

