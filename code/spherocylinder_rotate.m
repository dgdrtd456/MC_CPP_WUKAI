function newcoor=spherocylinder_rotate(angle, angle_dis, coor)

%% 将一个spherocylinder进行倾斜
rotax=angle(1)+angle_dis(1);    %绕X轴旋转的角度
rotay=angle(2)+angle_dis(2);    % 绕Z轴旋转的角度
rotaz=angle(3)+angle_dis(3);    % 绕Y轴旋转的角度
% rotamatrix	坐标系旋转矩阵	
rotamatrix=[cosd(rotaz)*cosd(rotay),sind(rotaz),-cosd(rotaz)*sind(rotay);...
    -sind(rotaz)*cosd(rotay)*cosd(rotax)+sind(rotay)*sind(rotax),...
    cosd(rotaz)*cosd(rotax),...
    sind(rotaz)*sind(rotay)*cosd(rotax)+cosd(rotay)*sind(rotax);...
    sind(rotaz)*cosd(rotay)*sind(rotax)+sind(rotay)*cosd(rotax),...
    -cosd(rotaz)*sind(rotax),...
    -sind(rotaz)*sind(rotay)*sind(rotax)+cosd(rotay)*cosd(rotax)];
%% 生成spherocylinder的坐标矩阵
%coor = [-3 0 0;3 0 0; 0 0 1];%初始化A、B、C三个点的坐标
%coor = [-3 0 0; 0 0 1];%初始化A、B、C三个点的坐标
%figure
%hold on
%subplot(2,1,1)
%plot3(coor(:,1),coor(:,2),coor(:,3))
%axis equal
%xlabel('X'),ylabel('Y'),zlabel('Z')
% 数据进行矩阵变换
newcoor = coor*rotamatrix;
%subplot(2,1,2)
%plot3(newcoor(:,1),newcoor(:,2),newcoor(:,3))
%axis equal
%xlabel('X'),ylabel('Y'),zlabel('Z')
%hold off