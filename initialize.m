% What is the role of the particle size, mass, friction and restitution
% coefficients, aspect ratio, and vibration frequency in generating transport and contributing to stochasticity?

% Particle size / aspect ratio: ?
% Mass: no role
% Friction coefficient: ?
% Restitution coefficient: ?
% Vibrating frequency: ?

% Dimensional analysis
% Particle diameter [m]
% Particle height [m]
% Gravitational constant [m s^-2]
% Restitution [unitless]
% Friction [unitless]
% Mass [kg]
% Frequency [s^-1]
% Wavelength [m]
% Amplitude [m]
% Time [s]
% Timestep [s]
% X-position [m]
% Y-position [m]
%
% Normalize with: particle diameter and gravitational constant
% 
% Particle height / particle diameter = aspect ratio [unitless]
% Restitution
% Friction
% Frequency / sqrt(g) * sqrt(particle diameter) = normalized frequency
% [unitless]
% Wavelength / particle diameter = normalized wavelength [unitless]
% Amplitude / particle diameter = normalized amplitude [unitless]
% Time * sqrt(g) / sqrt(particle diameter) = normalized time [unitless]
% Timestep * sqrt(g) / sqrt(particle diameter) = normalized timestep [unitless]
% X-position / particle diameter = normalized X-position [unitless]
% Y-position / particle diameter = normalized Y-position [unitless]
% Starting X-position / particle diameter = normalized starting position
% [unitless]

% Particle is a cylinder
% These three are should be arbitrary, because the simulation is normalized
% to them; however, due to the chaotic nature of the process, these values
% can lead to slight numerical differences, which may accumulate over time
% and eventually two simulations can diverge.
diameter = 600e-6; % Particle diameter [m]
g = 9.81; % Gravitational constant [m/s^2]
mass = 1; % The density is approx 5900 and volume approx diameter^3. Again, these are arbitrary

if (~exist('normalizedFrequency','var'))
    normalizedFrequency = 10; % Aspect ratio [unitless]
end

if (~exist('aspectratio','var'))
    aspectratio = 0.5; % Aspect ratio [unitless]
end
height = aspectratio * diameter; % Particle height [m]
if (~exist('normalizedWavelength','var'))
    normalizedWavelength = 10; % Aspect ratio [unitless]
end
if (~exist('normalizedPosition','var'))
    normalizedPosition = 0.125; % Aspect ratio [unitless]
end
relativeDt = 0.05;

wavelength = normalizedWavelength * diameter;

b = struct();
b.restitution = 0.5; % [unitless]
b.friction = 0.5; % [unitless]
b.polygon = [-diameter/2 -height/2;diameter/2 -height/2;diameter/2 height/2;-diameter/2 height/2]';
b.position = [normalizedPosition*wavelength; height/2];
b.velocity = [0;0]; % Initial velocity
b.acceleration = [0;-g]; % Constant acceleration
b.theta = 0; % Initial angle
b.omega = 0; % Initial angular velocity
b.alpha = 0; % Constant angular acceleration
b.mass = mass; % [kg]
% https://en.wikipedia.org/wiki/List_of_moments_of_inertia
% Solid sylinder with radius = diameter/2
b.inertia = b.mass/12 * (3/4*diameter^2 + height^2); % Moment of inertia


frequency = normalizedFrequency * sqrt(g) / sqrt(diameter);
% amplitude = 0.01 * diameter;
% amplitude = 0.005 * diameter;
amplitude = 0.003 * diameter;
totaltime = 400 * sqrt(diameter) / sqrt(g);
h = @(x,t) amplitude*sin(2*pi*x/wavelength)*sin(2*pi*t*frequency);
dh_dt = @(x,t) amplitude*sin(2*pi*x/wavelength)*cos(2*pi*t*frequency)*2*pi*frequency;
dh_dx = @(x,t) amplitude*cos(2*pi*x/wavelength)*sin(2*pi*t*frequency)*2*pi/wavelength;

deltaT = relativeDt / frequency;