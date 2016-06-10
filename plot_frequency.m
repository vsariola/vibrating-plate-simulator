function plot_frequency(varargin)

p = inputParser;
addParameter(p,'repetitions',1);
parse(p,varargin{:});

%%
tic;
frequencies = [550 800 1000 1500 2200];
xpos = 7.5e-4+linspace(-10e-6,10e-6,p.Results.repetitions);
runs = parallelCall(@(f) ...
            groupruns(parallelCall(@(p) simulate('time',1,'frequency',f,'position',p,'dt',1/(64*2200)) ...
                ,[xpos;ones(1,length(xpos))*150e-6/2])),frequencies);
toc;
%%
plotMany(runs,'legendtitles',cellstr(num2str(frequencies', '%d Hz')));
%%
saveDataAndImage('Frequency','runs','frequencies');



