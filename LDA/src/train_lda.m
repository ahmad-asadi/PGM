function train_lda()

%initializations
global dataset ;
global vocab ;

dataset = load('../dataset/ap/feature_vectors.mat' , 'dataset');
dataset = dataset.dataset;

epochCount = 100 ;
n = size(dataset, 1);
l = size(dataset, 2) - 1;
k = 10 ;%   topic count

dataset = dataset(:,1:l);

fprintf('number of documents       =  %d\n', n);
fprintf('number of words           =  %d\n', l);
fprintf('number of latent classes  =  %d\n', k);
fprintf('number of iterations      =  %d\n', epochCount);
fprintf('initialization of parameters\n');


beta = rand(1);
alpha = rand(1);

phi = zeros(k , l);
theta = zeros(n,k);


% Gibbs sampling algorithm

z = ceil(rand(n , l)*10) ;

for iter = 1 : epochCount
    for d_idx = 1 : n
        counter = 0 ;
        for i = 1 : l
            if(dataset(d_idx, i) ==0)
                continue;
            end
            counter = counter + 1 ;
            fprintf('%d:%d/%d,%d/%d', iter, d_idx, n, counter , sum(dataset(d_idx, :) & 1));
            pz_conditional = zeros(k,1);
            for j = 1 : k
                fprintf('*%d') ;
                w_ij = sum(1-((z(d_idx, :) - (ones(1,l) * j))&1));
                tmp = ones(n,l) * j ;
                tmp(:,i) = 0 ;
                tmp = (z - tmp) & 1 ;
                w_ijdot = sum(sum((1-tmp))) ;
                if(z(d_idx , i) == j)
                    tmp = 1 ;
                    w_ij = w_ij -1 ;
                else
                    tmp = 0 ;
                end                
                pz_conditional(j) = (w_ij + beta) / ( w_ijdot + l * beta);
                pz_conditional(j) = pz_conditional(j) * ((sum(dataset(d_idx,:)) - (tmp * 1) + alpha)/(sum(dataset(d_idx,:)&1) - 1 + k * alpha));
            end
            fprintf('\n') ;
            [~,z(d_idx , i)] = max(pz_conditional) ;
        end
    end

end    
    

    n_d = zeros(k,n) ;
    n_w = zeros(k,l) ;
    for t_idx = 1 :k
        for d_idx = 1 : n
            d_topics = (dataset(d_idx,:) & z(d_idx,:) ) .* z(d_idx,:);
            n_d(t_idx , d_idx) = sum(1 - ((d_topics - (ones(1 , l) * t_idx)) & 1));       
        end
        
        for w_idx = 1 : l
            w_topics = (dataset(:,w_idx) & z(:,w_idx) ) .* z(:,w_idx) ;
            n_w(t_idx , w_idx) = sum(1 - ((w_topics - (ones(n , 1) * t_idx)) & 1));       
        end
    end


    for j = 1 : k
        for w = 1 : l
            phi(j,w) = (n_w(j , w) + beta) / ( sum(n_w(j,:)) + l * beta);
        end
        
        for d = 1 : n
            theta(j,d) = (n_d(j,d) + alpha) / (sum(n_d(:,d)) + n * alpha) ;
        end
    end
    