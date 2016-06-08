function [data,params] = simulate(varargin)
% SIMULATE  Simulates the trajectory of a rigid cylinder bouncing on a 1D
% standing wave.
%
% data = SIMULATE(...) returns a 7 x N data matrix, where:
%   data(1,:) is the time
%   data(2,:) is the x-coordinate [m]
%   data(3,:) is the y-coordinate [m]
%   data(4,:) is the x-velocity [m/s]
%   data(5,:) is the y-velocity [m/s]
%   data(6,:) is the angle [rad]
%   data(7,:) is the angular velocity [rad/s]
%
% [~,params] = SIMULATE(...) returns all the parameters used in the
% simulation. To regenerate the same data, use: data =
% SIMULATE('params',params)
% 
% SIMULATE('name',value,...) optional parameters:
%   'method': either 'newton' or 'poisson', default 'poisson'
%   'diameter': diameter (width) of the cylinder [m], default 600e-6
%   'height': height of the cylinder [m], default 300e-6
%   'wavelength': distance from first node to third node [m], default 6e-3
%   'position': initial center position [m;m], default [7.5e-4;150e-3]
%   'velocity': initial velocity [m/s], default [0;0]
%   'acceleration': constant acceleration [m/s^2], default [0;-9.81]
%   'theta': initial angle [rad], default 0
%   'omega': initial angular velocity [rad/s], default 0
%   'alpha': constant angular acceleration [rad/s^2], default 0
%   'mass': particle mass [kg], default 0
%   'frequency': frequency of the plate vibration [Hz], default 1000
%   'amplitude': zero-peak amplitude of the vibration [m], default 2.5e-6
%   'time': total simulation time [s], default 0.5 
%   'dt': simulation time step [s], default 1/64000
%   'friction': friction coefficient [unitless], default 0.5
%   'restitution': restitution coefficient [unitless], default 0.5
%   'params': used if you want to pass all the parameters in one struct.
%     Useful for rerunning the simulation (see above)
% 
% Notice that theoretically, mass should not change anything in the
% simulation; however, it still scales all the floating point computations
% and due to numerical inaccuracies and chaotic behaviour of the particle,
% slightly different results can be obtained.

p = inputParser;
defaultMethod = 'poisson';
expectedMethods = {'newton','poisson'};
defaultDiameter = 600e-6; % Particle diameter [m]
defaultHeight = 300e-6; % Particle height [m]
defaultWavelength = 6e-3; % Distance between two nodes with one node in between [m]
defaultPosition = [7.5e-4;defaultHeight/2]; % Particle position [m;m]
defaultVelocity = [0;0]; % Particle velocity [m;m]
defaultAcceleration = [0;-9.81]; % Default constant acceleration i.e. gravity [m]
defaultTheta = 0; % Initial particle angle [rad]
defaultOmega = 0; % Initial particle angular speed [rad/s]
defaultAlpha = 0; % Constant particle angular acceleration [rad/s^2]

defaultMass = 1; % Particle mass [kg], should not matter
defaultFrequency = 1000; % Frequency of the vibration [Hz]
defaultAmplitude = 2.5e-6; % Zero-to-peak amplitude of the vibration [m]

defaultTime = 0.5; % Simulation time [s]
defaultDt = 1/(64*defaultFrequency); % Time step of the simulation

defaultFriction = 0.5; % Friction coefficient [unitless]
defaultRestitution = 0.5; % Restitution coefficient [unitless]

addParameter(p,'method',defaultMethod,@(x) any(validatestring(x,expectedMethods)));
addParameter(p,'diameter',defaultDiameter,@isnumeric);
addParameter(p,'height',defaultHeight,@isnumeric);
addParameter(p,'wavelength',defaultWavelength,@isnumeric);
addParameter(p,'position',defaultPosition,@isnumeric);
addParameter(p,'velocity',defaultVelocity,@isnumeric);
addParameter(p,'acceleration',defaultAcceleration,@isnumeric);
addParameter(p,'theta',defaultTheta,@isnumeric);
addParameter(p,'omega',defaultOmega,@isnumeric);
addParameter(p,'alpha',defaultAlpha,@isnumeric);
addParameter(p,'mass',defaultMass,@isnumeric);
addParameter(p,'frequency',defaultFrequency,@isnumeric);
addParameter(p,'amplitude',defaultAmplitude,@isnumeric);
addParameter(p,'time',defaultTime,@isnumeric);
addParameter(p,'dt',defaultDt,@isnumeric);
addParameter(p,'friction',defaultFriction,@isnumeric);
addParameter(p,'restitution',defaultRestitution,@isnumeric);
addParameter(p,'params',[]);

parse(p,varargin{:});

params = p.Results;

if (~isempty(params.params))
    params = params.params;
end

usePoisson = strcmp(params.method,'poisson');

inertia = params.mass/12 * (3/4*params.diameter^2 + params.height^2); % Moment of inertia
poly = rectanglePoly(params.diameter,params.height);

[h,dh_dt,dh_dx] = standingWave(params.amplitude,params.wavelength,params.frequency);

curPos = params.position;
curVel = params.velocity;
curTheta = params.theta;
curOmega = params.omega;
curTime = 0;

n = round(params.time / params.dt);
data = zeros(7,n);
for i = 1:n
    % Save the current position and velocity
    data(:,i) = [curTime;curPos;curVel;curTheta;curOmega];   
    
    % Take time step and simulate dynamics
    curTime = curTime + params.dt;
    curPos = curPos + curVel * params.dt + 0.5 * params.acceleration * params.dt^2;
    curVel = curVel + params.acceleration * params.dt;
    curTheta = curTheta + curOmega * params.dt + 0.5 * params.alpha * params.dt^2;
    curOmega = curOmega + params.alpha * params.dt;
    
    % Rototranslate the collision polygon to world coordinates   
	polyWorld = rototranslate(poly,curPos,curTheta);  
    
    % Check if any of the vertices is below surface
    diff = h(polyWorld(1,:),curTime) - polyWorld(2,:);
    ind = diff > 0;
    numcol = sum(ind);
    
    % If no collisions occur, skip to next cycle
    if (numcol == 0)
        continue;
    end
    
    % The collision point is average of all collision vertices. I.e. if 
    % two vertices collide, the center point is the collision point
    cp = mean(polyWorld(:,ind),2); % Contact point, in world coordinates
    rp = curPos - cp; % Relative contact point, in world frame
    
    % Compute tangent and normal of the surface
    tangent = [1;dh_dx(cp(1),curTime)];
    tangent = tangent / norm(tangent,2);
    normal = [-tangent(2);tangent(1)];           
    
    % Project contact point to local coordinates, normal pointing to
    % positive y direction (up) and tangent pointing to positive x (right)
    x = rp' * tangent;
    y = rp' * normal;
             
    % Calculate the relative velocity of the collision point relative to
    % the surface
    surface_velocity = [0;dh_dt(cp(1),curTime)];
    vp = curVel + [curOmega * rp(2);-curOmega * rp(1)] - surface_velocity;
    
    % Initial sliding and compression velocities, Wang-Mason eq. 22-23
    S0 = vp' * tangent;
    C0 = vp' * normal;
    
    if (C0 > 0)
        continue;
    end
    
    % Wang-Mason eq. 19 - 21, assuming m2 infinite
    B1 = 1/params.mass + y^2/inertia;
    B2 = 1/params.mass + x^2/inertia;
    B3 = x*y/inertia;

    s = 1 - 2*(S0 < 0);        
        
    mu_s = -B3 / B1;
    P_d = (B2 + s*params.friction*B3)*s*S0;
    P_q = -(params.friction*B1+s*B3)*C0;        
    
    if usePoisson
        % Poisson restitution
        if P_d > (1+params.restitution)*P_q
            % Sliding
            Py = -(1+params.restitution)*C0/(B2+s*params.friction*B3);
            Px = -s*params.friction * Py;
        elseif params.friction > abs(mu_s)
            % Sticking (C-Sticking & R-Sticking)
            if P_d < P_q 
                % C-Sticking
                Py = -(1+params.restitution)*(B1*C0+B3*S0)/(B1*B2-B3^2);
                Px = (B3*Py-S0)/B1;
            else
                % R-Sticking
                Py = -(1+params.restitution)*C0/(B2+s*params.friction*B3);
                Px = (B3*Py-S0)/B1;
            end
        else
            % Reverse sliding (C-Sliding & R-Sliding)           
            if P_d < P_q 
                % C-Reversed Sliding
                Py = -(1+params.restitution)/(B2-s*params.friction*B3)*(C0+(2*s*params.friction*B3*S0)/(B3+s*params.friction*B1));
                Px = s*params.friction*(Py-2*S0/(B3+s*params.friction*B1));                
            else
                % R-Reversed Sliding
                Py = -(1+params.restitution)*C0/(B2+s*params.friction*B3);
                Px = s*params.friction*(Py - 2*S0/(B3+s*params.friction*B1));
            end
        end     
    else
        % Newton restitution
        % ------------------
        if P_d > (1+params.restitution)*P_q
            % Sliding
            Py = -(1+e)*C0/(B2+s*params.friction*B3);
            Px = -s*params.friction * Py;
        elseif params.friction > abs(mu_s)
            % Sticking (C-Sticking & R-Sticking)
            Px = - (B2*S0 + (1+params.restitution)*C0*B3)/(B1*B2-B3^2);
            Py = - (B3*S0 + (1+params.restitution)*C0*B1)/(B1*B2-B3^2);
        else
            % Reverse sliding (C-Sliding & R-Sliding)           
            Py = - 1/(B2-s*params.friction*B3)*((1+params.restitution)*C0+2*s*params.friction*B3*S0/(B3*s*params.friction*B1));
            Px = s*params.friction*(P3 - 2*S0/(B3 + s*params.friction*B1));            
        end        
    end
            
    Kbefore = 0.5 * params.mass * norm(curVel-surface_velocity,2)^2 + 0.5 * inertia * curOmega^2;
    
    impulse = Px * tangent + Py * normal;

    % Update velocity and angular velocity with the normal impulse
    curVel = curVel + impulse / params.mass;
    curOmega = curOmega + (Px * y - Py * x) / inertia;  
    
    Kafter = 0.5 * params.mass * norm(curVel-surface_velocity,2)^2 + 0.5 * inertia * curOmega^2;
    
    Kdelta = Kafter - Kbefore;
    
    if (Kdelta > 1e-10)
        disp('The kinetic energy just increased in a bounce!!!');
    end
end