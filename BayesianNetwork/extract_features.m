% Transfering data from dataset space to feature space
function features = extract_features(dataset_str)

    features = cell(1,size(dataset_str,2));
    for i = 1 : size(dataset_str,2)
        features{1} = extract_single_data_features(dataset_str{i}) ;
    end
    
end

function feature_vector = extract_single_data_features(data)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% 12  headers                                              %%%
%%% 1   author                                               %%%
%%%                                                          %%%   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    feature_vector = cell(1,12 + 1 + );
end