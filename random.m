clear;

load('data\PIE_32x32.mat');
total = length(unique(gnd))
for i=2:10
    for j=1:50
        while(1)
            if(total == i)
                a = 1:total
                break;
            end
            a = randi([1,total],1,i);
            if(length(unique(a)) == i)
                a
                break;
            end
        end
        len = length(gnd);
        t = zeros(len,1);
        for k=1:i
            tmp = (gnd == a(1,k));
            t = t | tmp;
        end
        sampleIdx = find(t > 0);
        if (length(sampleIdx) == 0)
            print('sampleindex null!')
            break
        end
        path = sprintf('%s%d%s%d%s','data\PIE\',i,'\',j,'.mat');
        save(path,'sampleIdx');
    end
end