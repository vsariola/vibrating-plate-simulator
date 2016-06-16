close all;

%%
load('output/AspectRatio.mat');
labelpos = plotMany(runs,'labels',cellstr(num2str(aspectratio', '{\\ita}=%.2f')),'labelfile','AspectRatioLabels');
saveImage('AspectRatio');
%%
load('output/Size.mat');
plotMany(runs,'labels',cellstr(num2str(diameter' * 1e6, '\\it{d} = %.0f µm')),'markertime',0.5,'labelfile','SizeLabels');
saveImage('Size');
%%
load('output/Frequency.mat');
plotMany(runs,'labels',cellstr(num2str(frequencies', '%d Hz')),'markertime',0.2,'labelfile','FrequencyLabels');
saveImage('Frequency');
%%
load('output/Position.mat');
plotMany(runs);
saveImage('Position');
%%
load('output/Restitution.mat');
plotMany(runs,'labels',cellstr(num2str(restitution', '{\\ite} = %.1f')),'markertime',0.4,'labelfile','RestitutionLabels');
saveImage('Restitution');
%%
load('output/Friction.mat');
plotMany(runs,'labels',cellstr(num2str(friction', '{\\it\\mu} = %.2f')),'markertime',0.5,'labelfile','FrictionLabels');
saveImage('Friction');
%%
load('output/Amplitude.mat');
plotMany(runs,'labels',cellstr(num2str(amplitude'/1e-6, '{\\itA} = %.1f µm')),'markertime',0.5,'labelfile','AmplitudeLabels');
saveImage('Amplitude');