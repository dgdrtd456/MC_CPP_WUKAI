function newcoor=spherocylinder_rotate(angle, angle_dis, coor)

%% ��һ��spherocylinder������б
rotax=angle(1)+angle_dis(1);    %��X����ת�ĽǶ�
rotay=angle(2)+angle_dis(2);    % ��Z����ת�ĽǶ�
rotaz=angle(3)+angle_dis(3);    % ��Y����ת�ĽǶ�
% rotamatrix	����ϵ��ת����	
rotamatrix=[cosd(rotaz)*cosd(rotay),sind(rotaz),-cosd(rotaz)*sind(rotay);...
    -sind(rotaz)*cosd(rotay)*cosd(rotax)+sind(rotay)*sind(rotax),...
    cosd(rotaz)*cosd(rotax),...
    sind(rotaz)*sind(rotay)*cosd(rotax)+cosd(rotay)*sind(rotax);...
    sind(rotaz)*cosd(rotay)*sind(rotax)+sind(rotay)*cosd(rotax),...
    -cosd(rotaz)*sind(rotax),...
    -sind(rotaz)*sind(rotay)*sind(rotax)+cosd(rotay)*cosd(rotax)];
%% ����spherocylinder���������
%coor = [-3 0 0;3 0 0; 0 0 1];%��ʼ��A��B��C�����������
%coor = [-3 0 0; 0 0 1];%��ʼ��A��B��C�����������
%figure
%hold on
%subplot(2,1,1)
%plot3(coor(:,1),coor(:,2),coor(:,3))
%axis equal
%xlabel('X'),ylabel('Y'),zlabel('Z')
% ���ݽ��о���任
newcoor = coor*rotamatrix;
%subplot(2,1,2)
%plot3(newcoor(:,1),newcoor(:,2),newcoor(:,3))
%axis equal
%xlabel('X'),ylabel('Y'),zlabel('Z')
%hold off