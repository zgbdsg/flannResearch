clear;
clc;
addpath('/home/hadoop/mywork/flann')

load('data/PIE_32x32.mat');
nClass = length(unique(gnd));
newfea = NormalizeFea(fea);

% options.ReducedDim = 40;
% meanfea = mean(newfea,1);
% newfea = bsxfun(@minus,fea,meanfea);
% eigvector = PCA(newfea, options);
% newfea = newfea*eigvector;
%newfea = NormalizeFea(newfea);

result_N = [];
result_X = [];
%[labels,dic] = litekmeans(newfea,100,'Replicates',100);

for a=1:10
% [label,center] = litekmeans(newfea,nClass,'Replicates',100);
%[label,center] = kmeans(newfea,nClass,'Replicates',10);
[label, center] = hartigan(newfea,nClass,10);

[AC,MIhat] = Evaluate(label,gnd);
disp(['kmeans use all the features. MIhat: ',num2str(MIhat),'AC:  ',num2str(AC)]);

result_N = [result_N ; AC]
nitem = size(fea,1);

X = zeros(nitem,nitem);
knnsize = round(nitem/20);
%knnsize = 5;
params.algorithm = 'kdtree';
params.trees = 8;
params.cores = 4;
params.checks = 1024;

tic;
%for t = 1:nitem
    %tmpA = fea;
    %tmpA(t,:) = [];
    %tmpy = newfea(t,:);
    %dic_ind = knnsearch(newfea,tmpy,'k',knnsize);
    %dic = newfea(dic_ind,:);
    
    %dic_ind = dic_ind / norm(dic_ind) / 2;
    %tmp = zeros(size(fea,1),1);
    %tmp(dic_ind,1) = 1;
    %X(:,t) = tmp;
%end

dic_ind = flann_search(newfea',newfea',knnsize,params);


for rows=1:nitem
    X (dic_ind(:,rows),rows) = 1;
end


%X = [newfea X']';
toc;

% col_sum = sum(X,2);
% 
% for t=1:size(X,1)
%     X(t,:) = X(t,:)/col_sum(t,1);
% end

% label = litekmeans(X',nClass,'Replicates',100); %'
% [label,center] = kmeans(X,nClass,'Replicates',100);
sparseX = sparse(X);
[label, center] = hartigan(sparseX',nClass,10);

[AC,MIhat] = Evaluate(label,gnd);
disp(['Clustering ',' MIhat: ',num2str(MIhat),'AC:  ',num2str(AC)]);
result_X = [result_X;AC];
end