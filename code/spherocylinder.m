function [X,Y,Z]=spherocylinder(pos, vec, totalLength, AR, color_id, ball_r, ball_center,pbc_length)
%% preliminary
points = 80;        % If needed, increase points for better resolution
vec = vec/norm(vec);
D = (totalLength/AR);
radius = D/2;
bottom = -(AR-1)/2*D;
top = (AR-1)/2*D;
%% Generate cylinder with center at origin
[xcyl,ycyl,zcyl]=cylinder(radius,points);
zcyl(1,:) = bottom;
zcyl(2,:) = top;
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
%% Combine data for spherocylinder oriented along z-direction
X = [xbot; xcyl; xtop];
Y = [ybot; ycyl; ytop];
Z = [zbot; zcyl; ztop];
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
%% Generate sphere for steric effect
xsteric = x*ball_r+ball_center(1);
ysteric = y*ball_r+ball_center(2);
zsteric = z*ball_r+ball_center(3);
XRot = [XRot;xsteric];
YRot = [YRot;ysteric];
ZRot = [ZRot;zsteric];
%% Plot spherocylinder 
drawnow
if color_id==1
    h=surf(XRot, YRot, ZRot, 'EdgeColor','none',...
   'LineStyle','none','FaceColor','w');
else
    h=surf(XRot, YRot, ZRot, 'EdgeColor','none',...
   'LineStyle','none','FaceColor','w');
end
%light('Position',[-1 0 1])     % add a light
grid off
box on
%hold on
%axis equal;
xlim([-4 pbc_length+4])
ylim([-4 pbc_length+4])
zlim([-4 pbc_length+4])


%colormap(jet);
end