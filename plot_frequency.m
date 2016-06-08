clear all

%%
tic;
frequencies = [350 500 700 1000 1400];
runs = simulateMany('time',1,'frequency',frequencies,'dt',1/(64*1400));    
toc;
%%
close all
plotMany(runs,cellstr(num2str(frequencies', '%d Hz')));
%%
[~,~] = mkdir('output');
save('output/Frequency.mat','runs');
% Needs ghostscript installed, http://www.ghostscript.com/
addpath('export_fig');
export_fig('output/Frequency.pdf')



