function ret = groupruns(runs)

assert(length(unique(arrayfun(@(x) size(x.data,2),runs))) == 1,...
    'In order to group runs, they should all have the same number of time steps (typically, same time and same time step)');

ret = struct;
s = size(runs(1).data);
n = numel(runs(1).data);
alldata = cell2mat(arrayfun(@(x) reshape(x.data,n,1),runs,'UniformOutput',false));
meandata = mean(alldata,2);
stddata = std(alldata,0,2);
ret.data = reshape(meandata,s(1),s(2));
ret.std = reshape(stddata,s(1),s(2));

ret.params = struct;
for fnamecell = fieldnames(runs(1).params)'
    f = fnamecell{1};
    if isnumeric(runs(1).params.(f))
        paramvalues = cell2mat(arrayfun(@(x) x.params.(f),runs,'UniformOutput',false));
        consensusvalue = mean(paramvalues,2);
    else
        paramvalues = arrayfun(@(x) x.params.(f),runs,'UniformOutput',false);
        uniquevalues = unique(paramvalues);
        if length(uniquevalues) == 1
            consensusvalue = uniquevalues{1};
        else            
            consensusvalue = [];
        end
    end
    ret.params.(f) = consensusvalue;
end