function simulate_position(varargin)

p = inputParser;
addParameter(p,'repetitions',16);
parse(p,varargin{:});

%%
tic;
position = linspace(0,3e-3,p.Results.repetitions);
xpos = position(2:(end-1)); % discard pure nodes
runs = parallelCall(@(p) simulate('time',1.4,'position',p) ...
                ,[xpos;ones(1,length(xpos))*150e-6/2]);
toc;
%%
saveData('Position','runs');



