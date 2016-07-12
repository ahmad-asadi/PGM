function [z , phi , theta] = train_lda(data, given_z , given_phi , given_theta)


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

if nargin > 0
    pdataset = dataset;
    dataset = data ;
    phi = given_phi ;
    theta = given_theta ;
    z = given_z ;
end

for j = 1 : k
    fprintf('\t*') ;
    tmp = ones(n,l) * j ;
    tmp = (z - tmp) & 1 ;
    topic_counts(j) = sum(sum((1-tmp))) ;
end
topic_counts = repmat(topic_counts.' , 1 , l);
fprintf('\n');
for iter = 1 : epochCount
    fprintf('iteration: %d\n', iter) ;
    tic
    for d_idx = 1 : n

        z(d_idx, :) = (dataset(d_idx,:) & z(d_idx,:)) .* z(d_idx,:) ;
        document_topic_count = sum((1-(( repmat(z(d_idx, :),k,1) - (ones(k,l) .* repmat((1:k).',1,l)) )&1)).');
        document_topic_count = repmat(document_topic_count.',1,l);
        topic_per_document_count = sum((1-((repmat(z(d_idx,:),k,1) - repmat(ones(1,k).'.*(1:k).',1,l))&1)).');
        document_word_count = repmat(sum(dataset(d_idx, :)),1,k);
        document_word_count = repmat(document_word_count.' , 1 , l);
        topic_per_document_count = repmat(topic_per_document_count.', 1 , l);
        

       word_indices = (dataset(d_idx,:) & 1 ) .* (1:l) ;
       word_indices = word_indices(word_indices ~= 0) ;
       topic_indices = z(d_idx,word_indices) ; 
       for i =1 : size(word_indices)
        topic_per_document_count(topic_indices(i),word_indices(i)) = topic_per_document_count(topic_indices(i),word_indices(i))  - 1;
        document_topic_count(topic_indices(i),word_indices(i)) = document_topic_count(topic_indices(i),word_indices(i))  - 1;
            %document_topic_count(z(d_idx,i)) = document_topic_count(z(d_idx,i)) - 1;
        topic_counts(topic_indices(i),word_indices(i)) = topic_counts(topic_indices(i),word_indices(i))  - 1;
            %topic_counts(z(d_idx,i)) = topic_counts(z(d_idx,i)) - 1;

            pz_conditional = (document_topic_count + beta) ./ ( topic_counts + l * beta);
            pz_conditional = pz_conditional .* ((topic_per_document_count + alpha)./(document_word_count-1 + k * alpha));
            
        topic_per_document_count(topic_indices(i),word_indices(i)) = topic_per_document_count(topic_indices(i),word_indices(i))  + 1;
        document_topic_count(topic_indices(i),word_indices(i)) = document_topic_count(topic_indices(i),word_indices(i))  + 1;
            %document_topic_count(z(d_idx,i)) = document_topic_count(z(d_idx,i)) + 1;
        topic_counts(topic_indices(i),word_indices(i)) = topic_counts(topic_indices(i),word_indices(i))  + 1;
            %topic_counts(z(d_idx,i)) = topic_counts(z(d_idx,i)) + 1;
            topic_counts(topic_indices(i),word_indices(i)) = topic_counts(topic_indices(i),word_indices(i)) - 1;
            [~,new_topics] = max(pz_conditional) ;
            z(d_idx,:) = new_topics;
            topic_indices = z(d_idx,word_indices) ; 
            topic_counts(topic_indices(i),word_indices(i)) = topic_counts(topic_indices(i),word_indices(i)) + 1;
       end
%             topic_counts(topic_,z(d_idx,:)) = topic_counts(:,z(d_idx,:)) - 1;
%             [~,z(d_idx , :)] = max(pz_conditional) ;
%             topic_counts(:,z(d_idx,:)) = topic_counts(:,z(d_idx,:)) + 1;
    end
    toc
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
    
if nargin > 0
    dataset = pdataset;
end