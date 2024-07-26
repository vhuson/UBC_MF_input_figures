function [ ba1, bx, settings ] = ephysBoxPlot(varargin )
%EPHYSERRORLINE(boxData) Plot boxplot of Data at default settings
%EPHYSERRORLINE(boxData,subgroups) Plot boxplot of data with subgroups defined scatters at default settings
%EPHYSERRORLINE(boxData,settings) Plot boxplot of Data input settings
%EPHYSERRORLINE(boxData,subgroups,settings) Plot line of yData at xData points input settings
%EPHYSERRORLINE(f1,...)Plot line in input figure
%yData: cell array with data in vectors
%xData: vector of points to plot
%f1: figure object
%settings: struct with settings (will be supplied with default set when
%neccessary

%check if we have a figure or not
if isa(varargin{1},'matlab.ui.Figure')
    f1 = varargin{1};
    varargin = varargin(2:end);
else
    f1 = gcf;
end
%   Inputs
switch numel(varargin)
    case 1
        %Only yData
        boxData = varargin{1};
        if ~iscell(boxData)
            boxData = {boxData};
        end
        subGroups = cellfun(@(x) rand(size(x)),boxData,'UniformOutput',...
            false);
        userSettings = struct;
    case 2
        if isa(varargin{2},'struct')
            boxData = varargin{1};
            if ~iscell(boxData)
                boxData = {boxData};
            end
            subGroups = cellfun(@(x) rand(size(x)),boxData,'UniformOutput',...
                false);
            
            userSettings = varargin{2};
            if isfield(userSettings,'scatter') && strcmp(userSettings.scatter,'subgroups')
                disp('Warning: Subgroups not given, scatters randomized');
            end
        else
            subGroups = varargin{2};
            boxData = varargin{1};
            if ~iscell(boxData)
                boxData = {boxData};
            end
            if ~iscell(subGroups)
                subGroups = {subGroups};
            end
            userSettings = struct;
        end
        
    case 3
        subGroups = varargin{2};
        boxData = varargin{1};
        userSettings = varargin{3};
        if ~iscell(boxData)
            boxData = {boxData};
        end
        if ~iscell(subGroups)
            subGroups = {subGroups};
        end
end

%Setting defaults
settings.Label = cellfun(@(x,y) [x,y],repmat({'Group '},1,numel(boxData)),...
    cellfun(@num2str,num2cell(1:numel(boxData)),'UniformOutput',false),...
    'UniformOutput',false);


%FaceColor 3 value RGB or 'none'
settings.FaceColor = 'none';
settings.BoxWidth = 0.6;
settings.LineWidth = 1.5;
settings.EdgeColor = [0 0 0;hsv(numel(boxData)-1)];
settings.notch = false;
settings.medColor = [1 0.08 0.08];
settings.outlier = true;
settings.noCap = false;
settings.scatter = 'none'; %'subgroups'; 'rand'; 'line'; 'none'; 'bee'; 'paired'
settings.scatterOutlier = false; %Only plot outliers
settings.stars = false(size(boxData));

settings.BoxSpace = 0.1;
settings.initSpace = 0.2;
settings.BoxPosition = [];

settings.Marker = 'o';
settings.MarkerSize = 8;
settings.MarkerEdgeWidth = 1.2;
settings.MarkerEdgeColor = [0 0 0;hsv(numel(boxData)-1)];
settings.MarkerFaceColor = 'none';

settings.xlim = 'auto';
settings.xtick = 'auto';
settings.xticklabels = 'auto';
settings.xtickrotation = 30;
settings.xlabel = '';

settings.ylim = 'auto';
settings.ytick = 'auto';
settings.yticklabels = 'auto';
settings.ytickrotation = 0;
settings.ylabel = '';

settings.inset = false;
settings.xSize = 10;
settings.ySize = 7;
settings.axPosAuto = true;
settings.axPos = [];
settings.axUnits = 'centimeters';
settings.axLineWidth = 1.5;
settings.axFontSize = 16;
settings.axFontWeight = 'normal';
settings.Font = 'Arial';
settings.a4 = false;
settings.bold = false;
settings.brokenAx = false;
settings.brokenSize = 0.2;
settings.brokenGap = 0.05;
settings.brokenYLim = 'auto';
settings.TickLength = [0.01 0.025];
settings.pairCat = sort([1:numel(boxData)/2,1:numel(boxData)/2]);

%violin plot settings
settings.violin = false;
settings.violWidthFactor = 10; %How much wider than the Box?
settings.violOutliers = false; %Don't plot outliers
settings.violBandwidth = false; %false means auto define
settings.violTrunc = false; %Truncate violin at data limits
settings.violColor = [0 0 0;hsv(numel(boxData)-1)];
settings.violAlpha = 0.2;
settings.violNoBar = false;
settings.violLineWidth = 1;
settings.violFullSetEstimate = true;

settings.pairLineWidth = 0.7;
settings.pairColor = [0 0 0];

settings.bottomScatter = false;
%Replace with user settings
userFields = fieldnames(userSettings);
for i=1:numel(userFields)
    settings.(userFields{i}) = userSettings.(userFields{i});
end
%Check if general color was specified
if isfield(settings,'MarkerColor')
    settings.MarkerEdgeColor = settings.MarkerColor;
    settings.MarkerFaceColor = settings.MarkerColor;
end

%Adjust BoxSpace in paired condition if not set
if strcmp(settings.scatter,'paired') && ~ismember({'BoxSpace'},userFields)
    settings.BoxSpace = 0.4;
end

%Calculate Box positions if necessary
if ~ismember({'BoxPosition'},userFields)
    if settings.violin
        vf = settings.violWidthFactor;
    else
        vf = 1;
    end
    
    settings.BoxPosition = repmat(settings.BoxSpace+settings.BoxWidth*vf,...
        1,numel(boxData));
    settings.BoxPosition(1) = settings.BoxPosition(1)...
        + settings.initSpace - 0.5*settings.BoxWidth*vf - settings.BoxSpace;
    settings.BoxPosition = cumsum(settings.BoxPosition);
elseif numel(settings.BoxPosition) < numel(boxData) %Make sure there are enough positions
    morePositions = repmat(settings.BoxSpace+settings.BoxWidth,...
        1,numel(boxData)-numel(settings.BoxPosition));
    morePositions = morePositions + max(settings.BoxPosition);
    settings.BoxPosition = [settings.BoxPosition,morePositions];
end

% %Change defaul x size for violin
% if ~ismember({'xSize'},userFields) && settings.violin
%     settings.xSize = 15;
% end

%Calculate xlim if necessary
if ~ismember({'xlim'},userFields)
    settings.xlim = [0,max(settings.BoxPosition)+...
        settings.BoxWidth*vf/2+settings.initSpace];
end
%Calculate xSize if necessary
if ~ismember({'xSize'},userFields)
    settings.xSize = max(settings.xlim)*1.5;
end

%Update necessary size fields
if settings.a4 
    sizeFields = {'MarkerSize','MarkerEdgeWidth',...
        'xSize','ySize','LineWidth','axLineWidth',...
        'pairLineWidth'};
    for i = find(~ismember(sizeFields,userFields))
        settings.(sizeFields{i}) = settings.(sizeFields{i})*0.5;
    end
    if ~ismember('axFontSize',userFields)
        settings.axFontSize = 10;
    end
end

if settings.bold 
    sizeFields = {'LineWidth','axLineWidth','pairLineWidth'};
    for i = find(~ismember(sizeFields,userFields))
        settings.(sizeFields{i}) = settings.(sizeFields{i})*2;
    end
    if ~ismember('axFontWeight',userFields)
        settings.axFontWeight = 'bold';
    end
end

%turn off outliers when plotting individual points
if ~strcmp(settings.scatter,'none')
    %Abort bad paired data
    if strcmp(settings.scatter,'paired')
        goodPair = true;
        if numel(boxData) ~= numel(settings.pairCat)
            disp('Bad Pair!!!')
            disp('Uneven number of datasets!')
            settings.scatter = 'rand';
            goodPair = false;
        end
        % Check if even numbers are input
        if goodPair
            for ii = 1:max(settings.pairCat)
                dataNumDiffs = diff(cellfun(@numel,boxData(settings.pairCat == ii)));
                if any(dataNumDiffs ~= 0)
                    disp('Bad Pair!!!')
                    disp('Paired data does not having matching counts!!')
                    settings.scatter = 'rand';
                    goodPair = false;
                end
            end
        end
    end
    settings.outlier = false;
    %make edgecolor black unless specified by user
    if ~ismember({'EdgeColor'},userFields)
        settings.EdgeColor = [0 0 0];
    end
    
end



%Make sure color is ok
colorFields = {'MarkerEdgeColor','MarkerFaceColor','EdgeColor','medColor',...
    'pairColor'};
if ~ischar(settings.FaceColor) %Add face color if specified
    colorFields = [colorFields,{'FaceColor'}]; 
    %Dont cycle edge color if facecolor is specified but edge color is not
    if ~ismember('EdgeColor',userFields)
        settings.EdgeColor = [0 0 0];
    end
end
for i =1:numel(colorFields)
    if size(settings.(colorFields{i}),1) < numel(boxData)
        %add the same colors
        moreColors = repmat(settings.(colorFields{i}),...
            numel(boxData)-size(settings.(colorFields{i}),1),1);
        settings.(colorFields{i}) = [settings.(colorFields{i});...
            moreColors];
    end
end

%Repeat settings where necessary
repeatFields = {'LineWidth','BoxWidth','notch','outlier','noCap',...
    'MarkerSize','pairLineWidth','Label'};
if ischar(settings.FaceColor) 
    repeatFields = [repeatFields,{'FaceColor'}]; 
end
for i = 1:numel(repeatFields)
    %Make sure elements are in a cell
    if ~iscell(settings.(repeatFields{i}))
        if isnumeric(settings.(repeatFields{i}))
            settings.(repeatFields{i}) = num2cell(settings.(repeatFields{i}));
        else %single string I guess
            settings.(repeatFields{i}) = {settings.(repeatFields{i})};
        end
    end
    settings.(repeatFields{i}) = repmat(settings.(repeatFields{i}),1,...
        ceil(numel(boxData)/numel(settings.(repeatFields{i}))));
end

%Plot random scatter if specified but subgroups is also given
if strcmp(settings.scatter, 'rand')
    subGroups = cellfun(@(x) rand(size(x)),boxData,'UniformOutput',...
                false);
end
if strcmp(settings.scatter, 'bee')
    %Smart pattern instead of random
    for bb = 1:numel(boxData)
        [sortData, sortIdx] = sort(boxData{bb});
        diffData = diff(sortData);
        diffData = diffData(:)';
        diffData = [1-diffData/max(diffData),0];
%         diffData_flt = medfilt1(diffData,round(numel(diffData)/5));
%         diffData_flt = smooth(diffData);
        diffData_flt = exp(exp(diffData));
        diffData_flt = diffData_flt-min(diffData_flt);
        diffData_flt = smooth(diffData_flt);
        diffData_flt = diffData_flt./max(diffData_flt);
        
        scatX = (rand(size(diffData_flt))-0.5).*diffData_flt;
        
        subGroups{bb}(sortIdx) = scatX+0.5;
    end
end


%Get axes position
[ axOffset ] = getNewAxisPosition( f1, settings );

if isempty(settings.axPos)
    settings.axPos = [axOffset(1) axOffset(2) settings.xSize settings.ySize];
    settings.axUnits = 'centimeters';
end

%create axes
ba1 = axes(f1,'LineWidth',settings.axLineWidth,'FontSize',settings.axFontSize,...
    'FontWeight',settings.axFontWeight,'Units',settings.axUnits,'XColor',[0 0 0],...
    'FontName',settings.Font,'TickLength',settings.TickLength,'YColor',[0 0 0],...
    'Position',settings.axPos,...
    'Color','none');
hold(ba1,'on')
bx = {};

%Get kernels for violin
if settings.violin
    violins = cell(numel(boxData),2);
    %Get bandwidth?
    if ~settings.violBandwidth
%         minData = min([boxData{:}]);
%         maxData = max([boxData{:}]);
%         settings.violBandwidth = (maxData-minData)/20;
        if settings.violFullSetEstimate
            estimate_data = 1:numel(boxData);
        else
        %Get data std and use dataset with the largest std to estimate
        %bandwidth for the whole plot with
            [~,estimate_data] = max(cellfun(@std,boxData));
        end
        boxQuantiles = quantile([boxData{estimate_data}],[0.25 0.75]);
        
        %Not sure where this estimate came from
%         settings.violBandwidth = diff(boxQuantiles)/5;
        
        
        normalize = 1.349;
        IQR = diff(boxQuantiles) / normalize;
        std_dev = std([boxData{estimate_data}]);
        if IQR > 0
            A = min(std_dev, IQR);
        else
            A = std_dev;
        end
        
        n = numel([boxData{estimate_data}]);
        %Silvermans rule of thumb
        settings.violBandwidth =  0.9 * A * n^(-0.2);
        %Scotts rule of thumb
%         settings.violBandwidth =  1.059 * A * n^(-0.2);

        %Arbitrary smaller bandwidth
%         settings.violBandwidth =  0.5 * A * n^(-0.2);
        
    end
    
    for jj = 1:numel(boxData)
        %Hot fix multiple bandwidth bug
        multi_bds = numel(settings.violBandwidth) > 1;
        if multi_bds
            all_bds = settings.violBandwidth;
            settings.violBandwidth = all_bds(jj);
        end
        [violins{jj,1}, violins{jj,2}]= getKernelDist(boxData{jj},settings);
        %Hot fix multiple bandwidth bug
        if multi_bds       
            settings.violBandwidth = all_bds;
        end
    end
    %Normalize violins
    maxViol = max([violins{:,1}]);
    violWidth = settings.BoxWidth{1}*settings.violWidthFactor/2;
    violins(:,1) = cellfun(@(x) {x./maxViol*violWidth},violins(:,1));
end

for i = 1:numel(boxData)
    if iscell(settings.FaceColor(i))
        faceColor = settings.FaceColor{i};
    else
        faceColor = settings.FaceColor(i,:);
    end
    if settings.violin
        patch([violins{i,1},-fliplr(violins{i,1})]+settings.BoxPosition(i),...
            [violins{i,2},fliplr(violins{i,2})],...
            settings.violColor(i,:),'FaceAlpha',settings.violAlpha,...
            'LineWidth',settings.violLineWidth);
        
    end
    if ~settings.violNoBar
    bx{i,1} = boxplot2(ba1,settings.BoxPosition(i),boxData{i},...
        'FaceColor',faceColor,...
        'BoxWidth',settings.BoxWidth{i},...
        'LineWidth',settings.LineWidth{i},...
        'EdgeColor',settings.EdgeColor(i,:),...
        'medColor',settings.medColor(i,:),...
        'notch',settings.notch{i},...
        'outlier',settings.outlier{i},...
        'noCap',settings.noCap{i});
    end
    %Plot scatter if we must
    if ~strcmp(settings.scatter,'none')
        if settings.violin
            scatWidth = violWidth*1.5;
        else
            scatWidth = settings.BoxWidth{i};
        end
        if strcmp(settings.scatter,'line')
            xScatter = settings.BoxPosition(i)+scatWidth/4;
            xScatter = repmat(xScatter,size(boxData{i}));
        elseif strcmp(settings.scatter,'rand') || strcmp(settings.scatter,'bee')
            xScatter = subGroups{i}*scatWidth+...
                (settings.BoxPosition(i)-scatWidth/2);
        elseif strcmp(settings.scatter,'subgroups')
            [~,~,xScatter] = unique(subGroups{i});
            xSpace = scatWidth/(max(xScatter)+1);
            xScatter = xScatter*xSpace+...
                (settings.BoxPosition(i)-scatWidth/2);
        elseif strcmp(settings.scatter,'paired')
            [~,firstPairs] = unique(settings.pairCat);
            [pairBol,pairIdent] = ismember(i,firstPairs);
            if pairBol && sum(settings.pairCat == pairIdent) == 2
                %First data of simple pair allign right
                xScatter = settings.BoxPosition(i)+scatWidth/3;
            else %default allign left
                xScatter = settings.BoxPosition(i)-scatWidth/3;
            end
            xScatter = repmat(xScatter,size(boxData{i}));
        end
        %Draw lines for paired scatters
        if strcmp(settings.scatter,'paired') && ismember(i,firstPairs) %First set, draw lines below scatter
            xPair = xScatter(1);
            pairIdent = find(i == firstPairs);
            pairIdx = find(settings.pairCat == pairIdent);
            for kk = 2:numel(pairIdx)
                xPair(end+1) = settings.BoxPosition(pairIdx(kk))-settings.BoxWidth{pairIdx(kk)}/3;
            end
            bx{i,3} = {};
            for jj = 1:numel(boxData{i})
                bx{i,3}{end+1} = plot(xPair,...
                    cellfun(@(x) x(jj),boxData(pairIdx)),...
                    'LineWidth',settings.pairLineWidth{i},...
                    'Color',settings.pairColor(i,:));
            end
        end
        
        if settings.scatterOutlier
            boxQuantiles = quantile(boxData{i},[0.25 0.75]);
            
            %Calc theoretical whiskers
            boxWhiskers = [boxQuantiles(1)-(1.5*(boxQuantiles(2)-boxQuantiles(1))),...
                boxQuantiles(2)+(1.5*(boxQuantiles(2)-boxQuantiles(1)))];
            
            
            outlierFltr = boxData{i} > boxWhiskers(1) & boxData{i} < boxWhiskers(2);
            scatterData = boxData{i}(~outlierFltr);
            xScatter = xScatter(~outlierFltr);
        else
            scatterData = boxData{i};
        end
        
        bx{i,2} = scatter(xScatter,scatterData,...
            'Marker',settings.Marker,...
            'SizeData',settings.MarkerSize{i},...
            'MarkerEdgeColor',settings.MarkerEdgeColor(i,:),...
            'MarkerFaceColor',settings.MarkerFaceColor(i,:),...
            'LineWidth',settings.MarkerEdgeWidth);
        if settings.bottomScatter
           ba1.Children = ba1.Children([2:end,1]);
        end
        
    end
end


% bx1 = boxplot2(ba1,bPos(1), b1Data, 'FaceColor', bCol(1,:), 'BoxWidth', bWidth,...
%     'lineWidth', 1.5,'EdgeColor','k','notch',false, 'medColor',[1 0 0]);
% bx2 = boxplot2(ba1,bPos(2), b2Data, 'FaceColor', bCol(2,:), 'BoxWidth', bWidth,...
%     'lineWidth', 1.5,'EdgeColor','k','notch',false, 'medColor',[1 0 0]);

%Axes correct
xlim(settings.xlim);
xticks(settings.BoxPosition);
xticklabels(settings.Label);
xtickangle(settings.xtickrotation);
xlabel(settings.xlabel)

ylim(settings.ylim);
yticks(settings.ytick);
yticklabels(settings.yticklabels);
ytickangle(settings.ytickrotation);
ylabel(settings.ylabel);

ba1.TickDir = 'out'; 
% if settings.a4
%     ba1.TickLength = [0.07/max(ba1.Position(3:4)) 0.0125];
% else
%     ba1.TickLength = [0.14/max(ba1.Position(3:4)) 0.025];
% end


%Default all digits same precision
digits = regexp(ba1.YTickLabels,'\.(.*)','match'); 
yDigits = max(cellfun(@length ,[digits{:}]))-1;
ytickformat(['%.',num2str(yDigits),'f']);

% digits = regexp(ba1.XTickLabels,'\.(.*)','match'); %Default all digits same precision
% xDigits = max(cellfun(@length ,[digits{:}]))-1;
% xtickformat(['%.',num2str(xDigits),'f']);

hold(ba1,'off')
%Unfinished feature
if settings.brokenAx
    %Shrink old axes
    ba1.Position(4) = ba1.Position(4)*(1-(settings.brokenSize+settings.brokenGap));   
    ba2 = copyobj(ba1,f1);
    ba1.Position = [axOffset(1)...
        axOffset(2)+settings.ySize*(1-settings.brokenSize)...
        settings.xSize settings.ySize*settings.brokenSize];
    ba1.XAxis.Visible = 'off';
    ba1.YLabel.Visible = 'off';
    ylim(ba1,settings.brokenYLim)
    ba1.YTick = ba1.YLim;
    
end


if any(settings.stars)
    %Get possible combinations
    start=1;
    partner=2;
    series = [];
    while start < numel(boxData)
        while partner <= numel(boxData)
            series(end+1,:) = [start,partner];
            partner = partner+1;
        end
        start = start+1;
        partner=start+1;
    end
    %Get highest Y Value
    for jj = 1:numel(ba1.Children)
        yBarCord(jj) = max(ba1.Children(jj).YData);
    end
    yBarCord = max(yBarCord);
    axCon = diff(ba1.YLim)*0.05;
    
    starBoxes = series(settings.stars(1:...
        min([size(series,1),numel(settings.stars)])),:);
    %warn if more stars were given than necessary
    if numel(settings.stars)~=size(series,1)
        disp(['Warning ', num2str(numel(settings.stars)),...
            ' star(s) input, and ',num2str(size(series,1)),...
            ' possible position(s)']);
    end
    for ii=1:size(starBoxes,1)
        xBarCords = settings.BoxPosition(starBoxes(ii,:));
        line(xBarCords,[yBarCord+axCon*ii yBarCord+axCon*ii],...
            'LineWidth',settings.LineWidth{starBoxes(1)}*1.2,...
            'Color',[0 0 0])
        text(mean(xBarCords),yBarCord+axCon*ii+axCon*0.7,'*',...
            'FontSize',settings.axFontSize*1.2,...
        'HorizontalAlignment','center','FontWeight','bold',...
        'FontName','Arial');
    end
    if yBarCord+axCon*ii+axCon*0.7 > ba1.YLim(2)
        disp('Warning: ySize changed for sig. line');
        oldTick = ba1.YTick;
        yMult = (yBarCord+axCon*ii+axCon*0.7)/ba1.YLim(2);
        ba1.Position(4) = ba1.Position(4)*yMult;
        ba1.YLim(2) = ba1.YLim(2)*yMult;
        ba1.YTick = oldTick;
    end
end
%Shuffle child order
if settings.inset
    f1.Children(1:2) = f1.Children([2,1]);
end
end
