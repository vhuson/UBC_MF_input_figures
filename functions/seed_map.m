function map = seed_map(seed,m)

if nargin < 2
   f = get(groot,'CurrentFigure');
   if isempty(f)
      m = size(get(groot,'DefaultFigureColormap'),1);
   else
      m = size(f.Colormap,1);
   end
end

values = seed;

P = size(values,1);
map = interp1(1:size(values,1), values, linspace(1,P,m), 'linear');
end