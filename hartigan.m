function [idx, C, sumD] = hartigan(X, k, count)

n = size (X,1);
C = X(randsample(n,k),:); 
Ccnt = zeros(1,k);
% use bsxfun to compute pairwise distances between two sets of vectors X and C (one row is one sample)
dist = -bsxfun(@minus,bsxfun(@minus,2*X*C',sum(X.^2,2)),sum(C.^2,2)');
[dist, idx] = min(dist,[],2); % find minimum distance values and indexes
fprintf('Initialization, cost = %f\n',sum(full(dist)));

for i=1:k
    pos = find(idx==i);
    Ccnt(i) = length(pos);
    C(i,:) = mean(X(pos,:));
end

for cnt=1:count
    for id=1:n
        newid = id;
        cluster1 = idx(newid);
        if Ccnt(cluster1)>1
            Vx = X(newid,:);
            Vc1 = C(cluster1,:);
            
            C(cluster1,:) = ( C(cluster1,:)*Ccnt(cluster1) - Vx ) / (Ccnt(cluster1)-1);
            Ccnt(cluster1) = Ccnt(cluster1)-1;
            
            deltacost = Ccnt./(Ccnt+1).*(-bsxfun(@minus,bsxfun(@minus,2*Vx*C',sum(Vx.^2,2)),sum(C.^2,2)'));
            [~,cluster2]= min(deltacost);
            
            if cluster1==cluster2
                C(cluster1,:)=Vc1;
                Ccnt(cluster1) = Ccnt(cluster1)+1;
            else
                C(cluster2,:) = ( C( cluster2,:) * Ccnt( cluster2) + Vx )  / (Ccnt(cluster2) +1);
                Ccnt(cluster2) = Ccnt(cluster2)+1;
                idx(newid) = cluster2;
            end
        end
    end
    
    for i=1:k
        pos = find(idx==i);
        Ccnt(i) = length(pos);
        C(i,:) = mean (X(pos,:));
    end
    sumD = 0;
    for i=1:n
        sumD = sumD + sum((X(i,:)-C(idx(i),:)).^2);
    end
    fprintf('Iter %d finished, cost = %f\n',cnt,sumD);
end
