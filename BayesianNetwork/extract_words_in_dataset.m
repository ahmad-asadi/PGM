function extract_words_in_dataset (dataset_str)
global word_ind ;
global words_extracted ;
global word_count ;

if(exist('./extracted_words.txt', 'file')==2) % extracted_words had been already extracted and saved in file
    disp('There exists an extracted_words.txt file, loading words_extracted....');
    temp = load('./extracted_words.txt' , '-mat');
    words_extracted = temp.words_extracted;
    temp = load('./word_count.txt' , '-mat');
    word_count = temp.word_count;
    clear temp;
    return
end
words_extracted = {} ;
word_ind = 1 ;
read_stop_words();
for i = 1 : size(dataset_str,2)
    extract_words(dataset_str{1,i}) ;
    fprintf('extracted word of file %d out of %d, word_count : %d\n' , i , size(dataset_str,2), word_ind);
end
save('./extracted_words.txt' , 'words_extracted') ;
save('./word_count.txt' , 'word_count') ;

function read_stop_words()
global stops;

    fid = fopen('./stop_words.txt', 'r');
    tline = fgets(fid);
    line_ind = 1 ;

    while ischar(tline)
        stops{line_ind} = tline;
        tline = fgets(fid) ;
        line_ind = line_ind + 1 ;
    end
    fclose(fid);
 
function extract_words(lines)
global words_extracted ;
global word_count ;
global stops;
global word_ind ;
    word_count = zeros(75000,1);
    h = 1 ;
    content_line_count = 20 ;
    tline = lines{1,1};
    while ischar(tline)
        blocks = strsplit(tline, {':'} , 'CollapseDelimiters', true );
        if(size(blocks{1},2) == 1)%headers are completed now.
            break;
        end
        if(strcmp(lower(blocks{1,1}) , 'lines') == 1)
            delInd = findstr(tline,':') ;
            content_line_count = str2num(tline(delInd(1)+1 : size(tline,2))) ;
        end
        h = h + 1 ;
        tline = lines{1,h};
    end
    file_lines = lines;
for i = h + 1 : min(size(file_lines,2), content_line_count) + h   
    if(i > size(file_lines, 2))
        break ;
    end
    temp = strsplit(file_lines{1,i}, {' ',':','.'},'CollapseDelimiters',true);
    for j =1 : size(temp,2)
        if(sum(isstrprop(temp{1,j},'digit')) > 0)
            continue;
        end
        exp = '[^ \f\n\r\t\v.,;:><@!#$%&\*?-)(]*';
        b1 = regexp(temp{1,j}, exp, 'match');
        temp{1,j} = [b1{:}];
        if(isempty(temp{1,j}) == 1)
            continue;
        end
        index_c = strfind(stops, temp{1,j}) ;
        index = find(not(cellfun('isempty', index_c)));
        if(~ isempty(index))
            continue;
        end
        index_c = strfind(words_extracted, lower(temp{1,j})) ;
        index = find(not(cellfun('isempty', index_c)));
        if(isempty(index))
            words_extracted{word_ind} = lower(temp{1,j}) ;
            word_count(word_ind) = word_count(word_ind) + 1;
            word_ind = word_ind + 1 ;
        end
    end
end