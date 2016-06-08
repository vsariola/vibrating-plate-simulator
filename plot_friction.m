clear all

%%
tic;
friction = [0 0.05 0.1 0.2 0.5];
runs = simulateMany('time',1,'friction',friction);    
toc;
%%
close all
plotMany(runs,cellstr(num2str(friction', '\\mu = %.1f')));
%%
[~,~] = mkdir('output');
save('output/Friction.mat','runs');
% Needs ghostscript installed, http://www.ghostscript.com/
addpath('export_fig');
export_fig('output/Friction.pdf')



