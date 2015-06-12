function [] = plotcon(data, filename, fit, logs)
%% %% plot 2-D contours of real data
%% arguments:
%% filename: name of output file
%% fit: additional parameter to control name of file
%% logs = 1 -> log-scale. Use 0 as default.
    if isempty(logs)
        logs = false;
    end
    %outname = sprintf('./plots/%s_%s%d.pdf', filename, fit, logs);
    outname = sprintf('%s,pdf', filename);
    maxvx=25;
    maxvy=25;
    [X,Y]=meshgrid(0:maxvx,0:maxvy);
    n=size(data,1);
    ind = 1:n;
    if (logs)
        ind = find(data(ind,1)>=1 & data(ind,1)<=maxvx & data(ind,2)>=1 & data(ind,2)<=maxvy);
    else
        ind = find(data(ind,1)>=0 & data(ind,1)<=maxvx & data(ind,2)>=0 & data(ind,2)<=maxvy);
    end
    data = data(ind,:);
    h=figure;
    Z = griddata(data(:,1),data(:,2),data(:,3),X,Y,'cubic');
    %Z = griddata2(data(:,1),data(:,2),data(:,3),X,Y,'nearest');
    %Z
    if (logs)
        contour(log(X), log(Y), log(Z));
    else
        contour(X,Y,real(log(Z)));
        %surf(X, Y, real(log(Z)));
    end

%     ti = get(gca,'TightInset');
%     set(gca,'Position',[ti(1) ti(2) 1-ti(3)-ti(1) 1-ti(4)-ti(2)]);
%     set(gca,'units','centimeters')
%     pos = get(gca,'Position');
%     ti = get(gca,'TightInset');
% 
%     set(gcf, 'PaperUnits','centimeters');
%     set(gcf, 'PaperSize', [pos(3)+ti(1)+ti(3) pos(4)+ti(2)+ti(4)]);
%     set(gcf, 'PaperPositionMode', 'manual');
%     set(gcf, 'PaperPosition',[0 0 pos(3)+ti(1)+ti(3) pos(4)+ti(2)+ti(4)]);
    saveas(h,outname);
end

