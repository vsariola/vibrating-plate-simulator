close all
clear all

run = simulate('wavelength',80e-3,'amplitude',40e-6,'restitution',0.8,'time',0.24);

ar = 3.7910;
skip = 1600;

frameList = 1:skip:size(run.data,2);
frames = length(frameList);

width = 5; % centimeters
height = width/ar;
spacing = 1.02; % relative to height
figure('units','centimeters','Position',[1 1 width height*(1+(frames-1)*spacing)]);

poly = rectanglePoly(run.params.diameter,run.params.height);
h = standingWave(run.params.amplitude,run.params.wavelength,run.params.frequency);

x1 = run.data(2,end) - run.params.diameter * 0.55;
x2 = run.data(2,1) + run.params.diameter * 0.55;
ytot = (x2 - x1) / ar;
shift = run.params.diameter * 0.2;
y1 = -ytot/2+shift;
y2 = ytot/2+shift;

xx = linspace(x1,x2);

for i = 1:length(frameList)
	axes('units','centimeters','Position',[0 (frames-i)*spacing*height width height]);
    axis([x1 x2 y1 y2]);
    hold on;
	visualizeFrame(run,poly,h,frameList(i),xx);        
    box off;
    set(gca,'XTick',[]);
    set(gca,'YTick',[]);
    text(0.97,0.97, sprintf('\\it{t} = %.3f s',run.data(1,frameList(i))), 'HorizontalAlign','right','VerticalAlign','top','units','normalized','color','k')
end
    
addpath('export_fig');
export_fig('output/Sequence.pdf');