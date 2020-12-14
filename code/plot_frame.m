clear all
clc

tic
n_particle=130;
length_width=4;
width=2;
ball_r=0;
total_length=8;
density=0.001;
[~,pbc_length] = Close_Packed (n_particle,density,length_width,width,ball_r);
%pbc_length=25;
npoint_coord=textread('C:\sunswork\纤维化\纤维化\大体系\130\example\test.txt');
conformational_state=textread('C:\sunswork\纤维化\纤维化\大体系\130\example\conformation.txt');

n_step=1*10^6/50;
for i=n_step:n_step
    count=0;
    for j=1:n_particle
 
        point_coord=(reshape((npoint_coord(j+(i-1)*(n_particle),:)),[3,3]))';        
    
        center=(point_coord(2,:)+point_coord(1,:))/2;
        vec_axi=point_coord(2,:)-point_coord(1,:);
        %output
        
        [X,Y,Z]=spherocylinder(center, vec_axi, total_length, length_width, conformational_state(j+(i-1)*(n_particle)),ball_r,point_coord(1,:),pbc_length);
        hold on
        [X,Y,Z]=spherocylinder_1(center, vec_axi, total_length, length_width, conformational_state(j+(i-1)*(n_particle)),ball_r,point_coord(3,:),pbc_length);
        count=count+1;
        
    end
    light('Position',[-1 0 1])     % add a light
    hold off
end
toc