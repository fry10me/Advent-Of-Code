clear, close, clc;
d = splitlines(fileread("../data/p12_data.txt"));

map = PARSEDATA(d);
sprintf("PART 1: paths: %.f",PATHS1(map,'start','start',0))
sprintf("PART 2: paths: %.f",PATHS2(map,'start','start',0,0))

function count = PATHS2(map,visited,node,twice,count)
if strcmp(node,'end')
    count = count+1;
else
    f = map.(node);
    for i = 1:numel(f)
        if ~strcmp(f{i},'start') && ~strcmp(f{i},node)
            if sum(isstrprop(f{i},'upper')) > 0 
                count = PATHS2(map,[visited,f(i)],f{i},twice,count);
            else
                if sum(ismember(visited,f{i})) == 0
                    count = PATHS2(map,[visited,f(i)],f{i},twice,count);
                elseif sum(ismember(visited,f{i})) == 1
                    if twice == 0
                        count = PATHS2(map,[visited,f(i)],f{i},1,count); 
                    end
                end
            end
        end   
    end
end
end

function count = PATHS1(map,visited,node,count)
if strcmp(node,'end')
    count = count+1;
else
    f = map.(node);
    for i = 1:numel(f)
        if ~strcmp(f{i},'start') && ~strcmp(f{i},node)
            if sum(isstrprop(f{i},'upper')) > 0 
                count = PATHS1(map,[visited,f(i)],f{i},count);
            elseif ~ismember(f{i},visited)
                count = PATHS1(map,[visited,f(i)],f{i},count);
            end
        end   
    end
end
end

function map = PARSEDATA(d)
n = numel(d);
map = struct();
for i = 1:n
    di = split(d{i},'-');
    map = POPULATE(map,di,1,2);
    map = POPULATE(map,di,2,1);
end
end

function map = POPULATE(map,di,i,j)
    if isfield(map,(di{i}))
        map.(di{i}) = [map.(di{i}),di(j)];
    else
        map.(di{i}) = di(j);
    end
end