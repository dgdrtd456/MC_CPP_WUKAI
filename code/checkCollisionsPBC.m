    function [check, drmag2] = checkCollisionsPBC(position,npoint_coord,coord,rTrial,iMove,nPart,pbc_length,dis,ball_r)
    
    check = true;
    
    % check PBC and get the coordinate of suggested particle
    position=PBC3D(position,rTrial,pbc_length);
    point_coord=coord+position;
    point_ci = point_coord(1,:)+1/8*(point_coord(2,:)-point_coord(1,:));
    point_di = point_coord(1,:)+7/8*(point_coord(2,:)-point_coord(1,:));
    ball_centeri=point_coord(1,:);
    for i=1:nPart
       % Compare only to particle that are not the one being moved
       if (i ~= iMove) 
           % get the coordinate of both end of the cylinder
           point_c = npoint_coord(i,1:3)+1/8*(npoint_coord(i,4:6)-npoint_coord(i,1:3));
           point_d = npoint_coord(i,1:3)+7/8*(npoint_coord(i,4:6)-npoint_coord(i,1:3));
           ball_center = npoint_coord(i,1:3);
           % Get the distance between particle i and the suggested
           drmag2=DistBetween2Segment(point_c, point_d, point_ci, point_di);
           % Get the distance between particle i and the suggested ball
           dis1=point_to_line_segment_distance(ball_centeri,point_c,point_d);
           % Get the distance between particle suggested and the i ball
           dis2=point_to_line_segment_distance(ball_center, point_ci, point_di);
           % Get the distance between ball suggested and the i ball
           dis3=norm(ball_center-ball_centeri);
           if (drmag2 < dis || dis3<2*ball_r || dis2<ball_r+dis/2 || dis1<ball_r+dis/2)
               % The particles collide, no point in checking any further
               check=false;
               break;
           end
       end
    end
    
    end