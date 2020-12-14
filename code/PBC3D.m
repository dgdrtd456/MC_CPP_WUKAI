    function vec = PBC3D(vec,translation,L)
    
    
    % Vector should be in the range 0 -> L in all dimensions
    % Therefore, we need to apply the following changes if it's not in this range: 
    
    vec = vec+translation;
    [n_particle,dimention]=size(vec);
    for i=1:n_particle
    for dim=1:3
        if (vec(i,dim) > L)
            vec(i,dim) = vec(i,dim)-L;
        elseif (vec(i,dim) < 0)
            vec(i,dim) = vec(i,dim)+L;
        end
    end
    end
    