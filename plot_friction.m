function plot_friction(varargin)

p = inputParser;
addParameter(p,'repetitions',10);
parse(p,varargin{:});

%%
tic;
friction = [0 0.2 0.4 0.6 0.8];
xpos = 7.5e-4+linspace(-10e-6,10e-6,p.Results.repetitions);
runs = parallelCall(@(f) ...
            groupruns(parallelCall(@(p) simulate('time',2,'friction',f,'position',p) ...
                ,[xpos;ones(1,length(xpos))*150e-6/2])),friction);
toc;

%%
plotMany(runs,'legendtitles',cellstr(num2str(friction', '\\it{\\mu} = %.2f')),'markertime',0.5);
%%
saveDataAndImage('Friction','runs','friction');