function [test_data, test_lables, train_data, train_lables] = divide_dataset (data, lables)
disp('Extracting 70% of dataset as training set and the rest as testing set');
data_size = size(data, 2);
train_size = floor(0.7*data_size) ;

disp('checking existing train and test sets...');
if(exist('./train.m' , 'file') == 2)
    disp('loading train and test sets');
    t = load('./train.m', '-mat');
    train_data = t.train_data;
    t = load('./test.m', '-mat');
    test_data = t.test_data;
    t = load('./trainL.m', '-mat');
    train_lables = t.train_lables;
    t = load('./testL.m', '-mat');
    test_lables = t.test_lables;
    clear t ;
    return ;
end

disp('no train.m file has been found. dividing dataset...');
train_data = cell(train_size,1) ;
test_data = cell(data_size - train_size,1) ;
train_lables = cell(train_size,1) ;
test_lables = cell(data_size - train_size,1) ;

trains = randperm(data_size, train_size) ;
ind = 1 ;
for i = trains
    train_lables{ind} = lables{1,i};
    train_data{ind} = data{1,i};
    ind = ind + 1 ;
end

ind = 1 ;
for i = 1 : data_size
    if(~any(trains == i))
        test_lables{ind} = lables{1,i};
        test_data{ind} = data{1,i};
        ind = ind + 1 ;
    end
end

disp('saving train and test sets...');
save('train.m' , 'train_data');
save('trainL.m' , 'train_lables');
save('test.m' , 'test_data');
save('testL.m' , 'test_lables');
