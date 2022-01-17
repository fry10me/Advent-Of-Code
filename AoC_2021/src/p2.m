clear, close, clc;
d = splitlines(fileread("../data/p2_data.txt"));
n = numel(d);

[dd,dv] = PROCESS(d,n);
[posScore,aimScore] = POSSCORE(dd,dv,n);
sprintf("PART 1: score: %.f", posScore)
sprintf("PART 2: score: %.f", aimScore)

function [posScore,aimScore] = POSSCORE(dd,dv,n)
posS = [0,0];
posA = posS;
aim = 0;
for i = 1:n 
    switch dd(i)
        case 0
            posS(1) = posS(1)+dv(i);
            posA(1) = posA(1)+dv(i);
            posA(2) = posA(2)+aim*dv(i);
        case 1
            posS(2) = posS(2)+dv(i);
            aim = aim+dv(i);
        case 2
            posS(2) = posS(2)-dv(i);
            aim = aim-dv(i);
    end
end
posScore = posS(1)*posS(2);
aimScore = posA(1)*posA(2);
end

function [dd,dv] = PROCESS(d,n)
dd = zeros(n,1); dv = zeros(n,1);
for i = 1:n
    s = strsplit(d{i});
    switch s{1}
        case 'forward'
            dd(i) = 0;
        case 'down'
            dd(i) = 1;
        case 'up'
            dd(i) = 2;
    end
    dv(i) = s{2}-'0';
end
end