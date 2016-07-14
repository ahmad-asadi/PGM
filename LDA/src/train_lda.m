function [z , phi , theta, perplexity, test_perplexity] = train_lda(data, given_z , given_phi , given_theta)

figure;
title('perplexity');
%initializations
global dataset ;
global k ;

dataset = load('../dataset/ap/feature_vectors.mat' , 'dataset');
dataset = dataset.dataset;

epochCount = 60 ;
l = size(dataset, 2) - 1;
k = 5;%   topic count
pz_conditional = zeros(k,1) ;

dataset = dataset(:,1:l);
test_indices = randi(size(dataset,1) , floor(0.3 * size(dataset,1)) , 1) ;
test_set = dataset(test_indices, :) ;
dataset(test_indices,:) = zeros(size(test_indices,1), size(dataset,2)) ;
%dataset(all(dataset==0,2),:)=[];

n = size(dataset, 1);

fprintf('number of documents       =  %d\n', n);
fprintf('number of words           =  %d\n', l);
fprintf('number of latent classes  =  %d\n', k);
fprintf('number of iterations      =  %d\n', epochCount);
fprintf('initialization of parameters\n');


beta = 1; 
alpha = 0.03;

phi = zeros(k , l);
theta = zeros(k , n);

% Gibbs sampling algorithm
z = ceil(rand(n , l)*k) ;

if nargin > 0
    pdataset = dataset;
    dataset = data ;
    phi = given_phi ;
    theta = given_theta ;
    z = given_z ;
    epochCount = 1;
end

% for j = 1 : k
%     fprintf('\t*') ;
%     tmp = ones(n,l) * j ;
%     tmp = (z - tmp) & 1 ;
%     topic_counts(j) = sum(sum((1-tmp))) ;
% end
% topic_counts = repmat(topic_counts.' , 1 , l);

z = (dataset & z) .* z ;
n_w = zeros(k,l) ;
n_d = zeros(k,n) ;
   
disp('calculating n_w matrix') ;
tic
for i = 1 : l
    freq = dataset(:,i) ;
    temp = z(:,i) ;
    temp = (1-((repmat(temp.',k,1) - repmat((ones(1,k) .* (1:k)).',1,n)) & 1)) .* repmat(freq.',k,1) ;
    n_w(: , i) = sum(temp.');
end
toc
 
disp('calculating n_d matrix') ;
tic
for i = 1 : n
    temp = z(i,:) ;
    temp = 1-((repmat(temp,k,1) - repmat((ones(1,k) .* (1:k)).',1,l)) & 1 ) ;
    n_d(: , i) = sum(temp.');
end
toc


fprintf('\n');
perplexity = zeros(epochCount,1);
for iter = 1 : epochCount
    fprintf('iteration: %d\n', iter) ;
    tic

    
%     disp('iterating on documents...')
    for d_idx = 1 : n
        if sum(dataset(d_idx,:)) == 0
            continue;
        end
%         fprintf('iteration %d, document %d out of %d docs\n' , iter, d_idx, n);
        word_indices = (dataset(d_idx,:) & 1 ) .* (1:l) ;
        word_indices = word_indices(word_indices ~= 0) ;
       
        for i = word_indices
            for j = 1 : k
                nwji = n_w(j,i) ;
                snwji = sum(n_w(j,:)) ;
                ndji = n_d(j,d_idx) ;
                sndji = sum(n_d(:,d_idx)) - 1 ;
                if(z(d_idx, i) == j)
                    nwji = nwji - 1 ;
                    snwji = snwji - 1 ;
                    ndji = ndji - 1 ;
                end
                pz_conditional(j) = (nwji + beta) / (snwji + (l * beta)) ;
                pz_conditional(j) = pz_conditional(j) * (ndji + alpha)/(sndji + (k * alpha)) ;
            end
            
            old_topic = z(d_idx,i) ;
            if(old_topic == -1)
                disp('here');
            end
            n_d(old_topic, d_idx) = n_d(old_topic, d_idx) - 1 ;
            n_w(old_topic, i) = n_w(old_topic, i) - 1;
%             if(sum(pz_conditional) == 0)
%                 disp('here') ;
%             end
            z(d_idx,i) = generate_samples_from_conditional_distribution(pz_conditional);
            new_topic = z(d_idx,i) ;
            if(new_topic == -1)
                new_topic = old_topic;
                z(d_idx,i) = old_topic;
            end
            n_d(new_topic, d_idx) = n_d(new_topic, d_idx) + 1 ;
            n_w(new_topic, i) = n_w(new_topic, i) + 1;
        end
    end
    toc

    disp('updating phi and theta') ;
    for j = 1 : k
        for w = 1 : l
            phi(j,w) = (n_w(j , w) + beta) / ( sum(n_w(j,:)) + l * beta);
        end
        
        for d = 1 : n
            theta(j,d) = (n_d(j,d) + alpha) / (sum(n_d(:,d)) + k * alpha) ;
        end
    end
    
  
    
    
    disp('calculating perplexity') ;
    perplexity(iter) = calculate_perplexity(phi, theta, dataset) ;
    if(iter > 1)
        plot([iter-1,iter],[perplexity(iter-1) , perplexity(iter)], 'b') ;
        hold on;
        drawnow ;
    end
    fprintf('train_perplexity = %d\n' , perplexity(iter));
    

 
end
 
if nargin > 0
    dataset = pdataset;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%testing new documents

pz_conditional = zeros(k,1) ;
epochCount = 15;
dataset = test_set;
n = size(dataset, 1);
figure;

fprintf('number of test documents       =  %d\n', n);
fprintf('number of test words           =  %d\n', l);
fprintf('number of test latent classes  =  %d\n', k);
fprintf('number of test iterations      =  %d\n', epochCount);
fprintf('initialization of parameters\n');

% Gibbs sampling algorithm
z = ceil(rand(n , l)*k) ;
z = (dataset & z) .* z ;

   
disp('calculating test n_w matrix') ;
tic
for i = 1 : l
    freq = dataset(:,i) ;
    temp = z(:,i) ;
    temp = (1-((repmat(temp.',k,1) - repmat((ones(1,k) .* (1:k)).',1,n)) & 1)) .* repmat(freq.',k,1) ;
    n_w(: , i) = n_w(: , i) + sum(temp.').';
end
toc
 
disp('calculating n_d matrix') ;
tic
for i = 1 : n
    temp = z(i,:) ;
    temp = 1-((repmat(temp,k,1) - repmat((ones(1,k) .* (1:k)).',1,l)) & 1 ) ;
    n_d(: , i) = n_d(:, i) + sum(temp.').';
end
toc



fprintf('\n');
perplexity = zeros(epochCount,1);
test_perplexity = zeros(epochCount,1);
for iter = 1 : epochCount
    fprintf('iteration: %d\n', iter) ;
    tic

    
%     disp('iterating on documents...')
    for d_idx = 1 : n
%         fprintf('iteration %d, document %d out of %d docs\n' , iter, d_idx, n);
        word_indices = (dataset(d_idx,:) & 1 ) .* (1:l) ;
        word_indices = word_indices(word_indices ~= 0) ;
       
        for i = word_indices
            for j = 1 : k
                nwji = n_w(j,i) ;
                snwji = sum(n_w(j,:)) ;
                ndji = n_d(j,d_idx) ;
                sndji = sum(n_d(:,d_idx)) - 1 ;
                if(z(d_idx, i) == j)
                    nwji = nwji - 1 ;
                    snwji = snwji - 1 ;
                    ndji = ndji - 1 ;
                end
                pz_conditional(j) = (nwji + beta) / (snwji + (l * beta)) ;
                pz_conditional(j) = pz_conditional(j) * (ndji + alpha)/(sndji + (k * alpha)) ;
            end
            
            old_topic = z(d_idx,i) ;
            n_d(old_topic, d_idx) = n_d(old_topic, d_idx) - 1 ;
            n_w(old_topic, i) = n_w(old_topic, i) - 1;
            [~,z(d_idx,i)] = max(pz_conditional);
            new_topic = z(d_idx,i) ;
            n_d(new_topic, d_idx) = n_d(new_topic, d_idx) + 1 ;
            n_w(new_topic, i) = n_w(new_topic, i) + 1;
        end
    end
    toc

    disp('updating test phi and test theta') ;
    for j = 1 : k
        for w = 1 : l
            phi(j,w) = (n_w(j , w) + beta) / ( sum(n_w(j,:)) + l * beta);
        end
        
        for d = 1 : n
            theta(j,d) = (n_d(j,d) + alpha) / (sum(n_d(:,d)) + k * alpha) ;
        end
    end
    
  
    
    
    disp('calculating test perplexity') ;
    perplexity(iter) = calculate_perplexity(phi, theta, dataset) ;
    if(iter > 1)
        plot([iter-1,iter],[perplexity(iter-1) , perplexity(iter)], 'r') ;
        hold on;
        drawnow ;
    end
    fprintf('test_perplexity = %d\n' , perplexity(iter));
    

 
end

disp('finished')