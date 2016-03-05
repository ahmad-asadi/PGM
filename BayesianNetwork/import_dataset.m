function [dataset_strs, labels] = import_dataset(dataset_path)
list_of_files = dir(dataset_path);
dataset_strs = {} ;
labels = {};
ind = 1 ;
for i = 3 : size(list_of_files , 1)
    current_dir = strcat(dataset_path,list_of_files(i).name);
    file_names = dir(current_dir) ;
    current_dir = strcat(current_dir, '/');
    for j = 3 : size(file_names , 1)
        file_pointer = fopen(strcat(current_dir, file_names(j).name),'r');
        dataset_strs{ind} = fscanf(file_pointer , '%s');
        labels{ind} = list_of_files(i).name;
        ind = ind + 1 ;
    end
end
end
