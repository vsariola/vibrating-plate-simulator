close all;
%
% MAIN TEXT FIGURE
%
%%
load('output/Position.mat');
plotMany(runs,'plotnodes',true,'XTick',0:0.5:2,'YTick',(0:1:4)*1e-3);
saveImage('Position');
%%
load('output/Smallshift.mat');
[~,axhandle] = plotMany(manyruns,'colorshift',2,'linestyle','none','edgelinestyle','none');
plotMany(tworuns,'XTick',0:0.2:1,'YTick',(0:0.2:1)*1e-3,'axes',axhandle);
saveImage('Smallshift');


%
% SUPPLEMENTARY FIGURE
%
%%
load('output/Amplitude.mat');
plotMany(runs,'labels',cellstr(num2str(amplitude'/1e-6, '{\\itA} = %.1g µm')),'markertime',0.5,'labelfile','AmplitudeLabels','YTick',(-2:0.2:2)*1e-3);
saveImage('Amplitude');
%%
load('output/Frequency.mat');
plotMany(runs,'labels',cellstr(num2str(frequencies'/1000, '{\\itf} = %.2g kHz')),'markertime',0.2,'labelfile','FrequencyLabels','YTick',(-2:0.2:2)*1e-3);
saveImage('Frequency');
%%
load('output/Size.mat');
plotMany(runs,'labels',cellstr(num2str(diameter' * 1e6, '{\\itD} = %.0g µm')),'markertime',0.5,'labelfile','SizeLabels','YTick',(-2:0.2:2)*1e-3);
saveImage('Size');
%%
load('output/AspectRatio.mat');
labelpos = plotMany(runs,'labels',cellstr(num2str(aspectratio', '{\\itr} = %.2g')),'labelfile','AspectRatioLabels','YTick',(-2:0.2:2)*1e-3);
saveImage('AspectRatio');
%%
load('output/Friction.mat');
plotMany(runs,'labels',cellstr(num2str(friction', '{\\it\\mu} = %.2g')),'markertime',0.5,'labelfile','FrictionLabels','YTick',(-2:0.2:2)*1e-3);
saveImage('Friction');
%%
load('output/Restitution.mat');
plotMany(runs,'labels',cellstr(num2str(restitution', '{\\ite} = %.1g')),'markertime',0.4,'labelfile','RestitutionLabels','YTick',(-2:0.2:2)*1e-3);
saveImage('Restitution');

