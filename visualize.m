function visualize(run,varargin)
   
    p = inputParser();
    addRequired(p,'run');    
    p.addParameter('video',[]);        
    p.addParameter('videospeed',[]);       
    p.addParameter('fps',60);       
    p.addParameter('skip',1,@isnumeric);
    
    parse(p,run,varargin{:});
        
    skip = p.Results.skip;    
    videospeed = p.Results.videospeed;
    
    if ~isempty(p.Results.video)       
       v = VideoWriter(p.Results.video,'MPEG-4');
       v.FrameRate = p.Results.fps;
       open(v); 
       if ~isempty(videospeed)
           skip = ceil(p.Results.videospeed/(p.Results.fps*run.params.dt));
           videospeed = skip*p.Results.fps*run.params.dt;
       end
    end
    
    fig_width_pixels = 640;
    fig_height_pixels = 480;
    lmargin = 60;
    bmargin = 50;
    tmargin = 20;
    rmargin = 60;
    ax_width_pixels = fig_width_pixels - lmargin - rmargin;
    ax_height_pixels = fig_height_pixels - tmargin - bmargin;
    ar = ax_width_pixels / ax_height_pixels;
    figure('units','pixels','Position',[100 100 fig_width_pixels fig_height_pixels]);
    axes('units','pixels','Position',[lmargin bmargin ax_width_pixels ax_height_pixels]);
    poly = rectanglePoly(run.params.diameter,run.params.height);
    h = standingWave(run.params.amplitude,run.params.wavelength,run.params.frequency);    
    shift = run.params.height/2;
    for i = 1:skip:size(run.data,2)
        x1 = run.data(2,i) - 0.55 * run.params.diameter;
        x2 = run.data(2,i) + 0.55 * run.params.diameter;
        xx = linspace(x1-run.params.diameter*0.02,x2+run.params.diameter*0.02);
        height = (x2 - x1) / ar;
        y1 = -height/2+shift;
        y2 = height/2+shift;
        [~,~,time] = visualizeFrame(run,poly,h,i,xx);
        s = max(i-skip*100,1);
        xx = run.data(2,s:skip:i);
        yy = run.data(3,s:skip:i);    
        hold on;
        scatter(xx,yy,40,((length(xx):-1:1)/length(xx))' * [1 0 0]);
        hold off;	
        axis([x1 x2 y1 y2]);        
        title(sprintf('Time: %.3f s',time));                            
        fsize = 12;
        fname = 'Arial';
        ylabel('Y-position (m)');
        xlabel('X-position (m)');
        set(gca,'FontName',fname,'FontSize', fsize) % Arial everywhere, the point size depends on the size of you Figure object, let's adjust that finally so they are close to identical in the final Figure
        hl = get(gca, 'title');
        set(hl ,'FontName',fname,'FontSize', fsize)
        hl = get(gca, 'xlabel');
        set(hl,'FontName',fname,'FontSize', fsize)
        hl = get(gca, 'ylabel');
        set(hl ,'FontName',fname,'FontSize', fsize)
        if ~isempty(videospeed)
            text(1,1.01,sprintf('X %.2f',videospeed),'units','normalized','FontName',fname,'FontSize',fsize,'VerticalAlign','bottom','HorizontalAlign','right');
        end
        set(gcf,'color','w'); % white background
        box on;        
        
        pause(0.0000000001);
        if ~isempty(p.Results.video)
            F = getframe(gcf);
            writeVideo(v,F);     
        end
    end
end