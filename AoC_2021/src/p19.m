clear, close, clc;
d = splitlines(fileread("../data/p19_data.txt"));

[d,N] = PARSEDATA(d);
dists = SCANNERDIST(d,N);
sOverlap = COMMONBEACONS(dists,N);
[sm,dm] = RELATIVEPOS(d,sOverlap,N);

sprintf("PART 1: beacon count: %.f",BEACONCOUNT(dm))
sprintf("PART 2: max manhattan dist: %.f",MAXMANHATTAN(sm,N))

function m = MAXMANHATTAN(sm,N)
m = 0;
c = nchoosek(1:N,2);
for i = 1:numel(c(:,1))
    d = MANHATTANDIST(sm{c(i,1)},sm{c(i,2)});
    if d > m
        m = d;
    end
end
end

function d = MANHATTANDIST(P1,P2)
x = abs(P1(1)-P2(1));
y = abs(P1(2)-P2(2));
z = abs(P1(3)-P2(3));
d = x+y+z;
end

function n = BEACONCOUNT(dm)
beacons = [];
for i = 1:numel(dm)
    beacons = [beacons;dm{i}];
end
n = size(unique(beacons,'rows'),1);
end

function P = TRILATERATION(P1,P2,P3,P4,r1,r2,r3,r4)
p1 = [0,0,0];
p2 = [P2(1)-P1(1),P2(2)-P1(2),P2(3)-P1(3)];
p3 = [P3(1)-P1(1),P3(2)-P1(2),P3(3)-P1(3)];
v1 = p2-p1;
v2 = p3-p1;
Xn = v1/norm(v1,'fro');
tmp = cross(v1,v2);
Zn = tmp/norm(tmp,'fro');
Yn = cross(Xn,Zn);
i = dot(Xn,v2);
d = dot(Xn,v1);
j = dot(Yn,v2);
X = ((r1^2)-(r2^2)+(d^2))/(2*d);
Y = (((r1^2)-(r3^2)+(i^2)+(j^2))/(2*j))-((i/j)*(X));
Z1 = sqrt(max(0,r1^2-X^2-Y^2));
Z2 = -Z1;
K1 = round(P1+X*Xn+Y*Yn+Z1*Zn);
K2 = round(P1+X*Xn+Y*Yn+Z2*Zn);
P = (abs(r4-EUCLIDEANDIST3(P4,K1))<=1e-4).*K1+(abs(r4-EUCLIDEANDIST3(P4,K2))<=1e-4).*K2;
end

function d = EUCLIDEANDIST3(P1,P2)
d = sqrt(((P2(1)-P1(1))^2)+((P2(2)-P1(2))^2)+((P2(3)-P1(3))^2));
end

function v = ROLL(v)
v = [v(1),v(3),-v(2)];
end

function v = TURN(v)
v = [-v(2),v(1),v(3)];
end

function rotArr = SEQUENCE(v)
rotArr = [];
for i = 1:2
    for j = 1:3
        v = ROLL(v);
        rotArr = [rotArr; v];
        for k = 1:3
            v = TURN(v);
            rotArr = [rotArr; v];
        end
    end
    v = ROLL(TURN(ROLL(v)));
end
end

function [sm,dm] = RELATIVEPOS(d,sOverlap,N)
dm = cell(N,1);
sm = cell(N,1);
sm{1} = [0,0,0];
dm{1} = d{1};
matched = 1;
notMatched = [2:N]';
while 1
    update = false;
    for i = 1:numel(matched)
        for j = 1:numel(notMatched)
            found = false;
            if size(sOverlap{matched(i),notMatched(j)},1) >= 4
                overlap = sOverlap{matched(i),notMatched(j)};
                points = overlap(1:4,:);
                found = true;
            elseif size(sOverlap{notMatched(j),matched(i)},1) >= 4
                overlap = sOverlap{notMatched(j),matched(i)};
                points = fliplr(overlap(1:4,:));
                found = true;
            end
            if found
                da = dm{matched(i)};
                db = d{notMatched(j)};
                P = [];
                r = [];
                for k = 1:length(points(:,1))
                    r = [r;EUCLIDEANDIST3([db(points(k,2),:)]',[0,0,0])];
                    P = [P;da(points(k,1),:)];
                end
                sb = TRILATERATION(P(1,:),P(2,:),P(3,:),P(4,:),r(1),r(2),r(3),r(4));
                sm{notMatched(j)} = sb;
                dbn = size(db,1);
                rotArr = zeros(dbn,3,24);
                for k = 1:dbn
                    tempArr = SEQUENCE(db(k,:));
                    for ii = 1:24
                        rotArr(k,:,ii) = tempArr(ii,:);
                        rotArr(k,:,ii) = rotArr(k,:,ii)+sb;
                    end
                end
                for k = 1:24
                    if sum(ismember(rotArr(:,:,k),da,'rows')) >= size(overlap,1)
                        dm{notMatched(j)} = rotArr(:,:,k);
                        matched = [matched;notMatched(j)];
                        notMatched(notMatched == notMatched(j)) = [];
                        update = true;
                    end
                end                 
                if update 
                    if isempty(notMatched)
                        return
                    else
                        break
                    end
                end     
            end
        end
        if update
            break
        end
    end
end
end

function sOverlap = COMMONBEACONS(dists,N)
sOverlap = cell(N);
c = nchoosek(1:N,2);
for i = 1:numel(c(:,1))
    matchList = [];
    sa = dists{c(i,1)};
    sb = dists{c(i,2)};
    [m,n] = size(sa);
    for j = 1:m
        for k = 1:n
            if sa(j,k) ~= 0
                [x,y] = find(sb == sa(j,k));
                if ~isempty(x) 
                    for ii = 1:numel(x)
                        matchList = [matchList;[j,k,x(ii),y(ii)]];
                    end
                end
            end
        end
    end
    if ~isempty(matchList)
       for j = 1:4
           [bins,~,ic] = unique(matchList(:,j));
           id = accumarray(ic,1);
           for k = numel(id):-1:1
               if id(k) <= 1
                   ic(ic == k) = [];
                   bins(k) = [];
               end
           end
           for k = 1:length(bins) 
               idx = find(matchList(:,j) == bins(k),2,'first');
               p = matchList(idx,:);
               ba = mode(p(1:2,1:2),'all');
               bb = mode(p(1:2,3:4),'all');
               if isempty(sOverlap{c(i,1),c(i,2)})
                   sOverlap{c(i,1),c(i,2)} = [ba,bb];
               elseif  ~ismember([ba,bb],sOverlap{c(i,1),c(i,2)},'rows')
                   sOverlap{c(i,1),c(i,2)} = [sOverlap{c(i,1),c(i,2)};[ba,bb]];
               end
           end
       end
    end   
end
end

function dists = SCANNERDIST(d,N)
dists = cell(N,1);
for i = 1:N
    dc = d{i};
    n = numel(dc(:,1));
    arr = zeros(n);
    pairs = nchoosek(1:n,2);
    for j = 1:numel(pairs(:,1))
        arr(pairs(j,1),pairs(j,2)) = EUCLIDEANDIST3(dc(pairs(j,1),:),dc(pairs(j,2),:));
    end
    dists{i} = arr;
end
end

function [d,N] = PARSEDATA(data)
d = {};
dc = [];
for i = 1:numel(data)
    c = data{i};
    if isempty(c)
        d = [d;dc];
        dc = [];
    elseif contains(c,',')
        c = strsplit(c,',');
        dc = [dc;str2double(c(1)),str2double(c(2)),str2double(c(3))];
    end
    if i == numel(data)
        d = [d;dc];
    end
end
N = numel(d);
end