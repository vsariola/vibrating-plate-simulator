function plot_restitution(varargin)

p = inputParser;
addParameter(p,'repetitions',10);
parse(p,varargin{:});

%%
tic;
restitution = [0 0.2 0.4 0.6 1];
xpos = 7.5e-4+linspace(-10e-6,10e-6,p.Results.repetitions);
runs = parallelCall(@(e) ...
            groupruns(parallelCall(@(p) simulate('time',1,'restitution',e,'position',p) ...
                ,[xpos;ones(1,length(xpos))*150e-6/2])),restitution);
toc;

%%
plotMany(runs,'legendtitles',cellstr(num2str(restitution', '\\it{e} = %.1f')),'markertime',0.4);
%%
saveDataAndImage('Restitution','runs','restitution');



