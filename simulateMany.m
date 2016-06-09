function ret = simulateMany(varargin)

% Arrays which we process one at the time are even arguments, numeric or cells,
% and have more than one column
inds = arrayfun(@(i) mod(i,2) == 0 & (iscell(varargin{i}) | isnumeric(varargin{i})) & size(varargin{i},2) > 1,1:length(varargin));
numcols = arrayfun(@(x) size(x{1},2),varargin(inds));
u = unique(numcols);
if (isempty(u))
    n = 1;
else    
    assert(length(u) == 1,...
        'Apart from singletons (which are singleton expanded), all arrays should have same number of column');
    n = u(1);
end

z = 1:length(varargin);
indexlist = z(inds);

ret = struct();

parfor i = 1:n
    sp = varargin;            
    for j = indexlist
        if isnumeric(varargin{j})
            sp{j} = varargin{j}(:,i);
        else
            sp{j} = varargin{j}{i}
        end
    end
    [data,params] = simulate(sp{:});
    ret(i).data = data;
    ret(i).params = params;
end

