function plot_position(varargin)

p = inputParser;
addParameter(p,'repetitions',2);
parse(p,varargin{:});

%%
tic;
position = linspace(7.5e-4,7.5e-4+1e-9,p.Results.repetitions);
xpos = position; % discard pure nodes
runs = parallelCall(@(p) simulate('time',1.4,'position',p) ...
                ,[xpos;ones(1,length(xpos))*150e-6/2]);
toc;
%%
plotMany(runs);
%%
saveDataAndImage('Smallshift','runs');



