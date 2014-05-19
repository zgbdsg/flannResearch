clear;
clc;
addpath(genpath('./SLEP'));

load('data/PIE_32x32.mat');
load('new/PIE_32x32.mat');
nClass = length(unique(gnd));
fea = NormalizeFea(fea);
options.ReducedDim = 128;
meanfea = mean(fea,1);
fea = bsxfun(@minus,fea,meanfea);
eigvector = PCA(fea, options);
fea = fea*eigvector;

newfea = NormalizeFea(knnfea);
options.ReducedDim = 128;
meanfea = mean(newfea,1);
newfea = bsxfun(@minus,newfea,meanfea);
eigvector = PCA(newfea, options);
newfea = newfea*eigvector;
%newfea = NormalizeFea(newfea);

result_N = [];
result_X = [];
result_G = [];
%[labels,dic] = litekmeans(newfea,100,'Replicates',100);

for a=1:10
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%rand('twister',5489);
W = constructW(fea);

nBasis = 128;
alpha = 1;
beta = 0.1;
nIters = 15;
%rand('twister',5489);
%warning('off', 'all');
[B, S, stat] = GraphSC(fea', W, nBasis, alpha, beta, nIters); 

%rand('twister',5489);
label_N = litekmeans(S',nClass,'Replicates',10);
[AC_N,MIhat] = Evaluate(label_N,gnd);
result_N = [result_N;AC_N];

W = constructW(newfea);

nBasis = 128;
alpha = 1;
beta = 0.1;
nIters = 15;
%rand('twister',5489);
%warning('off', 'all');
[B, S, stat] = GraphSC(newfea', W, nBasis, alpha, beta, nIters); 

%rand('twister',5489);
label_G = litekmeans(S',nClass,'Replicates',10);
[AC_G,MIhat] = Evaluate(label_G,gnd);
result_G = [result_G;AC_G];
disp(['Clustering in the ',num2str(nBasis),'-dim GraphSC subspace with ',num2str(nIters),' iterations. MIhat: ',num2str(MIhat),'AC:  ',num2str(AC_G)]);
end
