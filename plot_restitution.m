clear all

%%
tic;
restitution = [0 0.2 0.4 0.6 0.8 1];
runs = simulateMany('time',1,'restitution',restitution);    
toc;
%%
close all
plotMany(runs,cellstr(num2str(restitution', '\\it{e} = %.2f')));
%%
[~,~] = mkdir('output');
save('output/Restitution.mat','runs');
% Needs ghostscript installed, http://www.ghostscript.com/
addpath('export_fig');
export_fig('output/Restitution.pdf')



