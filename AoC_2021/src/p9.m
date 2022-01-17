clear, close, clc;
d = splitlines(fileread("../data/p9_data.txt"));

[d,n,m] = PARSEDATA(d);

sprintf("PART 1: low point risk: %.f",LOWRISK(d,n,m))
sprintf("PART 2: basin multiplier: %.f",BASINS(d,n,m))

function c = BASINS(d,n,m)
td = d;
td(td ~= 9) = -1;
td(td == 9) = -Inf;
td = TWOPASS(td,n,m);
u = unique(td);
un = numel(u)-1;
s = zeros(un,1);
for i = 2:un
    s(i) = length(td(td == u(i)));
end
s = sort(s,'descend');
c = s(1)*s(2)*s(3);
end

function td = TWOPASS(td,n,m)
g = 1; 
for i = 2:n-1
    for j = 2:m-1
        if td(i,j) == -1
            if td(i,j-1) > 0
                td(i,j) = td(i,j-1);
                if td(i-1,j) > 0 && td(i-1,j) ~= td(i,j-1)
                    td(td == td(i,j-1)) = td(i-1,j);
                end
            elseif td(i-1,j) > 0 && td(i,j-1) < 0
                td(i,j) = td(i-1,j);
            else
                g = g+1;
                td(i,j) = g;
            end
        end
    end
end
end

function c = LOWRISK(d,n,m)
c = 0;
for i = 2:n-1
    for j = 2:m-1
        minD = min([d(i,j),d(i-1,j),d(i,j+1),d(i+1,j),d(i,j-1)]);
        if  minD == d(i,j) && minD ~= 9
            c = c+d(i,j)+1;
        end
    end
end
end

function [dv,n,m] = PARSEDATA(d)
n = numel(d(:,1));
m = numel(d{1});
dv = zeros(n);
for i = 1:n
    di = d{i};
    for j = 1:m
        dv(i,j) = str2double(di(j));
    end
end
dv = padarray(dv,[1 1],9,'both');
[n,m] = size(dv);
end
