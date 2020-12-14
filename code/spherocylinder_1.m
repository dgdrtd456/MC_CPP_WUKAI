function [X,Y,Z]=spherocylinder_1(pos, vec, totalLength, AR, color_id, ball_r, vec_center,pbc_length)
%steric ball locate at bottom!
%clc
%clear all
%pos=[5 5 5]; vec=[1 0 0]; totalLength=8; AR=4; color_id=1; ball_r=1;pbc_length=15;vec_center=[5 5 6];
%% preliminary
points = 80;        % If needed, increase points for better resolution
vec = vec/norm(vec);
D = (totalLength/AR);
radius = D/2+0.0001;
ball_r=ball_r+0.07;
bottom = -(AR-1)/2*D;
top = (AR-1)/2*D;
%% Generate cylinder with center at origin
[xcyl,ycyl,zcyl]=cylinder(radius,points);
if color_id==0
    zcyl(1,:) = bottom;
    zcyl(2,:) = -2;
else
    zcyl(1,:) = bottom+1;
    zcyl(2,:) = top-1;    
end
%% Generate points for sphere
[x,y,z] = sphere(points);
pdist = points/2+1;
% split sphere into top and bottom hemispheres
xtop = x(pdist:end,:)*radius;
ytop = y(pdist:end,:)*radius;
ztop = z(pdist:end,:)*radius+top;
xbot = x(1:pdist,:)*radius;
ybot = y(1:pdist,:)*radius;
zbot = z(1:pdist,:)*radius+bottom;
%zbot=z(1:pdist,:)*radius;
%% Generate sphere for steric effect
%xsteric = x*ball_r;
%ysteric = y*ball_r;
%zsteric = z*ball_r-4;
%% Combine data for spherocylinder oriented along z-direction
if color_id==0
    X = [xbot; xcyl];
    Y = [ybot; ycyl];
    Z = [zbot; zcyl];
else
    X = xcyl;
    Y = ycyl;
    Z = zcyl;   
end
%% Rotate spherocylinder
zvec = [0 0 1];
rotaxis = cross(zvec, vec);
rotaxis = rotaxis/norm(rotaxis);
cosTheta = dot(vec,zvec)/(norm(vec)*norm(zvec));
theta = acosd(cosTheta);
sinTheta = sind(theta);
oneMinusCos = 1-cosTheta;
Rmatrix = [cosTheta+rotaxis(1)^2*oneMinusCos ...
    rotaxis(1)*rotaxis(2)*oneMinusCos-rotaxis(3)*sinTheta ...
    rotaxis(1)*rotaxis(3)*oneMinusCos+rotaxis(2)*sinTheta;...
    rotaxis(2)*rotaxis(1)*oneMinusCos+rotaxis(3)*sinTheta ...
    cosTheta+rotaxis(2)^2*oneMinusCos                     ...
    rotaxis(2)*rotaxis(3)*oneMinusCos-rotaxis(1)*sinTheta;...
    rotaxis(3)*rotaxis(1)*oneMinusCos-rotaxis(2)*sinTheta ...
    rotaxis(3)*rotaxis(2)*oneMinusCos+rotaxis(1)*sinTheta ...
    cosTheta+rotaxis(3)^2*oneMinusCos];
XRot = Rmatrix(1,1)*X+Rmatrix(1,2)*Y+Rmatrix(1,3)*Z+pos(1);
YRot = Rmatrix(2,1)*X+Rmatrix(2,2)*Y+Rmatrix(2,3)*Z+pos(2);
ZRot = Rmatrix(3,1)*X+Rmatrix(3,2)*Y+Rmatrix(3,3)*Z+pos(3);
if color_id==1
  XRot_p=[]; YRot_p=[]; ZRot_p=[];
  for i=1:points+1
      vec_plot=vec_center-pos;
      vec_i=[XRot(1,i),YRot(1,i),ZRot(1,i)]-pos;
      angle_face1=acos(dot(vec_plot, vec_i) / (norm(vec_plot) * norm(vec_i)));
      if angle_face1<=pi/2
          test_x=[XRot(1,i);XRot(2,i)];
          test_y=[YRot(1,i);YRot(2,i)];
          test_z=[ZRot(1,i);ZRot(2,i)];
          XRot_p=[XRot_p,test_x]; YRot_p=[YRot_p,test_y]; ZRot_p=[ZRot_p,test_z];
      end
  end
end
%% Plot spherocylinder 
drawnow
if color_id==1
    h=surf(XRot_p, YRot_p, ZRot_p, 'EdgeColor','none',...
   'LineStyle','none','FaceColor','b');
else
    h=surf(XRot, YRot, ZRot, 'EdgeColor','none',...
   'LineStyle','none','FaceColor','r');
end
%light('Position',[-1 0 1])     % add a light
grid off
box on

%hh=figure;
%ax = axes('Parent',hh);                        
%ax.YAxis.Visible = 'off'; 

%hold on
%axis equal;
xlim([-4 pbc_length+4])
ylim([-4 pbc_length+4])
zlim([-4 pbc_length+4])
%colormap(jet);
end