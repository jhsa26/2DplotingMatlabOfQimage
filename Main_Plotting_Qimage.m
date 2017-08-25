% This script is used to plot 2-D image for Q tomography.
% You can plot Q distribution image along X , Y and depth, respectively. 
% This script is used in Linux.
% Date:2015-02-03
%
% HuJing @ USTC
close all
clear all
clc
system('test -d Figs || mkdir Figs')
system('test -d Output || mkdir Output')
system('rm -rf Output/* Figs/*')
%%

global x y z plot_event_flag
global endxplane endyplane endzplane startxplane startyplane startzplane
global lx rx ly ry uz dz
% init value
give_init()
%============================ you can change parameters ==================
dwsfile = 'Input/DWS.P';
qvalfile = 'Input/Qp_model.dat';
evlocfile = 'Input/ev.reloc';
modfile = 'Input/MOD';
DWSlim = 100;

plot_flag_direction=2;                 % plot: 1  for YZ plane; 2 for ZX plane; 3 for XY plane; 6 for XY,YZ,XZ planes

if     plot_flag_direction==1           % plot X direction
    
    startxplane=3;endxplane=3;
    ly = -3  ; ry   = 6;                % Y axis range
    dz =  5  ; uz   = 11;               % Z axis range
    
elseif plot_flag_direction==2           % plot Y direction
    
    startyplane=6;endyplane=10;
    dz =  5  ; uz   = 11;               % Z axis range
    lx = -25 ; rx   = 15 ;              % X axis range
elseif plot_flag_direction==3           % plot Z direction
    
    startzplane=2;endzplane=3;
    lx = -25 ; rx   = 15 ;              % X axis range
    ly = -3  ; ry   = 6;                % Y axis range
elseif plot_flag_direction==6           % plot all directions
    
    startxplane=-1;endxplane=100;
    startyplane=-1;endyplane=100;
    startzplane=-1;endzplane=100;
    lx = -25 ; rx   = 15 ;              % X axis range
    ly = -3  ; ry   = 6;                % Y axis range
    dz =  5  ; uz   = 11;               % Z axis range
    
end
plot_event_flag = 1;  % project event location: 1 yes, 0 no

%=======================================================================



%============  don't change ===========================================
% read dws file extracted from file outputed from tomoDD_Q
dws=load(dwsfile);
% read the Q file outputed from tomoDD_Q
qval=load(qvalfile);
% read event formation
A=load(evlocfile);
% converte event location unit m to km
x=A(:,5)./1000;
y=A(:,6)./1000;
z=A(:,4);
% read MOD file
[fid]=fopen(modfile,'r');
tic
if fid ~=-1
    % read head
    i=1;
    data{i,1}=fgets(fid);
    while 1
        i=i+1;
        data{i,1} =fgetl(fid);
        % str=fgetl(fid);
        if ~ischar(data{i,1})
            disp('The process of reading file is completed')
            break;
        end
        %length(data{i,1})
        % fprintf('the number of line %d \n',i)
        if i<5
            disp(['X-1 Y-2 Z-3  ',num2str(i-1)])
            disp(str2num(data{i,1}))
        end
    end
else
    disp('ERROR:the file is not there,open fail')
    return;
end
X=str2num(data{2,1});Y=str2num(data{3,1});Z=str2num(data{4,1});
nx=length(X);ny=length(Y);nz=length(Z);
head=str2num(data{1,1});
if nx-head(1,2)>0.00001
    disp('ERROR:cheak the X nodes')
    return;
elseif ny-head(1,3)>0.00001
    disp('ERROR:cheak the Y nodes')
    return;
elseif  nz-head(1,4)>0.00001
    disp('ERROR:cheak Z the nodes')
    return;
end
%  control the end plane and range
if endyplane>ny-2 || startyplane<1
    startyplane=1;
    endyplane=ny-2;
end
if endzplane>nz-2||startzplane<1
    startzplane=1;
    endzplane=nz-2;
end
if endxplane>nx-2 || startxplane<1
    startxplane=1;
    endxplane=nx-2;
end
if lx<X(2) || rx>X(end-1)|| lx>rx
    lx=X(2);rx=X(end-1);
end
if ly<Y(2)||ry >Y(end-1) || ly>ry
    ly=Y(2);ry=Y(end-1);
end
if dz<Z(2)||uz>Z(end-1)||dz>uz
    dz=Z(2);uz=Z(end-1);
end

% get the velocity field and Q model
Qm  = zeros(ny,nx,nz);  DWS = zeros(ny,nx,nz);
VEL = zeros(ny,nx,nz);  vel = zeros(ny*nz,nx);
for i=5:length(data)-1
    vel(i-4,:)=str2num(data{i,1});
end
for k=1:nz
    for i=1:nx
        for j=1:ny
            Qm(j,i,k)  = qval((k-1)*ny+j,i); %the column reading is faster, and pcolor plotting is inverse
            DWS(j,i,k) = dws((k-1)*ny+j,i);
            VEL(j,i,k) = vel((k-1)*ny+j,i);
        end
    end
end
% plotting function
if     plot_flag_direction==1           % plot X direction
    
    CrossYZ_plane(X,Y,Z,Qm,DWS,DWSlim)
    
elseif plot_flag_direction==2           % plot Y direction
    
    CrossXZ_plane(X,Y,Z,Qm,DWS,DWSlim)
    
elseif plot_flag_direction==3           % plot Z direction
    
    CrossXY_plane(X,Y,Z,Qm,DWS,DWSlim)
    
elseif plot_flag_direction==6           % plot all directions
    CrossXY_plane(X,Y,Z,Qm,DWS,DWSlim)
    CrossYZ_plane(X,Y,Z,Qm,DWS,DWSlim)
    CrossXZ_plane(X,Y,Z,Qm,DWS,DWSlim)
end
%===end===for 2D image======================================================
