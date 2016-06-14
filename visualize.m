function visualize(run,skip)
    if (nargin < 3)
        skip = 1;
    end
    poly = rectanglePoly(run.params.diameter,run.params.height);
    h = standingWave(run.params.amplitude,run.params.wavelength,run.params.frequency);
    for i = 1:skip:size(run.data,2)
        [bl,tr] = visualizeFrame(run,poly,h,i);
        s = max(i-skip*100,1);
        xx = run.data(2,s:skip:i);
        yy = run.data(3,s:skip:i);    
        hold on;
        scatter(xx,yy,40,((length(xx):-1:1)/length(xx))' * [1 0 0]);
        hold off;	
        axis([bl(1) tr(1) bl(2) tr(2)]);
        axis equal;
        title(sprintf('Time: %.3f',time));      
        pause(0.0000000001);
    end
end