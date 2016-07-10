function load_dataset()

local_dataset = load('../dataset/ap/ap.mat');
local_dataset = local_dataset.ap;

global vocab ;
file_id = fopen('../dataset/ap/vocab.txt');
vocab = textscan(file_id, '%s');
vocab = vocab{1};
fclose(file_id);

global dataset;
dataset = zeros(size(local_dataset,1) ,size(vocab,1)+1);

for i = 1 : size(local_dataset,1)
    disp(i);
    for j = 1 : size(local_dataset,2)
        str = table2array(local_dataset(i,j));
        [key,value] = strtok(str,':');
        value = strrep(value , ':' , '');
        
        if(isempty(value) || strcmp(value(1,1),'') == 1 || isempty(key) || strcmp(key(1,1),'') == 1 )
            continue;
        end
        
        kv = cell2mat(key);
        vv = cell2mat(value);
        
        k_value = str2double(kv) ;
        v_value = str2double(vv) ;
        
        dataset(i,k_value+1) = v_value;
    end
end

save('../dataset/ap/feature_vectors.mat' , 'dataset');