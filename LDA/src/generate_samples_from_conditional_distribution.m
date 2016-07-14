function z = generate_samples_from_conditional_distribution(pmf)
    if(sum(pmf) == 0)
        z = -1;
        return ;
    end
    if(sum(pmf) ~= 1)
        pmf = pmf ./ sum(pmf);
    end
    r = rand(1);
    stemp = 0 ;
    z = -1 ;
    n = size(pmf , 1);
    if n == 1
        n = size(pmf ,2) ;
    end
    for temp = 1 : n + 1
        if(r <= stemp)
            z = temp - 1 ;
            break;
        else
            stemp = stemp + pmf(temp) ;
        end
    end
     
    if(z == -1)
        disp('here!');
    end
