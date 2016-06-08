function visualize(data,params,skip)
    if (nargin < 3)
        skip = 1;
    end
    poly = rectanglePoly(params.diameter,params.height);
    h = standingWave(params.amplitude,params.wavelength,params.frequency);
    for i = 1:skip:size(data,2)
        time = data(1,i);
        position = data(2:3,i);
        theta = data(6,i);
        p = rototranslate(poly,position,theta);
        fill(p(1,:),p(2,:),'r');
        hold on;
        bl = [position(1);0] - [params.diameter;params.diameter] ;
        tr = [position(1);0] + [params.diameter;params.diameter] ;   
        xx = linspace(bl(1),tr(1));
        plot(xx,h(xx,time));
        s = max(i-skip*100,1);
        xx = data(2,s:skip:i);
        yy = data(3,s:skip:i);    
        scatter(xx,yy,40,((length(xx):-1:1)/length(xx))' * [1 0 0]);
        hold off;	
        axis([bl(1) tr(1) bl(2) tr(2)]);
        axis equal;
        title(sprintf('Time: %.3f',time));      
        pause(0.0000000001);
    end
end