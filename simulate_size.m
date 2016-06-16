function simulate_size(varargin)

p = inputParser;
addParameter(p,'repetitions',4);
parse(p,varargin{:});

%%
tic;
diameter = [100e-6 200e-6 350e-6 600e-6 1e-3];
height = 0.5 .* diameter;
xpos = 7.5e-4+linspace(-10e-6,10e-6,p.Results.repetitions);
runs = parallelCall(@(d,h) ...
            groupruns(parallelCall(@(p) simulate('time',1,'diameter',d,'height',h,'position',p) ...
                ,[xpos;ones(1,length(xpos))*150e-6/2])),diameter,height);
toc;
%%
saveData('Size','runs','diameter');



