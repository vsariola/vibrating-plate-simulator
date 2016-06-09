function ret = cell2runs(cellarray)
    ret = struct;
    for i = 1:length(cellarray)
        ret(i).data = cellarray{i}{1};
        ret(i).params = cellarray{i}{2};
    end
end