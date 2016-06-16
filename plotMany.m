function labelpos = plotMany(runs,varargin)

fname = 'Arial';
fsize = 12;

alldata = [runs.data];
if isfield(runs,'std')
    allstd = [runs.std];
end
p = inputParser();
addRequired(p,'runs');
addParameter(p,'legendlocation',[]);
addParameter(p,'labels',[]);
addParameter(p,'markertime',[]);
addParameter(p,'plotnodes',false);
addParameter(p,'skip',size(alldata,2) / 2000);
addParameter(p,'ginputlabels',false);
addParameter(p,'labelfile',[]);
parse(p,runs,varargin{:});

fig_width = 8.4*1.5;
fig_height = 6*1.5;
figure('units','centimeters','Position',[1 1 fig_width fig_height]);
lmargin = 1.05;
rmargin = 0.15;
tmargin = 0.6;
bmargin = 1.2;
ax_width = fig_width - lmargin - rmargin;
ax_height = fig_height - tmargin - bmargin;
axes('units','centimeters','Position',[lmargin bmargin ax_width ax_height]);
hold on;
xmin = 0;
xmax = runs(1).params.time;
if isfield(runs,'std')
    minpos = min(alldata(2,:)-allstd(2,:));
    maxpos = max(alldata(2,:)+allstd(2,:));
else
    minpos = min(alldata(2,:));
    maxpos = max(alldata(2,:));
end
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

if ~isempty(p.Results.legendlocation)
    [leg,hl] = legend(h,p.Results.labels,'Location',p.Results.legendlocation);    
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

if ~isempty(p.Results.labelfile)
    filepath = fullfile('output',[p.Results.labelfile '.mat']);
end

if p.Results.ginputlabels || ~isempty(p.Results.labelfile)    
   labelpos = zeros(length(p.Results.labels),4);
   if ~isempty(p.Results.labelfile) && exist(filepath,'file')
       d = load(filepath);
       if isfield(d,'labelpos')
           labelpos_old = d.labelpos;
       end
   end   
   for i = 1:length(p.Results.labels)
       if p.Results.ginputlabels || ~exist('labelpos_old','var')
           k = reshape(ginput(2)',1,4);           
       else
           k = labelpos_old(i,:);           
       end
       labelpos(i,:) = k;
       d2 = (runs(i).data(1,:) - k(1)) .^ 2 + (runs(i).data(2,:) - k(2)) .^ 2;
       [~,ind] = min(d2);
       x = runs(i).data(1,ind);
       y = runs(i).data(2,ind);
       hold on;
       plot([x k(3)],[y k(4)],'k-');
       hold off;
       if (k(3) > x)
           halign = 'left'; 
           k(3) = k(3) + xmax*0.01;
       else           
           halign = 'right';
           k(3) = k(3) - xmax*0.01;
       end
       text(k(3),k(4),p.Results.labels{i},'HorizontalAlign',halign,'VerticalAlign','middle','FontName',fname,'FontSize',fsize);       
   end
end
if ~isempty(p.Results.labelfile)    
    save(filepath,'labelpos'); 
end
