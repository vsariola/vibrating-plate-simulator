clear all

%%
tic;
diameter = [100e-6 200e-6 350e-6 600e-6 1e-3];
height = 0.5 .* diameter;
runs= struct();
parfor i = 1:length(diameter)
    [data,params] = simulate('time',1,'diameter',diameter(i),'height',height(i),'position',[7.5e-4;height(i)/2]);
    runs(i).data = data;
    runs(i).params = params;
end
toc;
%%
close all
plotMany(runs,cellstr(num2str(diameter' * 1e6, '\\it{d} = %.0f µm')));
%%
[~,~] = mkdir('output');
save('output/Size.mat','runs');
% Needs ghostscript installed, http://www.ghostscript.com/
addpath('export_fig');
export_fig('output/Size.pdf')



