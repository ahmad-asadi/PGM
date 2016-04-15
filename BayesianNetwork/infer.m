function predicted_labels = infer(class_props, cpds, data)
data_size = size(data,1);
predicted_labels = zeros(data_size,1) ;
for i = 1 : data_size
    fprintf('tagging data %d out of %d\n' , i , data_size);
    relative_conditional_props = get_conditional_props(data{i,1} , class_props, cpds);
    [~,predicted_labels(i)] = max(relative_conditional_props);
end



function relative_conditional_props = get_conditional_props(data, PC, PXC)
global selected_feature_space;

words = strsplit(data, {' ',':','.'},'CollapseDelimiters',true);

words_size = min(size(words,2),500);
local_cpd = ones(size(PXC,1) , words_size) ;
for i = 1 : words_size
%     fprintf('checking feature %d out of %d\n' , i , words_size);
    t = min(size(selected_feature_space),20000);
    for j = 1 : t(1,2)
        if(strcmp(selected_feature_space{j}, words{i})==1)
            local_cpd(:,i) = PXC(:,j);
            break;
        end
    end
end

prod_PXC = prod(local_cpd.').' ;

relative_conditional_props = PC.' .* prod_PXC ;