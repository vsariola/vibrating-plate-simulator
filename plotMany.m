function leg = plotMany(runs,varargin)

fname = 'Arial';
fsize = 8;

alldata = [runs.data];

p = inputParser();
addRequired(p,'runs');
addParameter(p,'legendlocation','SouthWest');
addParameter(p,'legendtitles',[]);
addParameter(p,'markertime',[]);
addParameter(p,'plotnodes',false);
addParameter(p,'skip',size(alldata,2) / 2000);
parse(p,runs,varargin{:});

figure('units','centimeters','Position',[1 1 5.3 4]);
axes('Position',[0.09 0.12 0.82 0.82]);
hold on;
xmin = 0;
xmax = runs(1).params.time;
minpos = min(alldata(2,:));
maxpos = max(alldata(2,:));
diffpos = maxpos - minpos;
ymin = minpos - 0.03 * diffpos;
ymax = maxpos + 0.03 * diffpos;
if p.Results.plotnodes
    nodes = ceil(2*ymin/runs(1).params.wavelength):floor(2*ymax/runs(1).params.wavelength);
    for i = nodes
       yy = i*runs(1).params.wavelength/2;
       plot([xmin xmax],[yy yy],'k-','LineWidth',1.3); 
       text(xmax+(xmax-xmin)*0.01,yy,'Node','FontName',fname,'FontSize',fsize);
       hold on;
    end
    nodes = ceil(2*ymin/runs(1).params.wavelength-0.5):floor(2*ymax/runs(1).params.wavelength-0.5);
    for i = nodes
       yy = (i+0.5)*runs(1).params.wavelength/2;
       plot([xmin xmax],[yy yy],'k--','LineWidth',1.3); 
       text(xmax+(xmax-xmin)*0.01,yy,sprintf('Anti-\nnode'));
       hold on;
    end
end
styles = {'b-','r-','g-','m-','c-','y-'};
colors = [228,26,28;55,126,184;77,175,74;152,78,163;255,127,0] / 255;
markerStyles = {'ks','kd','k^','kv','k<','k>'};
skip = p.Results.skip;
h = zeros(1,length(runs));
for i = 1:length(runs)
    if (isfield(runs,'std'))        
        x = runs(i).data(1,1:skip:end);
        y = runs(i).data(2,1:skip:end);   
        errBar = runs(i).std(2,1:skip:end);
        % hst = shadedErrorBar(x,y,errBar,styles{mod(i-1,length(styles))+1},1);
        hst = shadedErrorBar(x,y,errBar,{'-','color',colors(mod(i-1,size(colors,1))+1,:)},1);
        hst.mainLine.LineWidth = 1.3;
        h(i) = hst.mainLine;        
    else        
        h(i) = plot(runs(i).data(1,1:skip:end),runs(i).data(2,1:skip:end),styles{mod(i-1,length(styles))+1},'LineWidth',1.3);           
    end    
end

if (~isempty(p.Results.legendtitles)) 
    [leg,hl] = legend(h,p.Results.legendtitles,'Location',p.Results.legendlocation);    
    if ~isempty(p.Results.markertime)
        for i = 1:length(runs)  
            set(hl(i*2+length(runs)), 'Marker', markerStyles{i}(2),'LineWidth',1.3,'MarkerSize', 7,'Color','k')      % Color only
        end
    end
    legend('boxoff');         % No boxes in legends
    if ~isempty(p.Results.markertime)
        for i = 1:length(runs)
            ind = find(runs(i).data(1,:) > p.Results.markertime,1);
            plot(runs(i).data(1,ind),runs(i).data(2,ind),markerStyles{i},'MarkerSize',10,'LineWidth',1.3);        
        end   
    end
end
hold off;

xlim([xmin xmax]);
ylim([ymin ymax]);

ylabel('X-position (m)');
xlabel('Time (s)');
set(gca,'FontName',fname,'FontSize', fsize) % Arial everywhere, the point size depends on the size of you Figure object, let's adjust that finally so they are close to identical in the final Figure
h = get(gca, 'title');
set(h ,'FontName',fname,'FontSize', fsize)
h = get(gca, 'xlabel');
set(h,'FontName',fname,'FontSize', fsize)
h = get(gca, 'ylabel');
set(h ,'FontName',fname,'FontSize', fsize)
set(gcf,'color','w'); % white background
box on;
