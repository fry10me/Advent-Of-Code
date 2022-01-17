clear, close, clc;
d = splitlines(fileread("../data/p13_data.txt"));
d(cellfun(@isempty,d)) = []; 

[arr,instrs] = PARSEDATA(d);
arr = FOLDS(arr,instrs);
imshow(arr,'InitialMagnification','fit')

function [arr,instrs] = PARSEDATA(d)
p = [];
instrs = [];
for i = 1:length(d)
    line = d{i};
    if ~isempty(regexp(line(1) ,'[0-9]', 'once'))
        point = strsplit(line,',');
        p = [p; [str2double(point{2})+1,str2double(point{1})+1]];
    else
        instr = strsplit(line,'=');
        dir = instr{1};
        dir = dir(end) == 'x';
        instrs = [instrs; [dir,str2double(instr(2))+1]];
    end
end
arr = zeros(max(p(2)), max(p(1)));
for i = 1:size(p,1)
   arr(p(i,1), p(i,2)) = 1; 
end
end

function arr = FOLDS(arr,instrs)
for i = 1:size(instrs,1)
    if instrs(i,1) == 1 
        newArr = arr(:,1:instrs(i,2)-1);
        [m,n] = size(newArr);
        for j = n:-1:1
            dist = instrs(i,2)-j;
            for k = 1:m
                if arr(k,instrs(i,2)+dist) == 1
                    newArr(k,j) = 1;
                end
            end
        end
    else 
        newArr = arr(1:instrs(i,2)-1,:);
        [m,n] = size(newArr);
        for j = m:-1:1
            dist = instrs(i,2)-j;
            for k = 1:n
                if arr(instrs(i,2)+dist,k) == 1
                    newArr(j,k) = 1;
                end
            end
        end
    end
    arr = newArr;
    if i == 1
        sprintf("PART1: total: %0.f", sum(arr,'all'))
    end
end
end
