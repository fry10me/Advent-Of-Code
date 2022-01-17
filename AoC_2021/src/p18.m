clear, close, clc;
d = split(fileread("../data/p18_data.txt"));

d = PARSEDATA(d);
sn = d{1};
for i = 2:numel(d)
    sn = SFADD(sn,d{i});
    sn = REDUCE(sn);
end

sprintf("PART1: magnitude: %.0f",SFMAGNITUDE(sn))
sprintf("PART2: magnitude: %.0f",MAXSUM(d))

function m = MAXSUM(d)
c = nchoosek(1:numel(d),2);
c = [c;fliplr(c)];
m = 0;
for i = 1:numel(c(:,1))
    sn = SFADD(d{c(i,1)},d{c(i,2)});
    sn = REDUCE(sn);
    n = SFMAGNITUDE(sn);
    if n > m
        m = n;
    end
end
end

function sn = REDUCE(sn)
while 1
    updated = false;
    [idx1,idx2] = FINDEXPLODE(sn);
    if ~isempty(idx1)
        sn = SFEXPLODE(sn,idx1,idx2);
        updated = true;
    else
        idx = FINDSPLIT(sn);
        if ~isempty(idx)
            sn = SFSPLIT(sn,idx);
            updated = true;
        end
    end
    if ~updated
        break
    end
end
end

function [idx] = FINDSPLIT(sn)
idx = [];
for i = 1:numel(sn(:,1))
    if sn(i,1) > 9
        idx = i;
        break
    end
end
end

function [idx1,idx2] = FINDEXPLODE(sn)
idx1 = [];
idx2 = [];
for i = 1:numel(sn(:,1))
    if (sn(i,2) == 5)
        if sn(i+1,1) >= 0 && sn(i+2,1) >= 0
            idx1 = i+1;
            idx2 = i+2;
            break
        end
    end
end
end

function sn = SFSPLIT(sn,idx)
n1 = floor(sn(idx,1)/2);
n2 = ceil(sn(idx,1)/2);
sn = [sn(1:idx-1,:); [-1,sn(idx,2)+1]; [n1,sn(idx,2)+1]; [n2,sn(idx,2)+1]; [-1,sn(idx,2)]; sn(idx+1:numel(sn(:,1)),:)];
end

function sn = SFEXPLODE(sn,idx1,idx2)
idxL = [];
for i = idx1-1:-1:1
    if sn(i,1) >= 0
        idxL = i;
        break
    end
end
idxR = [];
for i = idx2+1:numel(sn(:,1))
    if sn(i,1) >= 0
        idxR = i;
        break
    end
end
if ~isempty(idxL)
    sn(idxL,1) = sn(idxL,1)+sn(idx1,1);
end
if ~isempty(idxR)
    sn(idxR,1) = sn(idxR,1)+sn(idx2,1);
end
sn = [sn(1:idx1-2,:);[0,sn(idx1,2)-1];sn(idx2+2:numel(sn(:,1)),:)];
end

function sn = SFADD(s1,s2)
sn = [s1;s2];
sn(:,2) = sn(:,2)+1;
sn = [[-1,1];sn;[-1,0]];
end

function n = SFMAGNITUDE(sn)
while 1
    m = 0;
    idx = 0;
    for i = 1:numel(sn(:,1))
        if sn(i,2) > m
            m = sn(i,2);
            idx = i;
        end
    end
    n = sn(idx+1,1)*3+sn(idx+2,1)*2;
    sn = [sn(1:idx-1,:);[n,sn(idx,2)-1];sn(idx+4:numel(sn(:,1)),:)];
    if numel(sn(:,1)) == 1
        break
    end 
end
end

function d = PARSEDATA(data)
n = numel(data);
d = cell(n,1);
for i = 1:n
    cd = [];
    cdi = data{i};
    obc = 0;
    for j = 1:numel(cdi) 
        if cdi(j)-'0' == 43
            obc = obc+1;
            cd = [cd; [-1,obc]];
        elseif cdi(j)-'0' == 45
            obc = obc-1;
            cd = [cd; [-1,obc]];
        elseif cdi(j)-'0' >= 0 && cdi(j)-'0' <= 9 
            cd = [cd; [cdi(j)-'0',obc]];
        end
    end
    d{i} = cd;
end
end