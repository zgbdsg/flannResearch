clear;	

averageAC = zeros(50,1);
averageMIhat = zeros(50,1);

for j=2:10
    for i=1:50
    load('data\USPS.mat');
    path = sprintf('%s%d%s%d%s','data\USPS\',j,'\',i,'.mat');
    load(path);

    fea = fea(sampleIdx,:);
    gnd = gnd(sampleIdx,:) ;
    %fea(:,zeroIdx) = []; 

    nClass = length(unique(gnd));
    fea = NormalizeFea(fea);
    options.ReducedDim = 64;
    eigvector = PCA(fea, options);
    newfea = fea*eigvector;
    newfea = NormalizeFea(newfea);

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
    newpath = sprintf('%s%d%s%d%s','dataset\USPS\',j,'\',i,'.mat');
    save(newpath,'newfea','gnd','nClass','B','S')
    end
disp(['Clustering in the ',num2str(nBasis),'-dim GraphSC subspace with ',num2str(nIters),' iterations. MIhat: ',num2str(mean(averageMIhat)),'AC:  ',num2str(mean(averageAC))]);
end