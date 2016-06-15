function saveDataAndImage(filename,varargin)

fields = strjoin(varargin,''',''');
[~,~] = mkdir('output');
cmd = sprintf('save(''output/%s.mat'',''%s'')',filename,fields);
evalin('caller',cmd);
% Needs ghostscript installed, http://www.ghostscript.com/
addpath('export_fig');
export_fig(sprintf('output/%s.png',filename),'-r1200','-nocrop');