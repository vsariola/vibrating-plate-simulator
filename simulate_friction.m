function simulate_friction(varargin)

p = inputParser;
addParameter(p,'repetitions',4);
parse(p,varargin{:});

%%
tic;
friction = [0.01 0.2 0.5 0.7 0.8];
xpos = 7.5e-4+linspace(-10e-6,10e-6,p.Results.repetitions);
runs = parallelCall(@(f) ...
            groupruns(parallelCall(@(p) simulate('time',2,'friction',f,'position',p) ...
                ,[xpos;ones(1,length(xpos))*150e-6/2])),friction);
toc;

%%
saveData('Friction','runs','friction');