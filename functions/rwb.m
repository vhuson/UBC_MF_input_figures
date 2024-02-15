function map = rwb(m)

if nargin < 1
   f = get(groot,'CurrentFigure');
   if isempty(f)
      m = size(get(groot,'DefaultFigureColormap'),1);
   else
      m = size(f.Colormap,1);
   end
end

values = [1 0 0;
          1 1 1;
          0 0 1];

P = size(values,1);
map = interp1(1:size(values,1), values, linspace(1,P,m), 'linear');
