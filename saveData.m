function saveData(filename,varargin)

fields = strjoin(varargin,''',''');
[~,~] = mkdir('output');
cmd = sprintf('save(''output/%s.mat'',''%s'')',filename,fields);
evalin('caller',cmd);
