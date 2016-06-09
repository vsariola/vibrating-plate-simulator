function ret = parallelCall(funhandle,varargin)

% Arrays which we process one at the time are even arguments, numeric or cells,
% and have more than one column
numcols = arrayfun(@(x) size(x{1},2),varargin);
u = unique(numcols);
if (isempty(u))
    n = 1;
else    
    assert(length(u) == 1,...
        'Apart from singletons (which are singleton expanded), all arrays should have same number of column');
    n = u(1);
end

retCell = cell(1,n);

parfor i = 1:n
    sp = {};            
    for j = 1:length(varargin)
        if isnumeric(varargin{j})
            sp{j} = varargin{j}(:,i);
        else
            sp{j} = varargin{j}{i}
        end
    end
    retCell{i} = funhandle(sp{:});
end

ret = [retCell{:}];


