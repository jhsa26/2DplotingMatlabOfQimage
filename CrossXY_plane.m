function CrossXY_plane(X,Y,Z,VEL,DWS,DWSlim)
global x y z plot_event_flag  % event loction
global startzplane  endzplane
global lx ly rx ry
format short

% setting marker size, line width
setting_plot;

nx=length(X); ny=length(Y); nz=length(Z);

crossh = zeros(ny-2,nx-2);

dwsh   = zeros(ny-2,nx-2);

[x1,y1]=meshgrid(X(2:nx-1),Y(2:ny-1));

% plotting range
[xi,yi] = meshgrid(lx:inx:rx, ly:iny:ry);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(3);                                  %('Renderer','painters');
set(gcf,'Unit','centimeter','Position',FigureSizeZ)
set(gcf,'PaperPositionMode','auto')
set(gca,'position',positionZ)
colormap(ColorNJet)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for k=1+startzplane:endzplane + 1                           % Draw XY Plane
    disp(['plotting: Z= ' num2str(Z(k))  'km' ])
    outfilename=['Output/' 'Z' num2str(Z(k)) 'km' '_' 'Q' '_'  'dws' '.txt'];
    fid_out=fopen(outfilename,'w');
    for i=2 :nx-1
        for j=2:ny-1
            crossh(j-1,i-1)=VEL(j,i,k);
            dwsh(j-1,i-1)=DWS(j,i,k);
        end
    end
    fprintf(fid_out,'%6.3f  %6.3f   \n',size( crossh,2),size(crossh,1));
    for i=1:size( crossh,2)
        for j=1:size( crossh,1)
            fprintf(fid_out,'%6.3f  %6.3f   %6.3f   %6.3f \n',x1(i),y1(j), crossh(j,i), dwsh(j,i));
        end
    end
    fclose(fid_out);
    
    % interpolate Q from origin grid points
    cross_inter = interp2(x1,y1,crossh,xi,yi,'linear');
    dws_inter   = interp2(x1,y1,dwsh,xi,yi,'linear');
    % whether to clip using dws
    % dws_inter   = interp2(x1,y1,dwsh,xi,yi,'linear');
    %        for ii=1:m1
    %         for jj=1:n1
    %           if ( dws_inter(ii,jj)<=DWSlim)
    %                cross_inter(ii,jj)=NaN;
    %           end
    %         end
    %        end
    
    pcolor(xi,yi,cross_inter);       % note pcolor(x,y,z(y,x));
    shading flat;
    hcb=colorbar;
    % set saturate
    % alpha(dws_inter)
    % set(hcb,'yticklabel',round(10.^(get(hcb,ytick))))
    set(hcb,'location',hcb_location)
    set(hcb,'xTickLabel',round(get(hcb,'xtick')));
    text(16,-8,textname,'fontsize',fontsize_val,'fontweight','bold')
    % set(get(hcb,'title'),'string','Qs''fontsize',fontsize_val,'fontweight','bold')
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    title(['Qs Z=',num2str(Z(k)),' km'],'fontsize',fontsize_val,'fontweight','bold')
    xlabel('X(km)','fontsize',fontsize_val,'fontweight','bold')
    ylabel('Y(km)','fontsize',fontsize_val,'fontweight','bold')
    set(gca,'fontsize',fontsize_val,'fontweight','bold');
    set(hcb,'fontsize',fontsize_val,'fontweight','bold');
    % set(get(hcb,'title'),'string','Qs','fontsize',fontsize_val,'fontweight','bold')
    set(gca,'fontsize',fontsize_val,'fontweight','bold')
    set(gca,'ytick',(ly:ticky_space:ry),'xtick',(lx:tickx_space:rx))
    box on
    set(gca,'linewidth',gca_linewidth,'DataAspectRatio',DataAspectRatioZ)
    axis([lx rx ly ry])
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % need to change according to your
    
    % caxismin=min(min(cross_inter));
    % caxismax=max(max(cross_inter));
    % caxis([caxismin   caxismax]);
    % set(hcb,'YTick',[caxismin  (caxismax+caxismin )/2   caxismax]);
    % y_formatstring='%5.4f';
    % ytick=get(hcb,'Ytick');
    %
    %   for iytick=1:length(ytick)
    %       yticklabel{iytick}=sprintf(y_formatstring,ytick(iytick));
    %   end
    % set(hcb,'Yticklabel',yticklabel);
    
    hold on
    % plot contour 
    [C,h]=contour(xi,yi,cross_inter,'k-');
    set(h,'ShowText','on','TextStep',get(h,'LevelStep')*2)
%     h_text=clabel(C,h,'LabelSpacing',300,'fontsize',fontsize_val,'fontweight','bold');
    h_text=clabel(C,h,'fontsize',fontsize_val,'fontweight','bold');
    
    for kk=1:length(h_text)
        
        temp=round(get(h_text(kk),'userdata'));
        
        set(h_text(kk),'string',num2str(temp))
        
        % set(h_text(kk),'string',sprintf('%4.0f',get(h_text(kk),'userdata')))
    end
    % plot event location
    if plot_event_flag==1
        for i=1:length(z)
            %         plot(x(i),y(i),'.','markersize',8,'color','k');
            
            if k==1
                if ( (z(i))<=(Z(1)+Z(2))/2 && y(i)<=ry && y(i)>= ly && x(i)<=rx && z(i)>=lx)
                    plot(x(i),y(i),'o','markersize',figure_marksize,'MarkerEdgeColor','k', 'MarkerFaceColor','k');
                end
            elseif k==nz
                if ((z(i))>(Z(nz)+Z(nz-1))/2 && y(i)<=ry && y(i)>= ly && x(i)<=rx && z(i)>=lx)
                    plot(x(i),y(i),'o','markersize',figure_marksize,'MarkerEdgeColor','k', 'MarkerFaceColor','k');
                end
            else
                if ((z(i))>(Z(k)+Z(k-1))/2 && (z(i))<=(Z(k)+Z(k+1))/2 && y(i)<=ry && y(i)>= ly && x(i)<=rx && z(i)>=lx)
                    plot(x(i),y(i),'o','markersize',figure_marksize,'MarkerEdgeColor','k', 'MarkerFaceColor','k');
                end
            end
        end
    end
    hold off
    %print(gcf,'-depsc2','-zbuffer','-r300',sprintf('Figs/%s_%d_%s.eps','Q_Y',Z(k),'km'));
    print(gcf,'-zbuffer','-dtiff','-r300',sprintf('Figs/%s_%d_%s.tif','Q_Z',Z(k),'km'));
end


