function [bl,tr,time] = visualizeFrame(run,poly,h,frameNumber,xx)
    time = run.data(1,frameNumber);
    position = run.data(2:3,frameNumber);
    theta = run.data(6,frameNumber);
    p = rototranslate(poly,position,theta);
    fill(p(1,:),p(2,:),'r');
    hold on;
    bl = [position(1);0] - 0.55 * [run.params.diameter;run.params.diameter] ;
    tr = [position(1);0] + 0.55 * [run.params.diameter;run.params.diameter] ;   
    if (nargin < 5)        
        xx = linspace(bl(1),tr(1));
    end    
    area(xx',h(xx,time)',-1,'FaceColor',[0.8 0.8 0.8]);    
    hold off;
end