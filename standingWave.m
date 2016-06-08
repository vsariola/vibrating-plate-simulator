function [h,dh_dt,dh_dx] = standingWave(amplitude,wavelength,frequency)

h = @(x,t) amplitude*sin(2*pi*x/wavelength)*sin(2*pi*t*frequency);
dh_dt = @(x,t) amplitude*sin(2*pi*x/wavelength)*cos(2*pi*t*frequency)*2*pi*frequency;
dh_dx = @(x,t) amplitude*cos(2*pi*x/wavelength)*sin(2*pi*t*frequency)*2*pi/wavelength;
