%% Controlling the project flow
available_datasets = cellstr(['dataset/mini_newsgroups/';'dataset/20_newsgroups/  ']);

dataset_path = char(available_datasets(1)) ;

%% Importing all strings provided in files along with their labels
[dataset_str,labels] = import_dataset(dataset_path);
