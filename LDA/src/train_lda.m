function [z , phi , theta, perplexity, test_perplexity] = train_lda(data, given_z , given_phi , given_theta)

figure;
title('perplexity');
%initializations
global dataset ;
global k ;

dataset = load('../dataset/ap/feature_vectors.mat' , 'dataset');
dataset = dataset.dataset;

epochCount = 20 ;
l = size(dataset, 2) - 1;
k = 10;%   topic count
pz_conditional = zeros(k,1) ;

dataset = dataset(:,1:l);
test_indices = randi(size(dataset,1) , floor(0.3 * size(dataset,1)) , 1) ;
test_set = dataset(test_indices, :) ;
dataset(test_indices,:) = zeros(size(test_indices,1), size(dataset,2)) ;
dataset(all(dataset==0,2),:)=[];
n = size(dataset, 1);

fprintf('number of documents       =  %d\n', n);
fprintf('number of words           =  %d\n', l);
fprintf('number of latent classes  =  %d\n', k);
fprintf('number of iterations      =  %d\n', epochCount);
fprintf('initialization of parameters\n');


beta = 3; 
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
    temp = z(:,i) ;
    temp = 1-((repmat(temp.',k,1) - repmat((ones(1,k) .* (1:k)).',1,n)) & 1 ) ;
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
                pz_conditional(j) = (nwji * beta) / (snwji + (l * beta)) ;
                pz_conditional(j) = pz_conditional(j) * (ndji + alpha)/(sndji + (l * alpha)) ;
            end
            
            old_topic = z(d_idx,i) ;
            n_d(old_topic, d_idx) = n_d(old_topic, d_idx) - 1 ;
            n_w(old_topic, i) = n_w(old_topic, i) - 1;
            [~,z(d_idx,i)] = max(pz_conditional);
            new_topic = z(d_idx,i) ;
            n_d(new_topic, d_idx) = n_d(new_topic, d_idx) + 1 ;
            n_w(new_topic, i) = n_w(new_topic, i) + 1;
        end
        
        
        
        
        
        
        
        
        
%         z(d_idx, :) = (dataset(d_idx,:) & z(d_idx,:)) .* z(d_idx,:) ;
%         document_topic_count = sum((1-(( repmat(z(d_idx, :),k,1) - (ones(k,l) .* repmat((1:k).',1,l)) )&1)).');
%         document_topic_count = repmat(document_topic_count.',1,l);
%         topic_per_document_count = sum((1-((repmat(z(d_idx,:),k,1) - repmat(ones(1,k).'.*(1:k).',1,l))&1)).');
%         document_word_count = repmat(sum(dataset(d_idx, :)),1,k);
%         document_word_count = repmat(document_word_count.' , 1 , l);
%         topic_per_document_count = repmat(topic_per_document_count.', 1 , l);
%         
% 
%        word_indices = (dataset(d_idx,:) & 1 ) .* (1:l) ;
%        word_indices = word_indices(word_indices ~= 0) ;
%        topic_indices = z(d_idx,word_indices) ; 
%        for i =1 : size(word_indices)
%         topic_per_document_count(topic_indices(i),word_indices(i)) = topic_per_document_count(topic_indices(i),word_indices(i))  - 1;
%         document_topic_count(topic_indices(i),word_indices(i)) = document_topic_count(topic_indices(i),word_indices(i))  - 1;
%             %document_topic_count(z(d_idx,i)) = document_topic_count(z(d_idx,i)) - 1;
%         topic_counts(topic_indices(i),word_indices(i)) = topic_counts(topic_indices(i),word_indices(i))  - 1;
%             %topic_counts(z(d_idx,i)) = topic_counts(z(d_idx,i)) - 1;
% 
%             pz_conditional = (document_topic_count + beta) ./ ( topic_counts + l * beta);
%             pz_conditional = pz_conditional .* ((topic_per_document_count + alpha)./(document_word_count-1 + k * alpha));
%             
%         topic_per_document_count(topic_indices(i),word_indices(i)) = topic_per_document_count(topic_indices(i),word_indices(i))  + 1;
%         document_topic_count(topic_indices(i),word_indices(i)) = document_topic_count(topic_indices(i),word_indices(i))  + 1;
%             %document_topic_count(z(d_idx,i)) = document_topic_count(z(d_idx,i)) + 1;
%         topic_counts(topic_indices(i),word_indices(i)) = topic_counts(topic_indices(i),word_indices(i))  + 1;
%             %topic_counts(z(d_idx,i)) = topic_counts(z(d_idx,i)) + 1;
%             topic_counts(topic_indices(i),word_indices(i)) = topic_counts(topic_indices(i),word_indices(i)) - 1;
%             [~,new_topics] = max(pz_conditional) ;
%             z(d_idx,:) = new_topics;
%             topic_indices = z(d_idx,word_indices) ; 
%             topic_counts(topic_indices(i),word_indices(i)) = topic_counts(topic_indices(i),word_indices(i)) + 1;
%       end
%             topic_counts(topic_,z(d_idx,:)) = topic_counts(:,z(d_idx,:)) - 1;
%             [~,z(d_idx , :)] = max(pz_conditional) ;
%             topic_counts(:,z(d_idx,:)) = topic_counts(:,z(d_idx,:)) + 1;
    end
    toc

%     n_d = zeros(k,n) ;
%     n_w = zeros(k,l) ;
%     for t_idx = 1 :k
%         for d_idx = 1 : n
%             d_topics = (dataset(d_idx,:) & z(d_idx,:) ) .* z(d_idx,:);
%             n_d(t_idx , d_idx) = sum(1 - ((d_topics - (ones(1 , l) * t_idx)) & 1));       
%         end
%         
%         for w_idx = 1 : l
%             w_topics = (dataset(:,w_idx) & z(:,w_idx) ) .* z(:,w_idx) ;
%             n_w(t_idx , w_idx) = sum(1 - ((w_topics - (ones(n , 1) * t_idx)) & 1));       
%         end
%     end
% 

    disp('updating phi and theta') ;
    for j = 1 : k
        for w = 1 : l
            phi(j,w) = (n_w(j , w) + beta) / ( sum(n_w(j,:)) + l * beta);
        end
        
        for d = 1 : n
            theta(j,d) = (n_d(j,d) + alpha) / (sum(n_d(:,d)) + n * alpha) ;
        end
    end
    
    test_phi = zeros(k, l) ;
    test_theta = zeros(k, n) ;
    for j = 1 : k
        for w = 1 : l
            if(sum(test_set(:,w)) > 0 && sum(dataset(:,w)) > 0)
                test_phi(j,w) = (n_w(j , w) + beta) / ( sum(n_w(j,:)) + l * beta);
            end
        end
        
        for d = 1 : size(test_set,1)
            test_theta(j,d) = (n_d(j,d) + alpha) / (sum(n_d(:,d)) + n * alpha) ;
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
    
    disp('calculating test perplexity') ;
    test_perplexity(iter) = calculate_perplexity(test_phi, test_theta, test_set) ;
    if(iter > 1)
        plot([iter-1,iter],[test_perplexity(iter-1) , test_perplexity(iter)] , 'r') ;
        hold on;
        drawnow ;
    end
    fprintf('test_perplexity = %d\n' , test_perplexity(iter));

 
end
 
if nargin > 0
    dataset = pdataset;
end