clear;	

    load('data\Yale_32x32.mat');

    nClass = length(unique(gnd));
%     fea = NormalizeFea(knnfea);
%     options.ReducedDim = 64;
%     eigvector = PCA(fea, options);
%     newfea = fea*eigvector;
    newfea = NormalizeFea(knnfea);

    rand('twister',5489);
    W = constructW(newfea);

     nBasis = 128;
    alpha = 1;
    beta = 0.1;
     nIters = 15;
    rand('twister',5489);
    warning('off', 'all');
    [B, S, stat] = GraphSC(newfea', W, nBasis, alpha, beta, nIters);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %newpath = sprintf('%s%d%s%d%s','dataset\Yale\',j,'\',i,'.mat');
    %save(newpath,'newfea','gnd','nClass','B','S')
disp(['Clustering in the ',num2str(nBasis),'-dim GraphSC subspace with ',num2str(nIters),' iterations. MIhat: ',num2str(mean(averageMIhat)),'AC:  ',num2str(mean(averageAC))]);
