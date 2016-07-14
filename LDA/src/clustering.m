% clustering

[centers,U] = fcm(theta,k);

disp(centers) ;

[idx,C] = kmeans(theta,k);

disp(C) ;

diff1 = centers - C ;

diff_fk = sqrt(sum((diff1.^2).')) ;

disp(diff_fk);

[C,S] = subclust(theta,0.5) ;

diff2 = centers - C ;

diff_fS = sqrt(sum((diff2.^2).'));

disp(diff_fS) ;
