function set_to_axes(all_axes,arg_names,val_pairs)
%Loop over all axes and set based on name value pairs
for ii = 1:numel(all_axes)
    for jj = 1:numel(arg_names)
        set(all_axes{ii},arg_names{jj},val_pairs{jj})
    end

end
end