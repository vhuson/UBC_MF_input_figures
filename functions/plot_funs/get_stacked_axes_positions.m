function [all_positions, y_positions, panel_height, padding_height] = ...
    get_stacked_axes_positions(position,padding,num_panels)
%get_stacked_axes_positions Summary of this function goes here
%   Detailed explanation goes here

%Get panel and padding dimensions;
height = position(4);

panel_height = height / (num_panels + padding * (num_panels-1));
padding_height = panel_height*padding;
total_height = panel_height + padding_height;


%Get y positions
y_positions = position(2) + (0:num_panels-1) .* total_height;

all_positions = nan(num_panels,4);
for ii = 1:num_panels
    curr_position = position;
    curr_position(2) = y_positions(ii);
    curr_position(4) = panel_height;

    all_positions(ii,:) = curr_position;
end

end