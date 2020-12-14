function [deltaE_0,deltaE_1] = EnergyChange2(position,npoint_coord,j,coord,rTrial,nPart,pbc_length,interaction_aa,interaction_ab,interaction_bb,conformational_state,width,part)

    % check PBC and get the coordinate of suggested particle
    position=PBC3D(position,rTrial,pbc_length);
    point_coord=coord+position;
    point_ci = point_coord(1,:)+1/8*(point_coord(2,:)-point_coord(1,:));
    point_di = point_coord(1,:)+7/8*(point_coord(2,:)-point_coord(1,:));
    point_fi = point_coord(1,:)+1/5*(point_coord(2,:)-point_coord(1,:));
    point_gi = point_coord(1,:)+4/5*(point_coord(2,:)-point_coord(1,:));
    point_centeri=point_coord(1,:)+1/2*(point_coord(2,:)-point_coord(1,:));
    point_ei=point_coord(3,:);
    
    
    
    %% calculate 4 kinds of energy£º
     % 1.interaction of type_a and type_a 
     % 2.interaction of type_a and type_b %caution£ºtype b beta sheet
     % formation Lp=5/6L
     % 3.interaction of type_a and type_b
     % 4.conformational change energy
     
        deltaE_0 = 0;
        deltaE_1 = 0;
    
        
        % Loop over all particles and calculate interaction with particle
        % 'part'.
        for otherPart = 1:nPart
            
            % Make sure to skip particle 'part' so that we don't calculate self
            % interaction
            if (otherPart == part)
                continue
            end
           % get the type of the other particle
           type_op= conformational_state(otherPart);
           % get the coordinate of the other particle
           point_c = npoint_coord(otherPart,1:3)+1/8*(npoint_coord(otherPart,4:6)-npoint_coord(otherPart,1:3));
           point_d = npoint_coord(otherPart,1:3)+7/8*(npoint_coord(otherPart,4:6)-npoint_coord(otherPart,1:3));
           point_f = npoint_coord(otherPart,1:3)+1/5*(npoint_coord(otherPart,4:6)-npoint_coord(otherPart,1:3));
           point_g = npoint_coord(otherPart,1:3)+4/5*(npoint_coord(otherPart,4:6)-npoint_coord(otherPart,1:3));           
           point_center = npoint_coord(otherPart,1:3)+1/2*(npoint_coord(otherPart,4:6)-npoint_coord(otherPart,1:3));
           point_e =  npoint_coord(otherPart,7:9);
           
           if type_op==0 %calculate type 1 and type 2
               
               % Calculate the potential energy of type 1
               % Calculate particle-particle distance for the new configurations
               drNew = point_c - point_ci;            
               % Get the distance squared
               dr2_New = norm(drNew);
               if dr2_New<1.3*width % 1.5 times of spherocylinder width
                   eNew0 = -interaction_aa*((width/dr2_New)^6);
               else
                   eNew0=0;
               end
               
               % Calculate the potential energy of type 2 (point: other particle; line segment: particle)
               dis_type2=point_to_line_segment_distance(point_c,point_fi,point_gi);
               angle_face=acos(dot(point_centeri-point_c, point_centeri-point_ei) / (norm(point_centeri-point_c) * norm(point_centeri-point_ei)));
               if dis_type2<1.3*width && angle_face<=pi/2% 1.5 times of spherocylinder width     atan(2.5/0.5)
                   eNew1 = -interaction_ab;
               else
                   eNew1=0;
               end
               
               deltaE_0 = deltaE_0 + eNew0 ;
               deltaE_1 = deltaE_1 + eNew1 ;
           else %calculate type 2 and type 3
            
               % Calculate the potential energy of type 2 (point: particle; line segment: other particle )
               % Calculate particle-particle distance for the new configurations
               angle_face=acos(dot(point_center-point_e,  point_center-point_ci) / (norm(point_center-point_e) * norm( point_center-point_ci)));
               dis_type2=point_to_line_segment_distance(point_ci,point_f,point_g);
               if dis_type2<1.3*width  && angle_face<=pi/2% 1.5 times of spherocylinder width;180 opening angle       2.5/0.5
                   eNew0 = -interaction_ab;
               else
                   eNew0=0;
               end
               
               % Calculate the potential energy of type 3
               %dis_type2=point_to_line_segment_distance(point_c,point_ci,point_di);
               % check face each other or not
                   angle_face=acos(dot(point_centeri-point_center, point_centeri-point_ei) / (norm(point_centeri-point_center) * norm(point_centeri-point_ei)));
                   angle_face1=acos(dot(point_center-point_e, point_center-point_centeri) / (norm(point_center-point_e) * norm(point_center-point_centeri)));
                   center_dis=norm(point_center-point_centeri);
                   angle_vec=acos(dot(point_d-point_c, point_di-point_ci) / (norm(point_d-point_c) * norm(point_di-point_ci)));
                   dis_type3=DistBetween2Segment(point_f,point_g,point_fi,point_gi);
               if dis_type3<1.3*width && angle_face<=pi/2 && center_dis<2.5*width && angle_face1<=pi/2  % 1.5 times of spherocylinder width ;180 opening angle
                   eNew1 = -interaction_bb*cos(angle_vec)*cos(angle_vec)-interaction_bb*(width/center_dis);
               else
                   eNew1=0;
               end
               
               
               deltaE_0 = deltaE_0 + eNew0 ;
               deltaE_1 = deltaE_1 + eNew1 ;
           end
    
        end

    end