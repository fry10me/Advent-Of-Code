clear, close, clc;
d = split(fileread("../data/p20_data.txt"));

[algo,input] = PARSEDATA(d);
for i = 1:50
    input = ENCHANCE(algo,PADINPUT(input,i));
    input = input(2:end-1,2:end-1);
    if i == 2
        sprintf("PART1: lit pixel count ENHANCE x 2: %.0f", sum(input(:)))
    end
end
sprintf("PART2: lit pixel count ENHANCE x 50: %.0f", sum(input(:)))

function output = ENCHANCE(algo,input)
[m,n] = size(input);
output = zeros(m,n);
for i = 2:m-1
    for  j = 2:n-1
        binVal = input(i-1,j-1)*2^8+input(i-1,j)*2^7+input(i-1,j+1)*2^6+...
            input(i,j-1)*2^5+input(i,j)*2^4+input(i,j+1)*2^3+...
            input(i+1,j-1)*2^2+input(i+1,j)*2^1+input(i+1,j+1)*2^0;
        output(i,j) = algo(binVal+1);
    end
end
end

function input = PADINPUT(input,i)
p = 2;
[m,n] = size(input);
if mod(i,2) == 0
    padm = ones(m,p);
    padn = ones(p,n+p*2);
else
    padm = zeros(m,p);
    padn = zeros(p,n+p*2); 
end
input = [padn;[padm,input,padm];padn];
end

function [algo,input] = PARSEDATA(data)
algorithm = data{1};
n = numel(algorithm);
algo = zeros(n,1);
for i = 1:n
    if strcmp(algorithm(i),'#')
        algo(i) = 1;
    end
end
n = numel(data{2});
input = zeros(n);
for i = 2:numel(data)
    d = data{i};
    for j = 1:n 
        if strcmp(d(j),'#')
            input(i-1,j) = 1;
        end
    end
end
end