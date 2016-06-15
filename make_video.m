close all
clear all

run = simulate('time',0.2);
%%
visualize(run,'video','output/Movie','videospeed',0.01,'fps',24);