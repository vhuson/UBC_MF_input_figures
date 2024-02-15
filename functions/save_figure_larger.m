function [] = save_figure_larger(f1,mag)
%UNTITLED8 Summary of this function goes here
%   Detailed explanation goes here
curr_paperPosition = get(f1, 'PaperPosition');
curr_PaperSize = get(f1,"PaperSize");

%Scale font sizest
change_fontsize_fig(f1,12*mag);
%png
set(f1, 'PaperPosition', [0 0 curr_paperPosition(3)*mag...
                            curr_paperPosition(4)*mag])
print(f1, 'MyFigure.png', '-dpng', '-r300' );   %save file as PNG w/ 300dpi
set(f1, 'PaperPosition', curr_paperPosition)
change_fontsize_fig(f1,12);

%pdf
% set(f1, 'PaperSize', curr_PaperSize.*mag)    % Same, but for PDF output
% print(f1, 'MyFigure.pdf', '-dpdf', '-r300' );   %save file as PDF w/ 300dpi
% set(f1, 'PaperSize', curr_PaperSize) 
end