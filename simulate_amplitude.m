function simulate_amplitude(varargin)

p = inputParser;
addParameter(p,'repetitions',4);
parse(p,varargin{:});

%%
tic;
amplitude = [0.5 1 2.5 5 8] * 1e-6;
xpos = 7.5e-4+linspace(-10e-6,10e-6,p.Results.repetitions);
runs = parallelCall(@(a) ...
            groupruns(parallelCall(@(p) simulate('time',1,'position',p,'amplitude',a) ...
                ,[xpos;ones(1,length(xpos))*300e-6/2])),amplitude);
toc;
%%
saveData('Amplitude','runs','amplitude');


