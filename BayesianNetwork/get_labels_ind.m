function label_ind = get_labels_ind(labels, orig_labels)
label_ind = zeros(size(labels,1) , 1);
for i = 1 : size(labels,1)
    for j = 1 : size(orig_labels,2)
        if(strcmp(labels{i,1} , orig_labels{1,j})==1)
            label_ind(i) = j ;
            break;
        end
    end
end