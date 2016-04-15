% Transfering data from dataset space to feature space
function features = extract_features(dataset_str)

global feature_space;
feature_space = {} ;
    %features = cell(1,size(dataset_str,2));
%     if(exist('./feature_space.m', 'file')==2) % features had been already extracted and saved in file
%         disp('There exists a feature_space.m file, loading featured_data....');
%         temp = load('./feature_space.m' , '-mat');
%         features = temp.features;
%         clear temp;
%         if(exist('./total_feature_space.m', 'file')==2) % features had been already extracted and saved in file
%             disp('There exists a total_feature_space.m file, loading featured_data....');
%             temp = load('./total_feature_space.m' , '-mat');
%             feature_space = temp.feature_space;
%             clear temp;
%         end
%         return ;
%     end
    max_headers = 1 ;
    for i = 1 : size(dataset_str,2)
        fprintf('extracting features %d out of %d \n' , i , size(dataset_str,2));
        [features{i},headers] = extract_single_data_features(dataset_str{i}) ;
    end
%     add_to_feature_space('Extra_Header');
%     add_to_feature_space('Content');
    
    save('./feature_space.m' , 'features');
    save('./total_feature_space.m' , 'feature_space');
    disp('features have been saved in feature_space.txt successfully.');
    
end

function [feature_vector , headers] = extract_single_data_features(data)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% 12  headers                                              %%%
%%% 1   author                                               %%%
%%%                                                          %%%   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    for i = 1 : size(data,2)
        line = data{1,i} ;
        blocks = strsplit(line, {':'} , 'CollapseDelimiters', true );
        if(size(blocks{1},2) == 1)%headers are completed now.
            break;
        end
    end
    content_line_count = 20 ;
    headers = i - 1; 
%     feature_vector = cell(1,headers + 1); 
    for i = 1 : size(data,2)
        line = data{1,i} ;
        blocks = strsplit(line, {':'} , 'CollapseDelimiters', true );
        if(size(blocks{1},2) == 1)%headers are completed now.
            break;
        end
        delInd = findstr(line,':') ;
        if(strcmp(lower(blocks{1,1}) , 'lines') == 1)
            content_line_count = str2num(line(delInd(1)+1 : size(line,2))) ;
        end
%         if(isempty(delInd))
%             disp('here');
%             feature_vector{i} = {'Extra_Header' , lower(line)};
%         else
%             feature_vector{i} = {blocks{1,1} , lower(line(delInd(1)+1 : size(line,2)))};
%             add_to_feature_space(blocks{1,1});
%         end
    end
    h = i  ;
    content = '' ;
    for i = h + 1 : min(size(data,2),content_line_count)
        content = strcat(content , ' ') ;
        content = strcat(content , data{1,i}) ;
    end
%     feature_vector{h} = {'Content' , content};
    feature_vector = content;
end

function add_to_feature_space(feature)
global feature_space;

found = 0 ;
for i = 1 : size(feature_space,1)
    if(strcmp(feature , feature_space{i,1}) == 1)
        found = 1 ;
        break ;
    end
end

if(found == 0)
    feature_space{size(feature_space,1) +1 ,1} = feature;    
end

end

