function ax = upanel_plot(countdat,Y,namedat,namesel,psuid,pmode,ax_pos,curr_fig)
if nargin < 7
    ax_pos = [0.13 0.13 0.8 0.8];
end
if nargin < 8
    curr_fig = gcf;
end
ndisp = numel(namesel);
nrow = max(floor(sqrt(ndisp)),1);
ncolumn = ceil(ndisp/nrow);
psuid = psuid(~isnan(psuid));
Ysorted = Y(psuid,:);

mrksize = 5;
alphav = .5;
if ndisp == 1
    ax = axes(curr_fig,'Position',ax_pos);
else
    ax = {};
end
for i = 1:ndisp
    if ndisp > 1
        ax{i} = subplot(nrow,ncolumn,i);
    end
    datdisp = countdat(:,find(strcmp(namedat,namesel{i})));
    if strcmp(pmode,'tsne')
        [~,sidx] = sort(datdisp);
        scatter(Y(sidx,1),Y(sidx,2),mrksize,datdisp(sidx),'filled','MarkerFaceAlpha',alphav)
        title(namesel{i})
        if ndisp > 1
            axis equal off;
        else
            axis tight off;
        end
        colormap('fire')
        if contains(namesel{i},'NNMF')
            caxis([0 1.05*max(datdisp)]);
        elseif contains(namesel{i},'PsuID')
            scatter(Y(sidx,1),Y(sidx,2),mrksize,'k','filled','MarkerFaceAlpha',.01);
            axis equal off;  hold on;
            title('Pseudotime')
            caxis([0 1]);
            nsteps = 10;
            ym1 = nan(round(numel(psuid)/nsteps),1);
            ym2 = nan(round(numel(psuid)/nsteps),1);
            for j = 1:nsteps:numel(psuid)-nsteps
                ym1((j-1)/nsteps+1) = mean(Ysorted(j:j+nsteps,1));
                ym2((j-1)/nsteps+1) = mean(Ysorted(j:j+nsteps,2));
            end
            plot(smoothdata(ym1,'gaussian',3),smoothdata(ym2,'gaussian',3),'r-')
        %elseif contains(namesel{i},{'Grm2','Gna11'})
        %    caxis([5 30]);
        else
            if sum(datdisp>1e-3)>0
                caxis([0 2.5*nanmean(datdisp(datdisp>1e-3))]);
            else
                caxis([0 1])
            end
        end
    else
        datdisp = countdat(psuid,find(strcmp(namedat,namesel{i})));
        alphav = .5;
        mrksize = 10;
        scatter(1:numel(psuid),datdisp,mrksize,'filled','MarkerFaceAlpha',alphav)
        axis tight; 
        title(namesel{i})
        if contains(namesel{i},'NNMF')
            ylim([0 1.05*max(datdisp)]);
        elseif contains(namesel{i},'PsuID')
            ylim([0 max(datdisp)]);
        else
            ylim([0 3*nanmean(datdisp(datdisp>1e-3))]);
        end
    end
end