function r = drchrnd(a,n)
p = length(a);
if(size(a,1) == 1)
    r = gamrnd(repmat(a,n,1),1,n,p);
    r = r ./ repmat(sum(r,2),1,p);
else
    r = gamrnd(repmat(a,1,n),1,p,n);
    r = r ./ repmat(sum(r,2),1,n);
end
