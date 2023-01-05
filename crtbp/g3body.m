%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% g3body.m      
% Andy Kim - Nov 17 2020
% Graphics display of orbital motion in the circular-restricted Earth-Moon three body problem
% Orbital Mechanics with Matlab
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all; clc; home;

global mu

fprintf('\n                -g3body-\n');
fprintf('\n---Graphics Display of Three-Body Motion---\n\n');

while(1)
    
    fprintf('\n         -Main Menu-\n');
    fprintf('\n <1> periodic orbit about L1\n\n');
    fprintf(' <2> periodic orbit about L2\n\n');
    fprintf(' <3> periodic orbit about L3\n\n');
    fprintf(' <4> user input of initial conditions\n\n');
    icflg = input('\nSelect (1, 2, 3, 4): ');
    
    if (icflg >= 1 && icflg <= 4)
        break;
    end
end

switch icflg
    
    case 1  % periodic L1 orbit
        
        % periodic L1 orbit ICs (tr 32-1168, pp 25,29; 74)
        y(1) = 0.300000161;     % initial x-coord
        y(3) = 0;               % initial y-coord
        y(2) = 0;               % initial x-velocity
        y(4) = -2.536145497;    % initial y-velocity

        ti = 0;                
        tf = 5.349501906;       % orbital period

        mu = 0.012155092;       % Earth-Moon mass ratio

        % set plot boundaries
        xmin = -1.5;
        xmax = +1.5;
        ymin = -1.5;
        ymax = +1.5;

    case 2  % periodic L2 orbit
        
        % periodic L2 orbit (tr 32-1168, pp 31,34; 126)
        y(1) = 2.840829343;     % initial x-coord
        y(3) = 0;               % initial y-coord
        y(2) = 0;               % initial x-velocity
        y(4) = -2.747640074;    % initial y-velocity

        ti = 0;
        tf = 2 * 5.966659294;   % orbital period

        mu = 0.012155085;       % Earth-Moon mass ratio

        % set plot boundaries
        xmin = -3;
        xmax = +3;
        ymin = -3;
        ymax = +3;

    case 3  % periodic L3 orbit
        
        % periodic L3 orbit (tr 32-1168, pp 37,39; 63)
        y(1) = -1.600000312;    % initial x-coord
        y(3) = 0;               % initial y-coord
        y(2) = 0;               % initial x-velocity
        y(4) = 2.066174572;     % initial y-velocity

        ti = 0;
        tf = 2 * 3.151928156;   % orbital period

        mu = 0.012155092;       % Earth-Moon mass ratio

        % set plot boundaries
        xmin = -2;
        xmax = +2;
        ymin = -2;
        ymax = +2;

    case 4  % user input of initial conditions
        
        fprintf('\nInput the x-component of the radius vector: ');
        y(1) = input(' ');

        fprintf('\nInput the y-component of the radius vector: ');
        y(3) = input(' ');

        fprintf('\nInput the x-component of the velocity vector: ');
        y(2) = input(' ');

        fprintf('\nInput the y-component of the velocity vector: ');
        y(4) = input(' ');

        while(1)
            fprintf('\nInput the value for the mass ratio: ');
            mu = input(' ');

            if (mu > 0)
                break;
            end
        end

        while(1)
            fprintf('\nInput the final time (orbital period): ');
            tf = input(' ');

            if (abs(tf) > 0)
                break;
            end
        end

        % default values for plot boundaries
        xmin = -3;
        xmax = +3;
        ymin = -3;
        ymax = +3;

end

% request the integration step size

while(1)
    
    fprintf('\nInput the integration step size (0.01 is recommended): ');
    dt = input(' ');

    if (abs(dt) > 0)
        break;
    end
    
end

% set ode45 options

options = odeset('RelTol', 1.0e-10, 'AbsTol', 1.0e-10);

% initialize

t2 = -dt;
npt = 0;
fprintf('\n\n  working ...\n');

% solve for each step size value until end of period
while(1)

    t1 = t2;
    t2 = t1 + dt;

    % solve for velocities and accelerations
    [twrk, ysol] = ode45(@crtbp_eqm, [t1, t2], y, options);
    
    npt = npt + 1;

    xplot(npt) = ysol(length(twrk), 1); % x-coord (i believe)
    yplot(npt) = ysol(length(twrk), 3); % y-coord

    y = ysol(length(twrk), 1:4);        % assign 

    % check for end of simulation, if not continue
    if (t2 >= tf)
        break;
    end
    
end

% plot trajectory

plot(xplot, yplot);
axis ([xmin xmax ymin ymax]);
axis square;

ylabel('y-coordinate');
xlabel('x-coordinate');

% plot Earth and Moon locations

hold on;
plot(-mu, 0, '*g');     % Moon is green
plot(1 - mu, 0, '*b');  % Earth is blue

% label libration points

switch icflg
    
    case 1
        
        plot(0.836892919, 0, '.r');
        title('Periodic Orbit about the L1 Libration Point', 'FontSize', 16);
        legend({'Periodic Orbit', 'Earth', 'Moon', 'L1'},'Location','northeast')
        
    case 2
        
        plot(1.115699521, 0, '.r');
        title('Periodic Orbit about the L2 Libration Point', 'FontSize', 16);
        legend({'Periodic Orbit', 'Earth', 'Moon', 'L2'},'Location','northeast')
        
    case 3
        
        plot(-1.005064527, 0, '.r');
        title('Periodic Orbit about the L3 Libration Point', 'FontSize', 16);
        legend({'Periodic Orbit', 'Earth', 'Moon', 'L3'},'Location','northeast')
        
    case 4
        
        title('User Defined Initial Conditions', 'FontSize', 16);
        legend({'Trajectory', 'Earth', 'Moon'},'Location','northeast')
end

% create eps graphics file with tiff preview
print -depsc -tiff -r300 g3body.eps


