clear, close, clc;
d = split(fileread("../data/p21_data.txt"));
d = [str2double(d{5});str2double(d{10})];
N = 21;

sprintf("PART 1: score: %.f",DETERMINISTIC(d))
sprintf("PART 1: max wins: %.f",DIRAC(d,N))

function wins = DIRAC(d,N)
sr1 = DIRACWINS(d(1),N);
sr2 = DIRACWINS(d(2),N);
[wins1,wins2] = WINS(sr1,sr2,N);
wins = max(wins1,wins2);
end

function [wins1,wins2] = WINS(sr1,sr2,N)
prod = 1;
wins1 = 0;
for i = 1:N
    wins1 = wins1+sr1(i)*prod;
    prod = prod*27;
    prod = prod-sr2(i);
end
prod = 1;
wins2 = 0;
for i = 1:N
    prod = prod*27;
    prod = prod-sr1(i);
    wins2 = wins2+sr2(i)*prod;
end
end

function sr = DIRACWINS(p,N)
pN = 10;
sr = zeros(N,1);
rolls = [[3,1];[4,3];[5,6];[6,7];[7,6];[8,3];[9,1]];
state = zeros(N,pN);
state(1,p) = 1;
round = 1;
while any(state ~= 0, 'all')
    next = zeros(N,pN);
    for i = 1:N
        for j = 1:pN
            if state(i,j) ~= 0
                pNew = mod(j+rolls(:,1),10);
                pNew(pNew == 0) = 10;
                sNew = i+pNew;
                for k = 1:7
                    if sNew(k) > N
                        sr(round) = sr(round)+state(i,j)*rolls(k,2);
                    else
                        next(sNew(k),pNew(k)) = next(sNew(k),pNew(k))+state(i,j)*rolls(k,2);
                    end
                end
            end
        end
    end 
    state = next;
    round = round+1;
end
end

function s = DETERMINISTIC(d)
p1 = [d(1)-1:-1:1,10:-1:d(1)];
p2 = [d(2)-1:-1:1,10:-1:d(2)];
s1 = 0; 
s2 = 0;
die = 100:-1:1;
c = 0;
while 1
    [die,p1,s1,c] = STEP(die,p1,s1,c);
    if s1 >= 1e3
        s = s2*c;
        return
    end
    [die,p2,s2,c] = STEP(die,p2,s2,c);
    if s2 >= 1e3
        s = s1*c;
        return
    end
end
end

function [die,p,s,c] = STEP(die,p,s,c)
roll = die(end)+die(end-1)+die(end-2);
die = circshift(die,3);
p = circshift(p,roll);
s = s+p(end);
c = c+3;
end
