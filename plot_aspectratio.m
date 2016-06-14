function plot_aspectratio(varargin)

p = inputParser;
addParameter(p,'repetitions',2);
parse(p,varargin{:});

%%
tic;
aspectratio = [1 0.9 0.5 0.2 0.15];
volume = 300e-6 * pi * 300e-6^2;
diameter = 2 * (volume ./ (pi * 2 * aspectratio)) .^ (1/3);
height = aspectratio .* diameter;
xpos = 7.5e-4+linspace(-10e-6,10e-6,p.Results.repetitions);
runs = parallelCall(@(d,h) ...
            groupruns(parallelCall(@(p) simulate('time',3,'diameter',d,'height',h,'position',p) ...
                ,[xpos;ones(1,length(xpos))*h/2])),diameter,height);
toc;
%%
plotMany(runs,'legendtitles',cellstr(num2str(aspectratio', '%.2f')),'legendlocation','SouthWest','markertime',1);
%%
saveDataAndImage('AspectRatio','runs','aspectratio');

