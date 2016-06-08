clear all

%%
tic;
position = linspace(0,3e-3,16);
position = position(2:(end-1)); % discard pure nodes
runs= struct();
parfor i = 1:length(position)
    [data,params] = simulate('time',1,'position',[position(i);150e-6]);
    runs(i).data = data;
    runs(i).params = params;
end
toc;
%%
close all
plotMany(runs);
%%
[~,~] = mkdir('output');
save('output/Position.mat','runs');
% Needs ghostscript installed, http://www.ghostscript.com/
addpath('export_fig');
export_fig('output/Position.pdf')



