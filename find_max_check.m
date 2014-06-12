clear;
clc;
addpath('flann')

load('data/COIL20.mat');
nClass = length(unique(gnd));
newfea = NormalizeFea(fea);

result_X = [];
all_result = zeros(10-5,10);
result_10_meann_X = [];
nitem = size(fea,1);
times = 1;

for check = 6:10
    checks = 2.^check;
    X = zeros(nitem,nitem);
    knnsize = round(nitem/20);
    %knnsize = 5;
    params.algorithm = 'kdtree';
    params.trees = 8;
    params.cores = 4;
    params.checks = checks;

    tic;

    dic_ind = flann_search(newfea',newfea',knnsize,params);
    for rows=1:nitem
        X (dic_ind(:,rows),rows) = 1;
    end

    toc;

    %sparseX = sparse(X);
    rand('twister',1);
    for a=1:10
        [label, center] = hartigan(X',nClass,10);
        [AC,MIhat] = Evaluate(label,gnd);
        all_result(times,a) = AC;
    end
    meanAC = mean(all_result(times,:),2);
    result_X = [result_X;AC];
    times = times +1;
end

max_val = max(result_X);
max_indx = find(result_X == max_val);
max_check = 2.^max_indx