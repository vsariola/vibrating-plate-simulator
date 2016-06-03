function visualize(data,polygon,h)
    width = max(polygon(1,:)) - min(polygon(1,:));
    for i = 1:size(data,2)
        time = data(1,i);
        position = data(2:3,i);
        theta = data(6,i);
        p = rototranslate(polygon,position,theta);
        fill(p(1,:),p(2,:),'r');
        hold on;
        bl = [position(1);0] - 1*[width;width] ;
        tr = [position(1);0] + 1*[width;width] ;   
        xx = linspace(bl(1),tr(1));
        plot(xx,h(xx,time));
        hold off;	
        axis([bl(1) tr(1) bl(2) tr(2)]);
        axis equal;
        pause(0.0000000001);
    end
end