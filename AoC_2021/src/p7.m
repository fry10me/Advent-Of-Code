clear, close, clc;
d = sort(str2double(split(fileread("../data/p7_data.txt"),',')));

sprintf("PART 1: cost: %.f",LINEARCOST(d))
sprintf("PART 2: cost: %.f",TRAINGLECOST(d))

function c = TRAINGLECOST(d)
x1 = median(d);
x2 = mean(d);
if x1 > x2
    point = ceil(x2);
else
    point = floor(x2);
end
c = sum(abs(point-d).*(abs(point-d)+1)/2);
end

function c = LINEARCOST(d)
point = median(d);
c = sum(abs(point-d));
end
