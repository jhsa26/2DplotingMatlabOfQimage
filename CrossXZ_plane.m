function CrossXZ_plane(X,Y,Z,VEL,DWS,DWSlim)
global x y z plot_event_flag         % event loction
global startyplane  endyplane
global lx  rx  uz dz
format short
% setting marker size, line width
setting_plot;

nx=length(X);ny=length(Y);nz=length(Z);

crossh  = zeros(nz-2,nx-2);
dwsh    = zeros(nz-2,nx-2);
[x1,z1] = meshgrid(X(2:nx-1),Z(2:nz-1));
[xi,zi] = meshgrid(lx:inx:rx, dz:iny:uz);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(1)                   %('Renderer','painters');
set(gcf,'Unit','centimeter','Position',FigureSizeY)
set(gcf,'PaperPositionMode','auto')
set(gca,'position',positionY);
colormap(ColorNJet);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for j=1+startyplane:1+endyplane                                                  % Draw XZ Plane
    disp(['plotting: Y= ' num2str(Y(j))  'km' ])
    outfilename=['Output/' 'Y' num2str(Y(j)) 'km' '_' 'Q' '_'  'dws' '.txt'];
    fid_out=fopen(outfilename,'w');
    for i=2:nx-1
        for k=2:nz-1
            crossh(k-1,i-1)=VEL(j,i,k);
            dwsh(k-1,i-1)=DWS(j,i,k);
        end
    end
    fprintf(fid_out,'%6.3f  %6.3f   \n',size( crossh,2),size( crossh,1));
    for i=1:size( crossh,2)
        for k=1:size( crossh,1)
            fprintf(fid_out,'%6.3f  %6.3f   %6.3f   %6.3f \n',x1(i),z1(k), crossh(k,i), dwsh(k,i));
        end
    end
    fclose(fid_out);
    
    cross_inter = interp2(x1,z1,crossh,xi,zi,'linear');
    dws_inter   = interp2(x1,z1,dwsh,xi,zi,'linear');

    %     for ii=1:m1
    %         for jj=1:n1
    %             if ( dws_inter(ii,jj)<=DWSlim)
    %                cross_inter(ii,jj)=NaN;
    %             end
    %         end
    %     end
    
    pcolor(xi,zi,log10(cross_inter));
    
    %     alpha(log10(cross_inter))
    %     alphamap('vup')
    %    alpha(dws_inter)
    shading flat;
    hcb=colorbar ;
    set(hcb,'location',hcb_location)
    %  get(hcb,'ytick')
    %  set(hcb,'yTick',log10(ticks_wanted));
    set(hcb,'xTickLabel',round(10.^get(hcb,'xtick')));
    % set(hcb,'YTick',[caxismin  (caxismin+caxismax)/2  caxismax])
    % y_formatstring='%5.4f';
    % ytick=get(hcb,'Ytick');
    % for iytick=1:length(ytick)
    %     yticklabel{iytick}=sprintf(y_formatstring,ytick(iytick));
    % end
    % set(hcb,'yticklabel', yticklabel);
    % set(get(h,'title'),'string','Qs','fontsize',fontsize_val,'fontweight','bold')
    % get(get(h,'title'))
    text(16,13.3,textname,'fontsize',fontsize_val,'fontweight','bold')
    % set(get(h,'title'),'string','dB')
    % set(get(h,'title'),'string','Qs','fontsize',figure_fontsize,'fontweight','bold')
    % get(get(h,'title'));
    set(gca,'YDIR','rev','fontsize',fontsize_val,'fontweight','bold')
    set(gca,'ytick',(dz:tickz_space:uz),'xtick',(lx:tickx_space:rx))
    title(['Qs Y=',num2str(Y(j)),' km'],'fontsize',fontsize_val,'fontweight','bold')
    xlabel('X(km)','fontsize',fontsize_val,'fontweight','bold');
    ylabel('Z(km)','fontsize',fontsize_val,'fontweight','bold');
    box on
    set(gca,'linewidth',gca_linewidth,'DataAspectRatio',DataAspectRatioY)
    axis([lx rx dz uz ])
    hold on
    % plot contour 
    %[C,h] = contour(xi,zi,log10(dws_inter),'k-');
    [C,h]=contour(xi,zi,log10(cross_inter),'k-');
    set(h,'ShowText','on','TextStep',get(h,'LevelStep')*2)
    %     h_text=clabel(C,h,'LabelSpacing',300,'fontsize',fontsize_val,'fontweight','bold');
    h_text=clabel(C,h,'fontsize',fontsize_val,'fontweight','bold');
    for kk=1:length(h_text)
        temp=round(10^get(h_text(kk),'userdata'));
        set(h_text(kk),'string',num2str(temp))
    end
    % plot event location
    if plot_event_flag == 1
        for i=1:length(y)
            %        plot(x(i),y(i),'.','markersize',8,'color','k');
            
            if j==1
                if ( (y(i))<=(Y(1)+Y(2))/2 && x(i)<=rx && x(i)>= lx && z(i)<=uz && z(i)>=dz)
                    plot(x(i),z(i),'o','markersize',figure_marksize,'MarkerEdgeColor','k', 'MarkerFaceColor','k');
                end
            elseif j==ny
                if ((y(i))>(Y(ny)+Y(ny))/2 && x(i)<=rx && x(i)>= lx && z(i)<=uz && z(i)>=dz)
                    plot(x(i),z(i),'o','markersize',figure_marksize,'MarkerEdgeColor','k', 'MarkerFaceColor','k');
                end
            else
                if ((y(i))>(Y(j)+Y(j-1))/2 &&(y(i))<=(Y(j)+Y(j+1))/2 && x(i)<=rx && x(i)>= lx && z(i)<=uz && z(i)>=dz)
                    
                    plot(x(i),z(i),'o','markersize',figure_marksize,'MarkerEdgeColor','k', 'MarkerFaceColor','k');
                    
                end
            end
        end
    end
    hold off
%     print(gcf,'-depsc2','-zbuffer','-r300',sprintf('Figs/%s_%d_%s.eps','Q_Y',Y(j),'km'));
    print(gcf,'-dtiff','-zbuffer','-r300',sprintf('Figs/%s_%d_%s.tif','Q_Y',Y(j),'km'));
end


