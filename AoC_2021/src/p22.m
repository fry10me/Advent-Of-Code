clear, close, clc;
data = split(fileread("../data/p22_data.txt"));
instr = parseInput(data);
instrTrim = modInstr(instr);

n = cubeCnt(instrTrim);
sprintf("PART 1: cube count: %.f",n)

n = cubeCnt(instr);
sprintf("PART 2: cube count: %.f",n)

function n = cubeCnt(instr)
as = [];
for i = 1:numel(instr(:,1))
    cs = instr(i,:);
    ns = [];
    for j = 1:size(as,1)
        if cs(2) > as(j,2) || cs(3) < as(j,1) || cs(4) > as(j,4) || cs(5) < as(j,3) || cs(6) > as(j,6) || cs(7) < as(j,5)
            ns = [ns;as(j,:)];
            continue
        end
        if cs(2) > as(j,1)
            ns = [ns;[as(j,1),cs(2)-1,as(j,3),as(j,4),as(j,5),as(j,6)]];
        end
        if cs(3) < as(j,2)
            ns = [ns;[cs(3)+1,as(j,2),as(j,3),as(j,4),as(j,5),as(j,6)]];
        end
        if cs(4) > as(j,3)
            ns = [ns;[max(as(j,1),cs(2)),min(as(j,2),cs(3)),as(j,3),cs(4)-1,as(j,5),as(j,6)]];
        end
        if cs(5) < as(j,4)
            ns = [ns;[max(as(j,1),cs(2)),min(as(j,2),cs(3)),cs(5)+1,as(j,4),as(j,5),as(j,6)]];
        end
        if cs(6) > as(j,5)
            ns = [ns;[max(as(j,1),cs(2)),min(as(j,2),cs(3)),max(as(j,3),cs(4)),min(as(j,4),cs(5)),as(j,5),cs(6)-1]];
        end
        if cs(7) < as(j,6)
            ns = [ns;[max(as(j,1),cs(2)),min(as(j,2),cs(3)),max(as(j,3),cs(4)),min(as(j,4),cs(5)),cs(7)+1,as(j,6)]];
        end 
    end
    if cs(1) == 1
        ns = [ns;cs(2:7)];
    end
    as = ns;
end 
n = 0;
for i = 1:numel(as(:,1))
    n = n+(as(i,2)-as(i,1)+1)*(as(i,4)-as(i,3)+1)*(as(i,6)-as(i,5)+1);
end
end

function instr = modInstr(instr)
for i = 1:numel(instr(:,1))
    if ~(instr(i,2) >= -50 && instr(i,3) <= 50 && instr(i,4) >= -50 && instr(i,5) <= 50 && instr(i,6) >= -50 && instr(i,7) <= 50)
        instr(i,:) = zeros(1,7);
    end
end
instr = instr(any(instr,2),:);
end

function instr = parseInput(data)
instr = zeros(numel(data)/2,7);
for i = 1:numel(data)
    if mod(i,2) == 1
        if strcmp(data{i},'on')
            instr(ceil(i/2),1) = 1;
        else
            instr(ceil(i/2),1) = 0;
        end
    else
        coords = strsplit(data{i},',');
        for j = 1:3
            v = strsplit(coords{j},{'=','..'});
            instr(ceil(i/2),(j-1)*2+2) = str2double(v{2});
            instr(ceil(i/2),(j-1)*2+3) = str2double(v{3});
        end
    end
end
end
