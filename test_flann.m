addpath('/home/hadoop/mywork/flann');

% create random dataset and test set
dataset = single(rand(128,10000));
testset = single(rand(128,1000));
% define index and search parameters
params.algorithm = 'kdtree';
params.trees = 8;
params.checks = 64;
% perform the nearest-neighbor search
[result, dists] = flann_search(dataset,testset,5,params);
