clear all

%%
tic;
friction = [0 0.01 0.2 0.4 0.6 0.8];
runs = simulateMany('time',2,'friction',friction);    
toc;
%%
close all
plotMany(runs,cellstr(num2str(friction', '\\mu = %.3f')));
%%
[~,~] = mkdir('output');
save('output/Friction.mat','runs');
% Needs ghostscript installed, http://www.ghostscript.com/
addpath('export_fig');
export_fig('output/Friction.pdf')



