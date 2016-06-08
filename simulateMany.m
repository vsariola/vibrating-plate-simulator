function ret = simulateMany(varargin)

combs = allcomb(varargin{2:2:end});

ret = struct();

parfor i = 1:size(combs,1)
    sp = varargin;
    for j = 2:2:length(varargin)
        sp{j} = combs(i,j/2);
    end
    [data,params] = simulate(sp{:});
    ret(i).data = data;
    ret(i).params = params;
end

