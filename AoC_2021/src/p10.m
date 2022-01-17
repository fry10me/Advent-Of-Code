clear, close, clc;
d = splitlines(fileread("../data/p10_data.txt"));
n = numel(d);
oc = ['([{<';')]}>'];
score = [3,57,1197,25137];

[incomplete,sum,n] = CORRUPTED(d,oc,score,n);
total = INCOMPLETE(incomplete,n);

sprintf("PART 1: corrupt score: %.f",sum)
sprintf("PART 2: incomplete score: %.f",total)


function s = INCOMPLETE(d,n)
scores = zeros(n,1);
for i = 1:n
    sum = 0;
    di = d{i};
    for j = numel(di):-1:1
        switch di(j)
            case '('
                sum = sum*5+1;
            case '['
                sum = sum*5+2;
            case '{'
                sum = sum*5+3;
            case '<'
                sum = sum*5+4;
        end
    end
scores(i) = sum;
end
scores = sort(scores);
s = scores(ceil(n/2));
end

function [incomplete,sum,n] = CORRUPTED(d,oc,score,n)
sum = 0;
corruptIdx = [];
incomplete = cell(n,1);
for i = 1:n
    corrupt = false;
    di = d{i};
    ni = numel(di);
    buff = di(1);
    for j = 2:ni
        if ismember(di(j),oc(1,:))
            buff = [buff,di(j)];
        else
            if isempty(buff)
                corruptIdx = [corruptIdx,i];
                sum = sum + score(oc(2,:) == di(j));
                corrupt = true;
                break
            else
                if oc(1,oc(2,:) == di(j)) == buff(end)
                    buff = buff(1:end-1);
                else
                    corruptIdx = [corruptIdx,i];
                    sum = sum + score(oc(2,:) == di(j));
                    corrupt = true;
                    break
                end
            end
        end
    end
    if ~corrupt
        incomplete{i} = buff;
    end
end
d(corruptIdx) = [];
incomplete(corruptIdx) = [];
n = numel(d);
end