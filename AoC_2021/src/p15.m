clear, close, clc;
d = splitlines(fileread("../data/p15_data.txt"));

[arr,n,m] = PARSEDATA(d);
bigArr = BIGARR(arr,n,m);

sprintf("PART 1: minimum cost path: %0.f", DIJKSTRA([1,1],arr))
sprintf("PART 2: minimum cost path: %0.f", DIJKSTRA([1,1],bigArr))

function bigArr = BIGARR(arr,n,m)
bigArr = zeros(m*5,n*5);
bigArr(1:m,1:n) = arr;
for i = 1:4
    newArr = bigArr(1:m,n*(i-1)+1:n*i)+1;
    newArr(newArr == 10) = 1;
    bigArr(1:m,n*i+1:n*(i+1)) = newArr;
end
for j = 1:5
    for i = 1:4
        newArr = bigArr(m*(i-1)+1:m*i,n*(j-1)+1:n*j)+1;
        newArr(newArr == 10) = 1;
        bigArr(m*i+1:m*(i+1),n*(j-1)+1:n*j) = newArr;
    end
end
end

function minCost = DIJKSTRA(pos,arr)
[m,n] = size(arr);
arr(pos(1),pos(2)) = 0;
visitedArr = 2*ones(m,n);
visitedArr(pos(1),pos(2)) = 1;
costArr = inf(m,n);
costArr(pos(1),pos(2)) = 0;
potential = zeros(1,2);
adjArr = cell(m,n);
adjArr{1,1} = [[2,1];[1,2]];
adjArr{1,n} = [[1,n-1];[2,n]];
adjArr{m,1} = [[m-1,1];[m,2]];
adjArr{m,n} = [[m,n-1];[m-1,n]];
for i = 2:n-1
    adjArr{1,i} = [[1,i-1];[2,i];[1,i+1]];
    adjArr{m,i} = [[m,i-1];[m-1,i];[m,i+1]];
    adjArr{i,1} = [[i-1,1];[i,2];[i+1,1]];
    adjArr{i,n} = [[i-1,n];[i,n-1];[i+1,n]];
end
for i = 2:m-1
    for j = 2:n-1
        adjArr{i,j} = [[i,j-1];[i+1,j];[i,j+1];[i-1,j]];
    end
end
sq = [[-1;0;1;0],[0;1;0;-1]];
while ~all(visitedArr == 1,'all')
    for i = 1:size(pos,1)
        for j = 1:size(sq,1)
            ii = pos(i,1)+sq(j,1);
            jj = pos(i,2)+sq(j,2);
            if ii >= 1 && ii <= m && jj >= 1 && jj <= n
                if visitedArr(ii,jj) == 2
                    visitedArr(ii,jj) = 0;
                    potential = [potential;[ii,jj]];
                end
            end
        end
    end
    potential = potential(any(potential,2),:); 
    minVal = Inf;
    for i = 1:size(potential,1)
        minAdj = Inf;
        for j = 1:size(sq,1)
            ii = potential(i,1)+sq(j,1);
            jj = potential(i,2)+sq(j,2);
            if ii >= 1 && ii <= m && jj >= 1 && jj <= n
                if costArr(ii,jj) < minAdj
                    minAdj = costArr(ii,jj);
                end
            end
        end
        if arr(potential(i,1),potential(i,2))+minAdj < minVal
            minVal = arr(potential(i,1),potential(i,2))+minAdj;
            idx = i;
        elseif arr(potential(i,1),potential(i,2))+minAdj <= minVal
            idx = [idx;i];
        end
    end
    pos = zeros(size(idx,1),2);
    for i = 1:size(idx,1)
        pos(i,:) = potential(idx(i,:),:);
        costArr(pos(i,1), pos(i,2)) = minVal;
        visitedArr(pos(i,1),pos(i,2)) = 1; 
        potential(idx(i,:),:) = [0,0];
    end
end
minCost = costArr(m,n);
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
end
