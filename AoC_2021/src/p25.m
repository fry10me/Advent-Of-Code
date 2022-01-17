clear, close, clc;
d = split(fileread("../data/p25_data.txt"));
n = numel(d);
m = numel(d{1});

arr = convertInput(d,m,n);
sprintf("PART 1: number of steps: %.f", STEPCOUNT(arr,m,n))

function arr = convertInput(d,m,n)
arr = zeros(n);
for i = 1:n
    di = d{i};
    for j = 1:m
        if strcmp(di(j),'>')
            arr(i,j) = 1;
        elseif strcmp(di(j),'v')
            arr(i,j) = 2;
        end
    end
end
end

function c = STEPCOUNT(arr,m,n)
c = 0;
while 1
    moved = false;
    nextArr = arr;
    for i = 1:n
        for j = 1:m
            if j == m
                if arr(i,j) == 1 && arr(i,1) == 0
                    nextArr(i,j) = 0;
                    nextArr(i,1) = 1;
                end
            else
               if arr(i,j) == 1 && arr(i,j+1) == 0
                   nextArr(i,j) = 0;
                   nextArr(i,j+1) = 1;
               end
            end
        end
    end
    if ~isequal(arr,nextArr)
        moved = true;
        arr = nextArr;
    end 
    for i = 1:n
        for j = 1:m
            if i == n
                if arr(i,j) == 2 && arr(1,j) == 0
                    nextArr(i,j) = 0;
                    nextArr(1,j) = 2;
                end
            else
                if arr(i,j) == 2 && arr(i+1,j) == 0
                    nextArr(i,j) = 0;
                    nextArr(i+1,j) = 2;
                end
            end
        end
    end
    if ~isequal(arr,nextArr)
        moved = true;
        arr = nextArr;
    end
    c = c+1;
    if ~moved
        break
    end
end
end
