function [classes, class_probabilities, selected_pairwise_joint_props , selected_feature_props] = train_bayesian_network(data, lables)
global feature_space;
global words_extracted;

disp('integrating headers with single words in feature_space');
ind = size(feature_space,1) + 1; %integrating headers with single words in feature_space
for i = 1 : size(words_extracted,2)
    feature_space{ind,1} = words_extracted{1,i};
    ind = ind + 1 ;
end
data_size = size(data,1);

disp('recognizing existing distinct labels');
class_counter = 0 ;
for i = 1 : data_size
    found = 0 ;
    for j = 1 : class_counter
        if(strcmp(lower(classes{j}), lower(lables{i,1})) == 1)
            found = j ;
        end
    end
    if(found == 0)
        class_counter = class_counter + 1 ;
        classes{class_counter} = lables{i,1} ;
        class_probabilities(class_counter) = 1;
    else
        class_probabilities(found) = class_probabilities(found) + 1;
    end
end

class_probabilities = class_probabilities / sum(class_probabilities);

fprintf('train_data and train_lables have been checked. %d distinct labels have been recognized\n', class_counter) ;

disp('checking for existence of cpd.m file...');
% if(exist('./cpd.m','file') == 2)
%     disp('loading cpds from cpd.m file...');
%     temp = load('./cpd.m' , '-mat');
%     pairwise_joint_props = temp.pairwise_joint_props ;
%     clear temp;
%     disp('CPDs have been loaded successfully.');
% else
    disp('no CPD file found. Calculating CPDs....');
    pairwise_joint_props = ones(class_counter , size(feature_space,1));
    for f = 1 : size(feature_space,1)
        fprintf('calculating feature_prob %d out of %d\n', f, size(feature_space,1));
        counts = zeros(class_counter,1);
        for d = 1 : data_size
            if(isempty(data{d,1}) == 1)
                continue;
            end
            class_ind = 0 ; %getting class index
            for l = 1 : class_counter
                if(strcmp(classes{l},lables{d}) == 1)
                    class_ind = l;
                    break;
                end
            end
            if(isempty(findstr(strcat(strcat('' , data{d,1}),''),strcat(strcat('' , feature_space{f,1}),'')))==0)
                pairwise_joint_props(class_ind , f) = pairwise_joint_props(class_ind , f) + 1 ;
            end
        end
    end
    disp('saving CPDs...');
    save('./cpd.m' , 'pairwise_joint_props');
    disp('CPDs have been saved successfully.');
% end

disp('calculating probabilities');
feature_props = sum(pairwise_joint_props);

for i = 1 : size(pairwise_joint_props,2)
    pairwise_joint_props(:,i) = pairwise_joint_props(:,i)/feature_props(1,i);
end

feature_props = feature_props./sum(feature_props);

mfeat = max(pairwise_joint_props) ;

threshold = (max(mfeat) - min(mfeat)) * 0.3 + min(mfeat);

fprintf('threshold of feature selection: %d' , threshold);

global selected_feature_space ;
selected_feature_space = {} ;
ind = 1 ;
for i = 1 : size(mfeat,2)
    if(mfeat(1,i) > threshold)
        selected_feature_props(:,ind) = feature_props(:,i) ;
        selected_pairwise_joint_props(:,ind) = pairwise_joint_props(:,i) ;
        selected_feature_space{ind} = feature_space{i};
        ind = ind + 1 ;
    end
end

disp('bayesian network has been successfully trained.');


