close all
clear all

%%
tic;
normposs = linspace(-0.5,0.5,16);
xdata = cell(1,length(normposs));
for i = 1:length(normposs)    
    normalizedPosition = normposs(i);
    initialize;
    data = simulate(b,totaltime,deltaT,h,dh_dt,dh_dx);
    xdata{i} = data(2,:);
end
toc;
%%
xdatamat = cell2mat(xdata');
plot(data(1,:),xdatamat,'LineWidth',1.3);
ylabel('X-position (m)');
xlabel('Time (s)');
xlim([min(data(1,:)) max(data(1,:))]),

legend('boxoff');         % No boxes in legends
fsize = 12;
set(gca,'FontName','Arial','FontSize', fsize) % Arial everywhere, the point size depends on the size of you Figure object, let's adjust that finally so they are close to identical in the final Figure
h = get(gca, 'title');
set(h ,'FontName','Arial','FontSize', fsize)
h = get(gca, 'xlabel');
set(h,'FontName','Arial','FontSize', fsize)
h = get(gca, 'ylabel');
set(h ,'FontName','Arial','FontSize', fsize)
set(gcf,'color','w'); % white background

print('Position','-dpdf')



