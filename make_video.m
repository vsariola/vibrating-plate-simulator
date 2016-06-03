close all
clear all

normalizedFrequency = 5;
initialize

figure;
b.friction = 0;
% b.position = [2e-3;0.25e-3];
% b.theta = 0.1;
% b.velocity = [0;0];
visualize(simulate(b,0.5,deltaT,h,dh_dt,dh_dx),b.polygon,h);