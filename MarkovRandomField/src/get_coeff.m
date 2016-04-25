function coeff = get_coeff(W,x,y)
coeff = -1 ;
max_i = size(W,1);
max_j = size(W,2);
for i = - 1 : 1
    for j = -1 : 1 
        if(is_in_bound(i,j,max_i, max_j,x,y))
           if(W(x + i, y + j) == W(x,y)) 
               coeff = coeff + 1 ;               
           else
               coeff = coeff - 1 ;
           end
        end
    end
end


function res = is_in_bound(i,j,max_i,max_j , x ,y)
res = i > -x && i < max_i - x && j > -y && j < max_j - y ;%&& i~= j && i ~= -j ; 