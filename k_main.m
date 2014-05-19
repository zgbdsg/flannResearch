clear;
clc;
addpath(genpath('./SLEP'));

load('data/YaleB_32x32.mat');
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
%[label,center] = litekmeans(newfea,nClass,'Replicates',100);
[label,center] = kmeans(newfea,nClass,'Replicates',10);
[AC,MIhat] = Evaluate(label,gnd);
disp(['kmeans use all the features. MIhat: ',num2str(MIhat),'AC:  ',num2str(AC)]);

result_N = [result_N ; AC]
nitem = size(fea,1);

X = zeros(nitem,nitem);
knnsize = round(nitem/20);
tic;
for t = 1:nitem
    %tmpA = fea;
    %tmpA(t,:) = [];
    tmpy = newfea(t,:);
    dic_ind = knnsearch(newfea,tmpy,'k',knnsize);
    %dic = newfea(dic_ind,:);
    
    %dic_ind = dic_ind / norm(dic_ind) / 2;
    tmp = zeros(size(fea,1),1);
    tmp(dic_ind,1) = 1;
    X(:,t) = tmp;
end
%X = [newfea X']';
toc;

label = litekmeans(X',nClass,'Replicates',100); %'
%[label,center] = kmeans(X',nClass,'Replicates',100);
[AC,MIhat] = Evaluate(label,gnd);
disp(['Clustering ',' MIhat: ',num2str(MIhat),'AC:  ',num2str(AC)]);
result_X = [result_X;AC];
end
