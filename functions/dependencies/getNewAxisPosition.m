function [ axOffset ] = getNewAxisPosition( f1, settings )
%GETNEWAXISPOSITION generate axis coordinates to automatically tile axes
%Takes in figure object and settings structure
%Standard axis offset
if isfield(settings,'axFloat')
    axFloat = settings.axFloat;
elseif isfield(settings,'a4') && settings.a4
    axFloat = 2;
else
    axFloat = 3;
end
%Get Axes
FigAxes = findobj(f1,'Type','Axes');

%Get axes position
if ~isempty(FigAxes) && settings.axPosAuto
    %match child and figure units
    figUnits = f1.Units;
    f1.Units = FigAxes(1).Units;
    
    xOff = sum(FigAxes(1).Position([1,3]))+axFloat;
    if settings.inset
        xOff = xOff-settings.xSize-axFloat;
        if isfield(settings,'insetBottom') && settings.insetBottom
            yOff = FigAxes(1).Position(2)+axFloat;
        else
            yOff = sum(FigAxes(1).Position([2,4]));
            yOff = yOff-settings.ySize;
        end
    else
        if xOff+settings.xSize > f1.Position(3)*0.95
            yPositions = vertcat(FigAxes.Position);
            yOff = max(yPositions(:,2)+yPositions(:,4))+axFloat;
            xOff = axFloat;
        else
            yOff = FigAxes(1).Position(2);
        end
    end
    axOffset = [xOff yOff];
    
    %reset figure units
    f1.Units = figUnits;
else
    axOffset = [axFloat axFloat];
end


end

