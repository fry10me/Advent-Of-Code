clear, close, clc;
d = splitlines(fileread("../data/p17_data.txt"));

t = PARSEDATA(d{1});
xv = XV(t(1,1),t(1,2));
yv = YV(t(2,1),t(2,2));
yv = FORMAT(yv);
[ts,count] = POSSVEL(xv,yv);

sprintf("PART 1: trick shot: %.f",ts)
sprintf("PART 2: count: %.f",count)

function [ts,count] = POSSVEL(xv,yv)
v = [];
for i = 1:numel(xv(:,1))
    xvv = xv{i,1};
    xvs = xv{i,2};
    for j = 1:numel(xvs)
        if xvs(j) == Inf
            startIdx = Inf;
            for k = 1:numel(yv(:,1))
                if yv{k,1} == xvv+1
                    startIdx = k;
                    break
                end
            end
            for k = startIdx:numel(yv(:,1))
                yvk = yv{k,2};
                for ii = 1:numel(yvk)
                    v = [v;[xvv,yvk(ii)]];
                end
            end
        else
            for k = 1:numel(yv(:,1))
                if xvs(j) == yv{k,1}
                    yvv = yv{k,2};
                    for ii = 1:numel(yvv)
                        v = [v;[xvv,yvv(ii)]];
                    end
                end
            end
        end
    end
end
v = unique(v,'rows');
v = sortrows(v,2);
ts = v(end,:);
ts = ts(2)*(ts(2)+1)/2;
count = numel(v(:,1));
end

function dvf = FORMAT(dv)
dl = [];
for i = 1:numel(dv(:,1))
    dvi = dv{i,2};
    for j = 1:numel(dvi)
        if ~ismember(dvi(j),dl)
            dl = [dl,dvi(j)];
        end
    end
end
n = numel(dl);
dvf = cell(n,2);
for i = 1:n
    dvf{i,1} = dl(i);
    for j = 1:numel(dv(:,1))
        dvj = dv{j,2};
        for k = 1:numel(dvj)
            if dvj(k) == dl(i)
                dvf{i,2} = [dvf{i,2},dv{j,1}];
            end
        end
    end
end
end

function yv = YV(y1,y2)
yv = {};
for i = y1:abs(y1)
    yi = [];
    if i > 0
        m = i;
        N = m;
        idx = 1;
        while 1
            if N >= y1 && N <= y2
                yi = [yi,idx];
            end
            N = N+m-idx;
            if N < y1
                break
            end
            idx = idx+1;
        end
    else
        m = i;
        N = m;
        idx = 1;
        while 1
            if N >= y1 && N <= y2
                yi = [yi,idx];
            end
            m = m-1;
            N = N+m;
            if N < y1
                break
            end
            idx = idx+1;
        end
    end
    if ~isempty(yi)
        yv = [yv; {i,yi}];
    end
end
end

function xv = XV(x1,x2)
n = 1;
while 1
    if n*(n+1)/2 >= x1
        break
    end
    n = n+1;
end
xv = {};
for i = n:x2 
    xi = [];
    m = i;
    N = m;
    idx = 1;
    while 1 
        if N >= x1 && N <= x2
            xi = [xi,idx];
        end
        N = N+m-idx;
        idx = idx+1;
        if idx > m
            if N >= x1 && N <= x2
                xi = [xi,Inf];
            end
            break
        end
    end
    if ~isempty(xi)
        xv = [xv; {i,xi}];
    end
end
end

function target = PARSEDATA(d)
d = strsplit(d,{': ',', '});
target = zeros(2);
for i = 1:2
    ds = strsplit(extractAfter(d{i+1},'='),'..');
    for j = 1:2
        target(i,j) = str2double(ds{j});
    end
end
end