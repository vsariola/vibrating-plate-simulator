function simulate_smallshift(varargin)

p = inputParser;
addParameter(p,'repetitions',4);
parse(p,varargin{:});

%%
tic;
xpos_tworuns = [7.5e-4 7.5e-4+1e-9];
tworuns = parallelCall(@(p) simulate('time',0.85,'position',p) ...
                ,[xpos_tworuns;ones(1,length(xpos_tworuns))*150e-6/2]);

xpos_manyruns = linspace(7.5e-4-10e-6,7.5e-4+10e-6,p.Results.repetitions);
manyruns = groupruns(parallelCall(@(p) simulate('time',0.85,'position',p) ...
                ,[xpos_manyruns;ones(1,length(xpos_manyruns))*150e-6/2]));
toc;
%%
saveData('Smallshift','tworuns','manyruns');



