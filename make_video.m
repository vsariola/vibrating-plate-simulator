close all
clear all

[data,params] = simulate('amplitude',0,'position',[0,1e-3]);
figure;
visualize(data,params,10);