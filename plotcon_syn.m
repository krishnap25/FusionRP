function [h] = plotcon_syn(s, a, b, logs)
%% plot 2-D contours from pdf
%% (a,b)  -> params of beta distribution
%% logs = 1 -> log-scale. Use 0 as default.
    if isempty(logs)
        logs = false;
    end
    outname = sprintf('./plots_syn/%2g_%2g_%d.pdf', a, b, logs);
    maxvx=25;
    maxvy=25;
    [X,Y]=meshgrid(0:maxvx,0:maxvy);
    vx = maxvx; vy = maxvy;
    data = [];%zeros((maxvx+1) * (maxvy+1), 3);
    for i= 0:vx
        data = [data; [repmat(i, vy+1, 1) (0:vy)']];
    end
    n=size(data,1);
    ind = 1:n;
    if (logs)
        ind = find(data(ind,1)>=1 & data(ind,1)<=maxvx & data(ind,2)>=1 & data(ind,2)<=maxvy);
    else
        ind = find(data(ind,1)>=0 & data(ind,1)<=maxvx & data(ind,2)>=0 & data(ind,2)<=maxvy &...
            ~(data(ind,1) == 0 & data(ind, 2) == 0));
    end
    data = data(ind,:);
    for i = 1:size(data, 1)
       data(i, 3) = log_pdf(data(i, 1), data(i, 2), s, a, b); 
    end
    %data
    h=figure;
    Z = griddata(data(:,1),data(:,2),data(:,3),X,Y,'cubic');
    %Z
    v = [-2, -4, -6, -8, -10, -11.5]; %31, at_retweet_comment
    v = [-2.5, -4, -5.5, -7, -8.1, -9.18, -10.22, -11.2]; %21, at_retweet_comment
    if (logs)
        contour(log(X), log(Y), Z);
    else
        contour(X,Y,Z,v, 'ShowText', 'off');
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

