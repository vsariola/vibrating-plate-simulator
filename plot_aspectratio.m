clear all

%%
tic;
aspectratio = [1 0.5 0.2 0.1 0.05];
volume = 300e-6 * pi * 300e-6^2;
diameter = 2 * (volume ./ (pi * 2 * aspectratio)) .^ (1/3);
height = aspectratio .* diameter;
runs= struct();
parfor i = 1:length(aspectratio)
    [data,params] = simulate('diameter',diameter(i),'height',height(i),'position',[10e-5;height(i)/2]);
    runs(i).data = data;
    runs(i).params = params;
end
toc;
%%
plotMany(runs,cellstr(num2str(aspectratio', '%.2f')));
%%
[~,~] = mkdir('output');
save('output/AspectRatio.mat','runs');
% Needs ghostscript installed, http://www.ghostscript.com/
addpath('export_fig');
export_fig('output/AspectRatio.pdf')



