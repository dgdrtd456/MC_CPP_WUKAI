    function [position,pbc_length] = Close_Packed (nPart,density,length_width,width,ball_r)
    
    % Make sure the size of the cell is suitable 
    pbc_length=nthroot((nPart*pi*(11/12*width^3+2/3*ball_r^3)/density),3);%density is volume fraction，为什么这里是三次方根
    Lx=(length_width+0)*width;
    Ly=(length_width+0)*width;
    Lz=(length_width+0)*width;
    if Lx*Ly*Lz*nPart > pbc_length^3
        % Display an error message
        disp('The density is too high. You need to adjust the size of the cell');
        position = zeros(nPart,3);
        pbc_length = 0.0;
        return 
    end
    
    % Calculate the center of cells
    nn=fix(pbc_length/Lx);
    particle_index_1=randi(nn,2*nPart,3);
    particle_index_1=unique(particle_index_1,'rows','stable');
    particle_index_2=particle_index_1(1:nPart,:);
    position=(particle_index_2-1)*Lx+0.5*Lx;
    
    end
    %这个函数的返回值是一个行向量[position, pbc_length]，我在C++里面用什么来表示呢？
