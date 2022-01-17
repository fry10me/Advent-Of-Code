clear, close, clc;
d = splitlines(fileread("../data/p14_data.txt"));
d(cellfun(@isempty,d)) = []; 

[fromTo,count,emptyCount,letters] = PARSEDATA(d);
POLYMER(10,40,fromTo,count,emptyCount,letters);

function [fromTo,count,emptyCount,letters] = PARSEDATA(d)
fromTo = struct();
count = struct();
for i = 2:length(d)
    instr = strsplit(d{i},' -> ');  
    from = instr{1};
    fromTo.(from) = strcat(from(1), instr{2}, from(2));
    count.(from) = 0;
end
emptyCount = count;
polymer = d{1};
for i = 1:length(polymer)-1
   count.(polymer(i:i+1)) = count.(polymer(i:i+1))+1;
end
letters = struct();
for i = 65:90
    letters.(char(i)) = 0;
end
for i = 1:length(polymer)
    letters.(polymer(i)) = letters.(polymer(i))+1;
end
end

function POLYMER(steps1,steps2,fromTo,count,emptyCount,letters)
fn = fieldnames(count);
for i = 1:steps2
    newCount = emptyCount;
    for j = 1:numel(fn)
        tx = fromTo.(fn{j});
        p1 = tx(1:2);
        p2 = tx(2:end);
        value = count.(fn{j});
        newCount.(p1) = newCount.(p1)+value;
        newCount.(p2) = newCount.(p2)+value;
        letters.(tx(2)) = letters.(tx(2))+value;
    end
    count = newCount;
    if i == steps1
        sprintf("PART 1: diff: %.f",DIFF(letters))
    end
end
sprintf("PART 2: diff: %.f",DIFF(letters))
end

function diff = DIFF(letters)
countList = zeros(26,1);
for i = 65:90 
    countList(i-64) = letters.(char(i));
end
countList(countList == 0) = [];
diff = max(countList)-min(countList);
end
