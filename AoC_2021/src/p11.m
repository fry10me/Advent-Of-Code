clear, close, clc;
d = splitlines(fileread("../data/p11_data.txt"));

[arr,n,m] = PARSEDATA(d);
[total,count] = SIMULATE(arr,n,m);

sprintf("PART 1: flash count: %.f",total)
sprintf("PART 2: steps: %.f",count)

function [total,count] = SIMULATE(arr,n,m)
total = 0;
count = 0;
while 1
    arr = arr+1;
    count = count+1;
    [r,c] = find(arr == 10);
    for j = 1:length(r)
        arr = STEP(arr,r(j),c(j));
    end
    for ii = 2:m-1
        for jj = 2:n-1
            if arr(ii,jj) > 9
                arr(ii,jj) = 0;
                if count <= 100
                    total = total+1;
                end
            end
        end
    end
    if sum(arr(2:m-1,2:n-1),'all') == 0
        break
    end
end
end

function arr = STEP(arr,r,c)
rf = [];
cf = [];
for i = c-1:c+1
    arr(r-1,i) = arr(r-1,i)+1;
    arr(r+1,i) = arr(r+1,i)+1;
    if arr(r-1,i) == 10
        rf = [rf, r-1];
        cf = [cf, i];
    end
    if arr(r+1,i) == 10
        rf = [rf, r+1];
        cf = [cf, i];
    end
end
for i = c-1:2:c+1
    arr(r,i) = arr(r,i)+1;
    if arr(r,i) == 10
        rf = [rf, r];
        cf = [cf, i];
    end
end
for i = 1:length(rf)
    arr = STEP(arr,rf(i),cf(i));
end
end

function [arr,n,m] = PARSEDATA(d)
n = numel(d);
m = numel(d{1});
arr = zeros(n,m);
for i = 1:n
    di = d{i};
    for j = 1:m
        arr(i,j) = str2double(di(j));
    end
end
arr = padarray(arr,[1 1],Inf,'both');
[n,m] = size(arr);
end