function leg = plotMany(runs,varargin)

p = inputParser();
addRequired(p,'runs');
addParameter(p,'legendlocation','SouthWest');
addParameter(p,'legendtitles',[]);
addParameter(p,'markertime',[]);
parse(p,runs,varargin{:});

alldata = [runs.data];

xmin = 0;
xmax = runs(1).params.time;
minpos = min(alldata(2,:));
maxpos = max(alldata(2,:));
diffpos = maxpos - minpos;
ymin = minpos - 0.05 * diffpos;
ymax = maxpos + 0.05 * diffpos;
nodes = ceil(2*ymin/runs(1).params.wavelength):floor(2*ymax/runs(1).params.wavelength);
for i = nodes
   yy = i*runs(1).params.wavelength/2;
   plot([xmin xmax],[yy yy],'k-','LineWidth',1.3); 
   text(xmax+(xmax-xmin)*0.01,yy,'Node');
   hold on;
end
nodes = ceil(2*ymin/runs(1).params.wavelength-0.5):floor(2*ymax/runs(1).params.wavelength-0.5);
for i = nodes
   yy = (i+0.5)*runs(1).params.wavelength/2;
   plot([xmin xmax],[yy yy],'k--','LineWidth',1.3); 
   text(xmax+(xmax-xmin)*0.01,yy,sprintf('Anti-\nnode'));
   hold on;
end
styles = {'b-','r-','g-','m-','c-','y-'};
markerStyles = {'ks','ko','kd','k^','kv','k<'};
skip = 4;
h = zeros(1,length(runs));
for i = 1:length(runs)
    h(i) = plot(runs(i).data(1,1:skip:end),runs(i).data(2,1:skip:end),styles{mod(i-1,length(styles))+1},'LineWidth',1.3);           
end
if (~isempty(p.Results.legendtitles)) 
    [leg,hl] = legend(h,p.Results.legendtitles,'Location',p.Results.legendlocation);    
    if ~isempty(p.Results.markertime)
        for i = 1:length(runs)  
            set(hl(i*2+length(runs)), 'Marker', markerStyles{i}(2),'MarkerSize', 8,'Color','k','LineWidth',1)      % Color only
        end
    end
    legend('boxoff');         % No boxes in legends
    if ~isempty(p.Results.markertime)
        for i = 1:length(runs)
            ind = find(runs(i).data(1,:) > p.Results.markertime,1);
            plot(runs(i).data(1,ind),runs(i).data(2,ind),markerStyles{i},'MarkerSize',10,'LineWidth',1);        
        end   
    end
end
hold off;

xlim([xmin xmax]);
ylim([ymin ymax]);

ylabel('X-position (m)');
xlabel('Time (s)');
fsize = 12;
set(gca,'FontName','Arial','FontSize', fsize) % Arial everywhere, the point size depends on the size of you Figure object, let's adjust that finally so they are close to identical in the final Figure
h = get(gca, 'title');
set(h ,'FontName','Arial','FontSize', fsize)
h = get(gca, 'xlabel');
set(h,'FontName','Arial','FontSize', fsize)
h = get(gca, 'ylabel');
set(h ,'FontName','Arial','FontSize', fsize)
set(gcf,'color','w'); % white background