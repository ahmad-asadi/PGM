function z = generate_samples_from_conditional_distribution(pmf)
    r = rand(1);
    stemp = 0 ;
    z = -1 ;
    for temp = 1 : size(pmf , 2) + 1
        if(r <= stemp)
            z = temp - 1 ;
            break;
        else
            stemp = stemp + pmf(temp) ;
        end
    end
        
