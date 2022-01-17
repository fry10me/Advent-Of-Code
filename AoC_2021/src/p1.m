clear, close, clc;
d = readmatrix("../data/p1_data.txt");

sprintf("PART 1: count: %.f", INCR1(d))
sprintf("PART 2: count: %.f", INCR3(d))

function n = INCR1(d)
n = 0;
for i = 2:numel(d)
    if d(i) > d(i-1)
        n = n+1;
    end
end
end

function n = INCR3(d)
n = 0;
for i = 2:numel(d)-2
    if d(i)+d(i+1)+d(i+2) > d(i-1)+d(i)+d(i+1)
        n = n+1;
    end
end
end
