%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% crtbp1.m
% Andy Kim - Nov 17 2020
% Compute x and y coordinates and energy of the equilibrium libration points of the circular-restricted three-body problem (CRTBP)
% Orbital Mechanics with Matlab
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear; clc; home;

global ilp mu

fprintf('\n                 -crtbp1-');
fprintf('\n---Equilibrium Coordinates and Energy---\n');

while(1)
    fprintf('\nPlease input the value for the mass ratio.');
    fprintf('\nExamples: Earth/Sun = 0.000003, Moon/Earth = 0.0123\n');
    fprintf('\nMass Ratio: ');
    mu = input(' ');            

    if (mu > 0)
        break;
    end
end

% set coordinates of the Earth and Moon relative to the rotating frame w/ origin @ com
xm1 = - mu;
xm2 = 1 - mu;

%Lagrange/Libration Point Coordinate and Energy Calculations(all coords are relative to com)

% L1 libration point
ilp = 1;

xr1 = -2;                                   % lower and upper bounds used for solving for the roots
xr2 = +2;
rtol = 1.0e-8;

[xl1, froot] = brent('clpfunc', xr1, xr2, rtol);     % solve L1 nonlinear equation for x-coord
yl1 = 0;

r1sqr = (xl1 - xm1)^2 + yl1^2;              % solve for energy of L1
r2sqr = (xl1 - xm2)^2 + yl1^2;
e1 = -0.5 * (xl1^2 + yl1^2) - (1 - mu) / sqrt(r1sqr) - mu / sqrt(r2sqr);

% L2 libration point
ilp = 2;

xr1 = -2;                                   % lower and upper bounds used for solving for the roots
xr2 = +2;
rtol = 1.0e-8;

[xl2, froot] = brent ('clpfunc', xr1, xr2, rtol);    % solve L2 nonlinear equation for x-coord
yl2 = 0;

r1sqr = (xl2 - xm1)^2 + yl2^2;              % solve for energy of L2
r2sqr = (xl2 - xm2)^2 + yl2^2;
e2 = -0.5 * (xl2^2 + yl2^2) - (1 - mu) / sqrt(r1sqr) - mu / sqrt(r2sqr);

% L3 libration point
ilp = 3;

xr1 = -2;                                   % lower and upper bounds used for solving for the roots
xr2 = +2;
rtol = 1.0e-8;

[xl3, froot] = brent ('clpfunc', xr1, xr2, rtol);    % solve L3 nonlinear equation for x-coord
yl3 = 0;

r1sqr = (xl3 - xm1)^2 + yl3^2;              % solve for energy of L3
r2sqr = (xl3 - xm2)^2 + yl3^2;
e3 = -0.5 * (xl3^2 + yl3^2) - (1 - mu) / sqrt(r1sqr) - mu / sqrt(r2sqr);

% L4
xl4 = 0.5 - mu;                             % L4 forms an equilateral triangle with the Earth and Moon
yl4 = 0.5 * sqrt(3);

r1sqr = (xl4 - xm1)^2 + yl4^2;              % solve for energy of L4
r2sqr = (xl4 - xm2)^2 + yl4^2;
e4 = -0.5 * (xl4^2 + yl4^2) - (1 - mu) / sqrt(r1sqr) - mu / sqrt(r2sqr);    

% L5
xl5 = 0.5 - mu;                              % L5 forms an equilateral triangle with the Earth and Moon
yl5 = - 0.5 * sqrt(3);

r1sqr = (xl5 - xm1)^2 + yl5^2;               % solve for energy of L5
r2sqr = (xl5 - xm2)^2 + yl5^2;
e5 = -0.5 * (xl5^2 + yl5^2) - (1 - mu) / sqrt(r1sqr) - mu / sqrt(r2sqr);

% print results
fprintf('\n          --- Lagrange Point Coordinates and Energies ---\n');             

fprintf('\nLocation     x-coordinate(au)      y-coordinate(au)             Energy\n');

fprintf('\n   L1         %10.6f            %10.6f            %12.10e\n', xl1, yl1, e1);
fprintf('\n   L2         %10.6f            %10.6f            %12.10e\n', xl2, yl2, e2);
fprintf('\n   L3         %10.6f            %10.6f            %12.10e\n', xl3, yl3, e3);
fprintf('\n   L4         %10.6f            %10.6f            %12.10e\n', xl4, yl4, e4);
fprintf('\n   L5         %10.6f            %10.6f            %12.10e\n\n', xl5, yl5, e5);
