function h = boxplot2(varargin)
%Custom Box plot function to act more like bar function
% boxplot2(ax, xPos, data)
% boxplot2(xPos, data)
% boxplot2(data)
% Name-Value pairs: 'notch' (boolean); 'FaceColor' ([R G B]); 
% 'BoxWidth' (double); 'LineWidth' (double); 'EdgeColor' ([R G B]); 
% 'medColor' Color of median line ([R G B]), 'outlier' Plot outliers (boolean)
boxArgs = varargin;

%Check if axes is input
if strcmp(class(boxArgs{1}),'matlab.graphics.axis.Axes')
    boxAxes = boxArgs{1};
    
    boxArgs = boxArgs(2:end);
else
    boxAxes = gca;
end

%Check if X,Y or just Y
if numel(boxArgs)>1 && isnumeric(boxArgs{2})
    boxX = boxArgs{1};
    boxY = boxArgs{2};
    
    boxArgs = boxArgs(3:end);
else %Assume only Y is given
    boxX = 1;
    boxY = boxArgs{1};
    
    boxArgs = boxArgs(2:end);
end

%Check name value pairs
[boxFace, boxWidth, LineWidth, EdgeColor, notch, medColor,...
    outlier,noCap] = boxNameValues(boxArgs);

%get quantiles
boxQuantiles = quantile(boxY,[0.25 0.5 0.75]);

%Calc theoretical whiskers
boxWhiskers = [boxQuantiles(1)-(1.5*(boxQuantiles(3)-boxQuantiles(1))),...
    boxQuantiles(3)+(1.5*(boxQuantiles(3)-boxQuantiles(1)))];

%Calc notch
if notch
    n(1) = boxQuantiles(2)-1.57*(boxQuantiles(3)-boxQuantiles(1))/...
        sqrt(numel(boxY));
    n(2) = boxQuantiles(2)+1.57*(boxQuantiles(3)-boxQuantiles(1))/...
        sqrt(numel(boxY));
end

%get real box dimensions
boxDim = [min(boxY(boxY>=boxWhiskers(1))),...
    boxQuantiles,...
    max(boxY(boxY<=boxWhiskers(2)))];

%Draw face
if ~ischar(boxFace)
    if notch
        p1 = fill(boxAxes,[boxX-0.5*boxWidth, boxX-0.5*boxWidth,...
            boxX-0.25*boxWidth, boxX-0.5*boxWidth, boxX-0.5*boxWidth,...
            boxX+0.5*boxWidth, boxX+0.5*boxWidth,...
            boxX+0.25*boxWidth, boxX+0.5*boxWidth, boxX+0.5*boxWidth],...
            [boxDim(2) n(1) boxDim(3) n(2) boxDim(4)...
            boxDim(4) n(2) boxDim(3) n(1) boxDim(2)],boxFace);
    else
        p1 = fill(boxAxes,[boxX-0.5*boxWidth, boxX-0.5*boxWidth,...
            boxX+0.5*boxWidth, boxX+0.5*boxWidth],...
            [boxDim(2) boxDim(4) boxDim(4) boxDim(2)],boxFace);
    end
end

%Draw median
if notch; medWidth = boxWidth/2; else; medWidth = boxWidth; end
medLine = line(boxAxes, [boxX-0.5*medWidth boxX+0.5*medWidth],...
    [boxDim(3) boxDim(3)],'LineWidth',LineWidth*1.5,'Color',medColor);
%Draw box
if notch
    boxLine = line(boxAxes, [boxX, boxX+0.5*boxWidth,...
        boxX+0.5*boxWidth, boxX+0.25*boxWidth, boxX+0.5*boxWidth,...
        boxX+0.5*boxWidth, boxX-0.5*boxWidth,...
         boxX-0.5*boxWidth, boxX-0.25*boxWidth, boxX-0.5*boxWidth,...
        boxX-0.5*boxWidth, boxX],...
        [boxDim(2) boxDim(2),...
        n(1) boxDim(3) n(2),...
        boxDim(4) boxDim(4),...
        n(2) boxDim(3) n(1),...
        boxDim(2), boxDim(2)],...
        'LineWidth',LineWidth,'Color',EdgeColor);
else
    boxLine = line(boxAxes, [boxX, boxX+0.5*boxWidth,...
        boxX+0.5*boxWidth, boxX-0.5*boxWidth, boxX-0.5*boxWidth, boxX],...
        [boxDim(2) boxDim(2) boxDim(4) boxDim(4) boxDim(2) boxDim(2)],...
        'LineWidth',LineWidth,'Color',EdgeColor);
end
% %Old box
% bh1 = line(boxAxes, [boxX-0.5*boxWidth boxX+0.5*boxWidth],...
%     [boxDim(2) boxDim(2)],'LineWidth',LineWidth,'Color',EdgeColor);
% 
% bh2 = line(boxAxes, [boxX-0.5*boxWidth/(2*notch) boxX+0.5*boxWidth/(2*notch)],...
%     [boxDim(3) boxDim(3)],'LineWidth',LineWidth*1.5,'Color','r');
% 
% bh3 = line(boxAxes, [boxX-0.5*boxWidth boxX+0.5*boxWidth],...
%     [boxDim(4) boxDim(4)],'LineWidth',LineWidth,'Color',EdgeColor);
% %Draw verticals
% if notch
%     bv1 = line(boxAxes, [boxX-0.5*boxWidth boxX-0.5*boxWidth],[boxDim(2) n(1)],...
%         'LineWidth',LineWidth,'Color',EdgeColor);
%     bv2 = line(boxAxes, [boxX+0.5*boxWidth boxX+0.5*boxWidth],[boxDim(2) n(1)],...
%         'LineWidth',LineWidth,'Color',EdgeColor);
%     bv3 = line(boxAxes, [boxX-0.5*boxWidth boxX-0.5*boxWidth],[n(2) boxDim(4)],...
%         'LineWidth',LineWidth,'Color',EdgeColor);
%     bv4 = line(boxAxes, [boxX+0.5*boxWidth boxX+0.5*boxWidth],[n(2) boxDim(4)],...
%         'LineWidth',LineWidth,'Color',EdgeColor);
%     nv1 = line(boxAxes, [boxX-0.5*boxWidth boxX-0.25*boxWidth],[n(1) boxDim(3)],...
%         'LineWidth',LineWidth,'Color',EdgeColor);
%     nv2 = line(boxAxes, [boxX+0.5*boxWidth boxX+0.25*boxWidth],[n(1) boxDim(3)],...
%         'LineWidth',LineWidth,'Color',EdgeColor);
%     nv3 = line(boxAxes, [boxX-0.5*boxWidth boxX-0.25*boxWidth],[n(2) boxDim(3)],...
%         'LineWidth',LineWidth,'Color',EdgeColor);
%     nv4 = line(boxAxes, [boxX+0.5*boxWidth boxX+0.25*boxWidth],[n(2) boxDim(3)],...
%         'LineWidth',LineWidth,'Color',EdgeColor);
% else
%     bv1 = line(boxAxes, [boxX-0.5*boxWidth boxX-0.5*boxWidth],boxDim([2,4]),...
%         'LineWidth',LineWidth,'Color',EdgeColor);
%     bv2 = line(boxAxes, [boxX+0.5*boxWidth boxX+0.5*boxWidth],boxDim([2,4]),...
%         'LineWidth',LineWidth,'Color',EdgeColor);
% end


%Draw whiskers
if boxDim(1)<boxDim(2)
    if ~noCap
        wh1 = line(boxAxes, [boxX-0.2*boxWidth boxX+0.2*boxWidth],...
            [boxDim(1) boxDim(1)],'LineWidth',LineWidth,'Color',EdgeColor);
    end
    wv1 = line(boxAxes, [boxX boxX],boxDim(1:2),'LineWidth',LineWidth,...
        'Color',EdgeColor);
end

if boxDim(5)>boxDim(4)
    if ~noCap
        wh2 = line(boxAxes, [boxX-0.2*boxWidth boxX+0.2*boxWidth],...
            [boxDim(5) boxDim(5)],'LineWidth',LineWidth,'Color',EdgeColor);
    end
    wv2 = line(boxAxes, [boxX boxX],boxDim(4:5),'LineWidth',LineWidth,...
        'Color',EdgeColor);
end


%Draw Outliers
if outlier
    boxOutliers = boxY(boxY<boxDim(1) | boxY>boxDim(5));
    
    if ~isempty(boxOutliers)
        if ~ischar(boxFace)
            scatCol = boxFace;
        else
            scatCol = EdgeColor;
        end
        
        sc1 = scatter(boxAxes,repmat(boxX,numel(boxOutliers),1),boxOutliers,...
            'MarkerEdgeColor',scatCol,...
            'LineWidth',LineWidth*0.7);
    end
end
%Assign h
h = [boxLine medLine];
if exist('wh1','var')
    h = [wh1 wv1 h];
elseif exist('wv1','var')
    h = [wv1 h];
end
if exist('wh2','var')
    h = [h wv2 wh2];
elseif exist('wv2','var')
    h = [wv2 h];
end
if exist('p1','var')
    h = [p1 h];
end
if exist('sc1','var')
   h = [h sc1];
end
end

function [boxFace, boxWidth, lineWidth, EdgeColor, notch, medColor,...
    outlier,noCap] = boxNameValues(boxArgs)
%Check for possible name value pairs and return plot settings

if sum(strcmpi('FaceColor',boxArgs)) == 1
    boxFace = boxArgs{find(strcmpi('FaceColor',boxArgs))+1};
else    
    boxFace = 'none';
end

if sum(strcmpi('BoxWidth',boxArgs)) == 1
    boxWidth = boxArgs{find(strcmpi('BoxWidth',boxArgs))+1};
else    
    boxWidth = 1;
end

if sum(strcmpi('LineWidth',boxArgs)) == 1
    lineWidth = boxArgs{find(strcmpi('LineWidth',boxArgs))+1};
else    
    lineWidth = 1;
end

if sum(strcmpi('EdgeColor',boxArgs)) == 1
    EdgeColor = boxArgs{find(strcmpi('EdgeColor',boxArgs))+1};
else    
    EdgeColor = [0 0 0];
end

if sum(strcmpi('notch',boxArgs)) == 1
    notch = boxArgs{find(strcmpi('notch',boxArgs))+1};
else    
    notch = false;
end

if sum(strcmpi('medColor',boxArgs)) == 1
    medColor = boxArgs{find(strcmpi('medColor',boxArgs))+1};
else    
    medColor = [1 0 0];
end

if sum(strcmpi('outlier',boxArgs)) == 1
    outlier = boxArgs{find(strcmpi('outlier',boxArgs))+1};
else    
    outlier = true;
end

if sum(strcmpi('noCap',boxArgs)) == 1
    noCap = boxArgs{find(strcmpi('noCap',boxArgs))+1};
else    
    noCap = false;
end
end