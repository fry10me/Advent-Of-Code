clear, close, clc;
d = splitlines(fileread("../data/p5_data.txt"));
n = numel(d);

[d,mm,nn] = PARSEDATA(d,n);
[count1,count2,arr1,arr2] = SCORE(d,n,mm,nn);

sprintf("PART 1: count: %.f",count1)
sprintf("PART 2: count: %.f",count2)

function [count1,count2,arr1,arr2] = SCORE(d,n,mm,nn)
[arr1,arr2] = deal(zeros(mm,nn),zeros(mm,nn));
for i = 1:n
    if d(i,1) == d(i,3) || d(i,2) == d(i,4)
        arr1 = LINE(arr1,d(i,1),d(i,3),d(i,2),d(i,4));
    end
    arr2 = LINE(arr2,d(i,1),d(i,3),d(i,2),d(i,4));
end
count1 = length(arr1(arr1 >= 2));
count2 = length(arr2(arr2 >= 2));
end

function arr = LINE(arr,x1,x2,y1,y2)
if x2-x1 == 0
    arr(x1,min(y1,y2):max(y1,y2)) = arr(x1,min(y1,y2):max(y1,y2))+1;
elseif y2-y1 == 0
    arr(min(x1,x2):max(x1,x2),y1) = arr(min(x1,x2):max(x1,x2),y1)+1;
else
    for i = 1:max(x1,x2)-min(x1,x2)+1 
       arr((x2>x1)*(x1+i-1)+(x1>x2)*(x1-i+1),(y2>y1)*(y1+i-1)+(y1>y2)*(y1-i+1)) =...
           arr((x2>x1)*(x1+i-1)+(x1>x2)*(x1-i+1),(y2>y1)*(y1+i-1)+(y1>y2)*(y1-i+1))+1;
    end
end
end

function [data,mm,nn] = PARSEDATA(d,n)
data = zeros(n,4);
for i = 1:n
    di = split(d{i},[" -> ",","]);
    for j = 1:4
        data(i,j) = str2double(di{j});
    end
end
data = data+1;
mm = max(data(:,[1,3]),[],'all');
nn = max(data(:,[2,4]),[],'all');
end 
