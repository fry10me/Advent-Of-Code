clear, close, clc;
d = splitlines(fileread("../data/p24_data.txt"));

n = 14;
[a,b,c] = ABC(d,n);
rules = GENRULES(a,b,c,n);

sprintf("PART 1: largest model number: %s",SEARCH(rules,n,9:-1:1,9:-1:1))
sprintf("PART 2: smallest model number: %s",SEARCH(rules,n,1:9,1:9))

function [a,b,c] = ABC(d,n)
a = zeros(n,1); b = zeros(n,1); c = zeros(n,1);
for i = 1:n
    ai = strsplit(d{(i-1)*18+5}); a(i) = str2double(ai{3});
    bi = strsplit(d{(i-1)*18+6}); b(i) = str2double(bi{3});
    ci = strsplit(d{(i-1)*18+16}); c(i) = str2double(ci{3});
end
end

function rules = GENRULES(a,b,c,n)
rules = zeros(n/2,4); % input of push | c of push | b of pop | input of pop
pushList = [];
idx = 1;
for i = 1:n
    if a(i) == 1
        pushList = [pushList;i];
    else
        rules(idx,:) = [pushList(end),c(pushList(end)),b(i),i];
        pushList(end) = [];
        idx = idx+1;
    end
end
end

function num = SEARCH(rules,n,ji,ki)
num = blanks(n);
for i = 1:n/2
    breakFlag = false;
    for j = ji
        for k = ki
            if j+rules(i,2)+rules(i,3) == k
                num(rules(i,1)) = num2str(j);
                num(rules(i,4)) = num2str(k);
                breakFlag = true;
                break
            end
        end
        if breakFlag == true
            break;
        end
    end
end
end
   