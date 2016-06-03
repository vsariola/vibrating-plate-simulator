function data = simulate(b,totaltime,deltaT,h,dh_dt,dh_dx)

position = b.position;
velocity = b.velocity;
acceleration = b.acceleration;
theta = b.theta;
omega = b.omega;
alpha = b.alpha;
polygon = b.polygon;
mass = b.mass;
restitution = b.restitution;
friction = b.friction;
inertia = b.inertia;

time = 0;
n = round(totaltime / deltaT);
data = zeros(7,n);
for i = 1:n
    % Save the current position and velocity
    data(:,i) = [time;position;velocity;theta;omega];   
    
    % Take time step and simulate dynamics
    time = time + deltaT;
    position = position + velocity * deltaT + 0.5 * acceleration * deltaT^2;
    velocity = velocity + acceleration * deltaT;
    theta = theta + omega * deltaT + 0.5 * alpha * deltaT^2;
    omega = omega + alpha * deltaT;
    
    % Rototranslate the collision polygon to world coordinates   
	p = rototranslate(polygon,position,theta);  
    
    % Check if any of the vertices is below surface
    diff = h(p(1,:),time) - p(2,:);
    ind = diff > 0;
    numcol = sum(ind);
    
    % If no collisions occur, skip to next cycle
    if (numcol == 0)
        continue;
    end
    
    % The collision point is average of all collision vertices. I.e. if 
    % two vertices collide, the center point is the collision point
    cp = mean(p(:,ind),2);
    rp = cp - position;
    
    % Calculate the relative velocity of the collision point relative to
    % the surface
    surface_velocity = [0;dh_dt(cp(1),time)];
    vp = velocity + [-omega * rp(2);omega * rp(1)] - surface_velocity;
    
    % Compute tangent and normal of the surface
    tangent = [1;dh_dx(cp(1),time)];
    tangent = tangent / norm(tangent,2);
    normal = [-tangent(2);tangent(1)];           

    % Kbefore = 0.5 * mass * norm(velocity,2)^2 + 0.5 * inertia * omega^2;
    
    % Elastic response
    % Apply impulse at the collision point
    cx = rp(1) * normal(2) - rp(2) * normal(1);
    j = -(1 + restitution)*vp'*normal / (1/mass + cx^2 / inertia);
    j = max(j,0);
    jn = j * normal;  
    % Update velocity and angular velocity with the normal impulse
    velocity = velocity + jn / mass;
    omega = omega + (rp(1) * jn(2) - rp(2) * jn(1)) / inertia;

    % Friction response
    % http://gafferongames.com/virtual-go/collision-response-and-coulomb-friction/
    ct = rp(1) * tangent(2) - rp(2) * tangent(1);
    j2 = -vp'*tangent / (1/mass + ct^2 / inertia);
    maxj2 = j*friction;
    minj2 = -j*friction;            
    j2 = min(maxj2,max(minj2,j2));
    jt = j2 * tangent;  
    % Update velocity and angular velocity with the tangent impulse    
    velocity = velocity + jt / mass;
    omega = omega + (rp(1) * jt(2) - rp(2) * jt(1)) / inertia;       
    
    %Kafter = 0.5 * mass * norm(velocity,2)^2 + 0.5 * inertia * omega^2;
    
    %Kdelta = Kafter - Kbefore;
    
    %if (Kdelta > 0)
    %    disp('The kinetic energy just increased in a bounce!!!');
    %end
end