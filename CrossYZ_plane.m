function CrossYZ_plane(X,Y,Z,VEL,DWS,DWSlim)
global x y z plot_event_flag         % event loction
global startxplane  endxplane
global ly  ry   dz uz
format short
% setting marker size, line width
setting_plot;
nx=length(X);ny=length(Y);nz=length(Z);
crossh = zeros(nz-2,ny-2);
dwsh   = zeros(nz-2,ny-2);
[y1,z1]=meshgrid(Y(2:ny-1),Z(2:nz-1));
[yi,zi] = meshgrid(ly:iny:ry,dz:inz:uz);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(2);
set(gcf,'Unit','centimeter','Position',FigureSizeX)
set(gcf,'PaperPositionMode','auto')
set(gca,'position',positionX)
colormap(ColorNJet);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1+startxplane:1+endxplane                                  % Draw YZ Plane
    disp(['plotting: X= ' num2str(X(i))  'km' ])
    outfilename=['Output/' 'X' num2str(X(i)) 'km' '_' 'Q' '_'  'dws' '.txt'];
    fid_out=fopen(outfilename,'w');
    for j=2:ny-1
        for k=2:nz-1
            crossh(k-1,j-1)=VEL(j,i,k);
            dwsh(k-1,j-1)=DWS(j,i,k);
        end
    end
    fprintf(fid_out,'%6.3f  %6.3f   \n',size( crossh,2),size( crossh,1));
    for j=1:size( crossh,2)
        for k=1:size( crossh,1)
            fprintf(fid_out,'%6.3f  %6.3f   %6.3f   %6.3f \n',y1(j),z1(k), crossh(k,j), dwsh(k,j));
        end
    end
    fclose(fid_out);
    cross_inter = interp2(y1,z1,crossh,yi,zi,'linear');
    dws_inter   = interp2(y1,z1,dwsh,yi,zi,'linear');
    pcolor(yi,zi,log10(cross_inter));
    shading flat;
%     alpha(dws_inter)
    caxis(YZ_plane_caxis)

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    hcb=colorbar;
    set(hcb,'yTickLabel',round(10.^get(hcb,'ytick')));
    set(get(hcb,'title'),'string',textname,'fontsize',fontsize_val,'fontweight','bold')
    title(['Qs X=',num2str(X(i)),' km'],'fontsize',fontsize_val,'fontweight','bold');
    xlabel('Y(km)','fontsize',fontsize_val,'fontweight','bold');
    ylabel('Z(km)','fontsize',fontsize_val,'fontweight','bold');
    set(gca,'fontsize',fontsize_val,'YDIR','rev','fontweight','bold');
    set(hcb,'fontsize',fontsize_val,'fontweight','bold')
    box on
    set(gca,'linewidth',gca_linewidth,'DataAspectRatio',DataAspectRatioX)
    set(gca,'ytick',(dz:tickz_space:uz),'xtick',(ly:ticky_space:ry))
    axis([ly ry dz uz])
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    hold on
    % h_text=clabel(C,h,'LabelSpacing',300,'fontsize',fontsize_val,'fontweight','bold');
    % for kk=1:length(h_text)
    % set(h_text(kk),'string',sprintf('%4.0f',get(h_text(kk),'userdata')))
    % end
    [C,h]=contour(yi,zi,log10(cross_inter),'k-');
    set(h,'ShowText','on','TextStep',get(h,'LevelStep')*2)
    h_text=clabel(C,h,'fontsize',8,'fontweight','bold');
    for kk=1:length(h_text)
        temp=round(10^get(h_text(kk),'userdata'));
        set(h_text(kk),'string',num2str(temp))
    end
    if plot_event_flag   == 1
        for k=1:length(x)
            %         plot(y(k),z(k),'.','markersize',8,'color','k');
            
            if i==1
                if ((x(k))<=(X(1)+X(2))/2 && y(k)<=ry && y(k)>= ly && z(k)<=uz && z(k)>=dz)
                    plot(y(k),z(k),'o','markersize',figure_marksize,'MarkerEdgeColor','k', 'MarkerFaceColor','k');
                end
            elseif i==nx
                if ((x(k))>(X(nx)+X(nx-1))/2 && y(k)<=ry && y(k)>= ly && z(k)<=uz && z(k)>=dz)
                    plot(y(k),z(k),'o','markersize',figure_marksize,'MarkerEdgeColor','k', 'MarkerFaceColor','k');
                end
            else
                if ( (x(k))>(X(i)+X(i-1))/2 && (x(k))<=(X(i)+X(i+1))/2 && y(k)<=ry && y(k)>= ly && z(k)<=uz && z(k)>=dz)
                    plot(y(k),z(k),'o','markersize',figure_marksize,'MarkerEdgeColor','k', 'MarkerFaceColor','k');
                end
            end
        end
    end
    hold off
    %     print(gcf,'-depsc2','-zbuffer','-r300',sprintf('Figs/%s_%d_%s.eps','Q_Y',X(i),'km'));
    print(gcf,'-zbuffer','-dtiff','-r300',sprintf('Figs/%s_%d_%s.tif','Q_X',X(i),'km'));
end


