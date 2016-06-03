close all
clear all

%%
tic;
frequencies = [5 10 15 20];
xdata = cell(1,length(frequencies));
for i = 1:length(frequencies)
	normalizedFrequency = frequencies(i);
    initialize;
    data = simulate(b,totaltime,deltaT,h,dh_dt,dh_dx);
    xdata{i} = data;
end
toc;
%%
figure;
styles = {'b-','r-','g-','m-','c-'};
for i = 1:length(frequencies)
    plot(xdata{i}(1,:),xdata{i}(2,:),styles{i},'LineWidth',1.3);
    hold on;
end
hold off;
legendCell = cellstr(num2str(frequencies', 'f_n = %.1f'));
legend(legendCell,'Location','NorthEast');
ylabel('X-position (m)');
xlabel('Time (s)');
xlim([min(data(1,:)) max(data(1,:))]);

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

print('Frequency','-dpdf')



