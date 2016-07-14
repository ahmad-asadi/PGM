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
        fprintf('importing data from file %s, index:%d\n',file_names(j).name,ind);
        file_pointer = fopen(strcat(current_dir, file_names(j).name),'r');
        
        tline = fgets(file_pointer);
        line_ind = 1 ;
        while ischar(tline)
            file_lines{line_ind} = tline ;
            line_ind = line_ind + 1 ;
            tline = fgets(file_pointer);
        end
        dataset_strs{ind} = file_lines ;
        labels{ind} = list_of_files(i).name;
        ind = ind + 1 ;
        fclose(file_pointer);
    end
end
end
