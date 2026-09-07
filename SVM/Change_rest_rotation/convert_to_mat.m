clear;
clc;
data=xlsread('Feature.xlsx', 'Sheet1', 'A2:K63');

for i=1:62
    z = data(i, :);
    filename = ['sub',sprintf('%02d', i), '.mat'];
    save(filename, 'z');
end
