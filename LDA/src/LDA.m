global dataset;

%load_dataset();

dataset = load('../dataset/ap/feature_vectors.mat' , 'dataset');
dataset = dataset.dataset;
dataset = dataset(:,1:size(dataset,2)-1) ;


test_indices = randi(size(dataset,1) , floor(0.3 * size(dataset,1)) , 1) ;
test_set = dataset(test_indices, :) ;
dataset(test_indices,:) = zeros(size(test_indices,1), size(dataset,2)) ;
dataset = dataset();

[z , phi , theta] = train_lda();

[z , phi , theta] = train_lda(dataset , z , phi , theta) ;

save('../dataset/output.dat' , 'z');