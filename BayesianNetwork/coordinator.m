%% Controlling the project flow
available_datasets = cellstr(['dataset/mini_newsgroups/';'dataset/20_newsgroups/  ']);

dataset_path = char(available_datasets(1)) ;

%% Importing all strings provided in files along with their labels
[dataset_str,labels] = import_dataset(dataset_path);

extract_words_in_dataset(dataset_str);

featured_data = extract_features(dataset_str);

[test_data, test_labels, train_data, train_labels] = divide_dataset(featured_data, labels);

[labels, class_props, cpds, ~] = train_bayesian_network(train_data, train_labels) ;

predicted_labels_ind = infer(class_props, cpds, train_data) ;

train_labels_ind = get_labels_ind(train_labels, labels);

% equality = @(x)(x == 1);
% 
% correct_predicts = sum(arrayfun(equality , predicted_labels_ind ./ train_labels_ind));
not_predictable = 0 ;
confusion_matrix = zeros(4, 20);
for i = 1 : size(predicted_labels_ind,1)
    confusion_matrix(1,train_labels_ind(i)) = confusion_matrix(1,train_labels_ind(i)) + 1 ;
    if(train_labels_ind(i) == predicted_labels_ind(i))
        confusion_matrix(2,predicted_labels_ind(i)) = confusion_matrix(2,predicted_labels_ind(i)) + 1;
    else
        confusion_matrix(3,predicted_labels_ind(i)) = confusion_matrix(3,predicted_labels_ind(i)) + 1;
    end
end
confusion_matrix(4,:) = confusion_matrix(2,:) ./ confusion_matrix(1,:) ;

disp('Confusion Matrix:');
disp(confusion_matrix);
fprintf('not predictable data: %d\n', not_predictable);

disp('testing set');

predicted_labels_ind = infer(class_props, cpds, test_data) ;

train_labels_ind = get_labels_ind(test_labels, labels);

not_predictable = 0 ;
confusion_matrix = zeros(4, 20);
for i = 1 : size(predicted_labels_ind,1)
    confusion_matrix(1,train_labels_ind(i)) = confusion_matrix(1,train_labels_ind(i)) + 1 ;
    if(train_labels_ind(i) == predicted_labels_ind(i))
        confusion_matrix(2,predicted_labels_ind(i)) = confusion_matrix(2,predicted_labels_ind(i)) + 1;
    else
        confusion_matrix(3,predicted_labels_ind(i)) = confusion_matrix(3,predicted_labels_ind(i)) + 1;
    end
end
confusion_matrix(4,:) = confusion_matrix(2,:) ./ confusion_matrix(1,:) ;

disp('Confusion Matrix:');
disp(confusion_matrix);
fprintf('not predictable data: %d\n', not_predictable);


