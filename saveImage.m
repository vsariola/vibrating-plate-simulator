function saveImage(filename)

% Needs ghostscript installed, http://www.ghostscript.com/
addpath('export_fig');
export_fig(sprintf('output/%s.png',filename),'-r1200','-nocrop');