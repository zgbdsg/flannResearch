function data = PrepareData(path)
    path = strcat(path,'\')
    list = dir(strcat(path,'*.jpg'))
    N = length(list);
    
    [R,C] = size(rgb2gray(imread(strcat(path,list(1).name))));
    data = zeros(N,R*C);
    for i=1:N
       imagergb =  imread(strcat(path,list(i).name));
       imaggray = rgb2gray(imagergb);
       a = size(reshape(imaggray',1,[]))
       data(i,:) = reshape(imaggray',1,[]);
    end
    save('newdata','data');
end