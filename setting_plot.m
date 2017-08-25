        fontsize_val =  12;             % figure font size
     figure_marksize =  2.5;            % marker size
       gca_linewidth =  1;              % line width
        hcb_location = 'southoutside';  % colorbar location
            textname = 'Qs';            % text label
            
                 inx =  0.1;            % interpolate for image
         tickx_space =  5;              % tick interval along X axis
                 iny =  0.1;            % interpolate for image
         ticky_space =  2;              % tick interval along Y axis
                 inz =  0.1;            % interpolate for image
         tickz_space =  2;              % tick interval along Z axis  

% data aspect ratio   
    DataAspectRatioX = [1 1 1]; 
    DataAspectRatioY = [1 1 1];
    DataAspectRatioZ = [1 1 1];

% figure size
         FigureSizeX = [2,2,11 7];                  % for  YZ plane
           positionX = [0.15 0.2 0.750 0.68];       % for  YZ plane
           
         FigureSizeY = [2,2,20,9];                  % for  XZ plane
           positionY = [0.085 0.25 0.8 0.7];        % for  XZ plane
           
         FigureSizeZ = [2,2,16,7];                  % for  XY plane
           positionZ = [0.075 0.2 0.85 0.68];       % for  XY plane
% colormap            
            ColorJet = colormap('jet');
           ColorNJet = flipud(ColorJet);  %ColorNJet=flipud(ColorJet);%reverse the jet clabel
% caxis range            
      YZ_plane_caxis = [1.9,3.2]; %  i use it in CrossYZ_plane.m
      XZ_plane_caxis = [1.9,3.2]; %  i don't use it in CrossXZ_plane.m
      XY_plane_caxis = [80 350];  %  i don't use it in CrossXY_plane.m