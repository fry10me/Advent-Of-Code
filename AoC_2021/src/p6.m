clear, close, clc;
d = str2double(split(fileread("../data/p6_data.txt"),','));
n = numel(d);

LANTERNFISH(d,n);

function LANTERNFISH(d,n)
prevState = zeros(9,1);
for i = 1:n
   prevState(d(i)+1) = prevState(d(i)+1)+1;
end
for i = 1:256
    newState = zeros(9,1);
    for j = 9:-1:2
        newState(j-1) = prevState(j);
    end
    newState(9) = prevState(1);
    newState(7) = newState(7) + prevState(1);
    prevState = newState;
    if i == 80
        sprintf("PART 1: count: %.f",sum(prevState))
    end
end
sprintf("PART 2: count: %.f",sum(prevState))
end