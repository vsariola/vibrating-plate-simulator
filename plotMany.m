function plotMany(runs,titles)

alldata = [runs.data];

plot([0 max(alldata(1,:))],[0 0],'k--');
hold on;
styles = {'b-','r-','g-','m-','c-'};
markerStyles = {'ks','ko','kd','k^','kv'};
skip = 4;
markerTime = 0.3508; % [0.5 0.47 0.5 0.485 0.458];
h = zeros(1,length(runs));
for i = 1:length(runs)
    h(i) = plot(runs(i).data(1,1:skip:end),runs(i).data(2,1:skip:end),styles{i},'LineWidth',1.3);    
    ind = find(runs(i).data(1,:) > markerTime,1);
    plot(runs(i).data(1,ind),runs(i).data(2,ind),markerStyles{i},'MarkerSize',10,'LineWidth',1);
    hold on;
end
text(0.01,0,'Node','VerticalALign','bottom','HorizontalAlign','left');
hold off;
[~,h] = legend(h,titles,'Location','SouthWest');
for i = 1:length(runs)  
   set(h(i*2+length(runs)), 'Marker', markerStyles{i}(2),'MarkerSize', 8,'Color','k','LineWidth',1)      % Color only
end

xlim([0 runs(1).params.time]);
ylim([min(alldata(2,:))-1e-5 max(alldata(2,:))+1e-5]);

ylabel('X-position (m)');
xlabel('Time (s)');
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