clear all

%%
tic;
frequencies = [550 800 1000 1500 3000];
runs = simulateMany('time',1,'frequency',frequencies,'dt',1/(64*2200));    
toc;
%%
close all
leg = plotMany(runs,cellstr(num2str(frequencies', '%d Hz')));
leg.Location = 'NorthEast';
%%
[~,~] = mkdir('output');
save('output/Frequency.mat','runs');
% Needs ghostscript installed, http://www.ghostscript.com/
addpath('export_fig');
export_fig('output/Frequency.pdf')



