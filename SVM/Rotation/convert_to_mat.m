clear;
clc;

data_table = readtable('Feature.xlsx', 'Sheet', 'Sheet1', 'Range', 'A1:K63');
data = table2array(data_table);

for i=1:62
    z = data(i, :);
    filename = ['sub',sprintf('%02d', i), '.mat'];
    save(filename, 'z');
end
