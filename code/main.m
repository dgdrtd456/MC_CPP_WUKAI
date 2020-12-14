 %%random walk (rotation+translation) of 2 spherocylinder + PBC + collision
clear all
clc

tic

%% initialize 
length_width=4;
width=2;
ball_r=0;
total_length=8;
n_particle=130;
density=0.01;
coord= [-4 0 0;4 0 0; 0 0 1]; % coordinate of the both end of the spherocylinder and the Normal coordinates
%position=[5 5 5;5 2.5 5]; % coordinate of center of the spherocylinder : used in PBC3D
%position=[0 0 0;0 0 2.5;0 0 5;0 0 7.5;0 2 0;0 2 2.5;0 2 5;0 2 7.5;10 10 10;-10 10 10;10 -10 10;10 10 -10;-10 -10 10;-10 10 -10;10 -10 -10;-10 -10 -10];
%position=[15 16 22;15 16 18;15 16 14;15 16 10;15 16 6;10 15 8;10 15 12;10 15 16;10 15 20;10 15 24]*1;
%position=position+[15 15 15]/2;
[position,pbc_length] = Close_Packed (n_particle,density,length_width,width,ball_r);
angle_t=zeros(n_particle,3); % initial angle

npoint_coord=zeros(n_particle,9);%each particle has 3 points to discribe it
conformational_state=zeros(n_particle,1);% 0 refer to coil state;1 refer to beta state
%conformational_state=[1 1]';
interaction_aa=8;
interaction_ab=9;
interaction_bb=30;
energy_penal=20;
energy_i=-0;
for i =1:n_particle
    npoint_coord(i,:)=reshape((coord+position(i,:))',[1,9]);
end

n_step=1*10^6; %2*10^3   2*60*10^3;

pbc_length=26;%to check whether collision or not, set pbc_length=1
maxDr=0.05;
trans=zeros(n_step,n_particle);

fid = fopen('test.txt','wt');
fid1 = fopen('check.txt','wt');
fid2 = fopen('conformation.txt','wt');
fid3 = fopen('conformation_trans.txt','wt');
fid4 = fopen('position.txt','wt+');
fid5 = fopen('angle_t.txt','wt+');
%% mc random walk of two particles
for i=1:n_step
    for j=1:n_particle
        % rotation
        angle_dis=5*(rand(3,1)-0.5)';%max displacement is 10 degree
        angle_test=angle_t(j,:);
        coord_t=spherocylinder_rotate(angle_t(j,:), angle_dis, coord);
        coord_0=spherocylinder_rotate(angle_t(j,:), [0 0 0], coord);
        % translation
        % max displacement is 0.5 
        translation= maxDr*(rand(3,1)-0.5)';
        % Because we're describing aggregation here, we're going to analyze the hard ball potential separately
        % Check that this move does not result in collisions
        [check, distance] = checkCollisionsPBC(position(j,:),npoint_coord,coord_t,translation,j,n_particle,pbc_length, width,ball_r);
          
        % Check that the trial move does not take the particle out side of
        % the box
          if (check)
              [deltaE_01,deltaE_11] = EnergyChange2(position(j,:),npoint_coord,j,coord_t,translation,n_particle,pbc_length,...
                  interaction_aa,interaction_ab,interaction_bb,conformational_state,width,j);
              deltaE_original = EnergyChange1(position(j,:),npoint_coord,j,coord_0,[0 0 0],n_particle,pbc_length,...
                  interaction_aa,interaction_ab,interaction_bb,conformational_state,width,j);
              
              if conformational_state(j)==1
                  deltaE_1=deltaE_11-deltaE_original;
                  deltaE_0=deltaE_01-deltaE_original-energy_penal;
              else
                  deltaE_1=deltaE_11-deltaE_original+energy_penal;
                  deltaE_0=deltaE_01-deltaE_original;
              end
              
              
              % Check energy difference
              if (rand <= exp(deltaE_0-deltaE_1))
                  
                  if (rand <= exp(-deltaE_1))
                      deltaE_test=deltaE_1;
                      trans(i,j)=1;
                      conformational_state(j)=1;
                  % Accept move - Then applying PBC
                      position(j,:)=PBC3D(position(j,:),translation,pbc_length); %accept translation 
                      %coord=coord_t;
                      point_coord=position(j,:)+coord_t;
                      angle_t(j,:)=angle_t(j,:)+angle_dis; %accept rotation
                      energy_i=energy_i+deltaE_test;
                      test_erro=0;
                  else
                      point_coord=position(j,:)+spherocylinder_rotate(angle_t(j,:), [0 0 0], coord);
                      deltaE_0=0;deltaE_1=0;
                      test_erro=1;
                  end
                  
                  

              else
                  
                  if (rand <= exp(-deltaE_0))
                      deltaE_test=deltaE_0;
                      trans(i,j)=0;
                      conformational_state(j)=0;
                  % Accept move - Then applying PBC
                      position(j,:)=PBC3D(position(j,:),translation,pbc_length); %accept translation 
                      %coord=coord_t;
                      point_coord=position(j,:)+coord_t;
                      angle_t(j,:)=angle_t(j,:)+angle_dis; %accept rotation
                      energy_i=energy_i+deltaE_test;
                      test_erro=2;
                  else
                      point_coord=position(j,:)+spherocylinder_rotate(angle_t(j,:), [0 0 0], coord);
                      deltaE_0=0;deltaE_1=0;
                      test_erro=3;
                  end
                  
                  

              end



          else
              point_coord=position(j,:)+spherocylinder_rotate(angle_t(j,:), [0 0 0], coord);
              deltaE_0=0;deltaE_1=0;
              test_erro=4;
          end

        npoint_coord(j,:)=reshape((point_coord)',[1,9]);        
    
        center=(point_coord(2,:)+point_coord(1,:))/2;
        vec_axi=point_coord(2,:)-point_coord(1,:);
        %output
        if rem(i,50)==0
            fprintf(fid,'%d %d %d %d %d %d %d %d %d\n',npoint_coord(j,:)');
            fprintf(fid1,'%d %d %d %d %d\n',check, deltaE_0, deltaE_1, energy_i,test_erro);
        end
        %[X,Y,Z]=spherocylinder(center, vec_axi, total_length, length_width, conformational_state(j),ball_r,point_coord(1,:),pbc_length);
        %hold on
        %[X,Y,Z]=spherocylinder_1(center, vec_axi, total_length, length_width, conformational_state(j+(i-1)*(n_particle)),ball_r,point_coord(3,:),pbc_length);
        
        
    end
    if rem(i,50)==0
        fprintf(fid2,'%d\n',conformational_state');
        fprintf(fid3,'%d\n',sum(conformational_state)/n_particle); 
		[m,n]=size(position);
		for j =1:1:m
			for k = 1:1:n
				if j==n
					if i==m
						fprintf(fid4,'%f',position(j,k));
						fprintf(fid5,'%f',angle_t(j,k)); 
					else
						fprintf(fid4,'%f\n',position(j,k));
						fprintf(fid5,'%f\n',angle_t(j,k));
					end
				else
					fprintf(fid4,'%f\t ',position(j,k));
					fprintf(fid5,'%f\t',angle_t(j,k));
				end
			end
		end
    end
    %light('Position',[-1 0 1])     % add a light
    %hold off
end
fclose(fid);
fclose(fid1);
fclose(fid2);
fclose(fid3);
fclose(fid4);
fclose(fid5);


toc