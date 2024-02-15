function [full_struct] = merge_structs(base_struct,new_struct)
%UNTITLED11 Summary of this function goes here
%   Detailed explanation goes here
full_struct = base_struct;

base_fieldnames = fieldnames(base_struct);
new_fieldnames = fieldnames(new_struct);

change_fields = find(ismember(base_fieldnames,new_fieldnames));

for ii = 1:numel(change_fields)
    curr_field = base_fieldnames{change_fields(ii)};
    full_struct.(curr_field) = new_struct.(curr_field);
end


end