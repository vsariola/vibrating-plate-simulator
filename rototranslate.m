function p = rototranslate(polygon,position,theta)
    R = [cos(theta) -sin(theta);sin(theta) cos(theta)];
	p = R * polygon + position * ones(1,size(polygon,2));        
end