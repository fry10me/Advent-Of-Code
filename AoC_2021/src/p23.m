clear, close, clc;
data = split(fileread("../data/p23_test.txt"));
[states1,states2,stateRsize1,stateRsize2,endState1,endState2,mapRH,RtH] = PARSEDATA(data);

sprintf("PART 1: score: %.f",SOLVE(states1,stateRsize1,endState1,mapRH,RtH))

function best = SOLVE(states,stateRsize,endState,mapRH,RtH)
scores = 0;
visited = [];
while ~isempty(states)
    [score,idx] = min(scores);
    state = states(idx);
    if state == endState 
        best = score;
        return
    elseif ismember(state,visited) 
        scores = [scores(1:idx-1);scores(idx+1:end)];
        states = [states(1:idx-1);states(idx+1:end)];
    else 
        visited = [visited;state];
        [stateR,stateH] = DECODE(state,stateRsize);
        [newStates,newScores] = NEXT(stateR,stateH,mapRH,RtH,stateRsize,score);
        scores = [scores(1:idx-1);newScores;scores(idx+1:end)];
        states = [states(1:idx-1,:);newStates;states(idx+1:end,:)];
    end
end
end

function [newStates,newScores] = NEXT(stateR,stateH,mapRH,RtH,stateRsize,score)
newStates = zeros(28,1);
newScores = zeros(28,1);
count = 0;
for i = 1:size(stateR,1)
    for j = 1:size(stateR,2)
        for k = 1:numel(RtH)
            if stateR(i,j) ~= 0 && stateH(RtH(k)) == 0
                if ISLEGALRTH([i,j],stateR)
                    if ~ISBLOCKED([i,j],RtH(k),stateR,stateH,mapRH)
                        count = count+1;
                        [newStateR,newStateH] = ROOMTOHALL([i,j],RtH(k),stateR,stateH);
                        newStates(count,:) = ENCODE(newStateR,newStateH,stateRsize);
                        newScores(count) = score+DIST([i,j],RtH(k),mapRH)*(10^(stateR(i,j)-1));
                    end
                end
            elseif stateR(i,j) == 0 && stateH(RtH(k)) ~= 0
                if ISLEGALHTR([i,j],RtH(k),stateR,stateH)
                    if ~ISBLOCKED([i,j],RtH(k),stateR,stateH,mapRH)
                        count = count+1;
                        [newStateR,newStateH] = HALLTOROOM([i,j],RtH(k),stateR,stateH);
                        newStates(count,:) = ENCODE(newStateR,newStateH,stateRsize);
                        newScores(count) = score+DIST([i,j],RtH(k),mapRH)*(10^(stateH(RtH(k))-1));
                    end
                end
            end
        end
    end
end
newStates = newStates(1:count);
newScores = newScores(1:count);
end

function code = ENCODE(stateR,stateH,stateRsize)
pos = zeros(stateRsize+11,1);
for i = 1:numel(stateH)
    if stateH(i) ~= 0
        pos(i) = stateH(i);
    end
end
for i = 1:size(stateR,1)
    for j = 1:size(stateR,2)
        if stateR(i,j) ~= 0
            pos(4*(i-1)+j+11) = stateR(i,j);
        end
    end
end
code = 0; 
for i = 1:numel(pos)
    code = code*5;
    code = code+pos(i);
end
end

function [stateR,stateH] = DECODE(code,stateRsize)
stateH = zeros(1,11);
stateR = zeros(stateRsize/4,4);
for i = stateRsize+11:-1:1
    if mod(code,5) ~= 0
        val = mod(code,5);
        if i > 11
            idxi = ceil((i-11)/4);
            idxj = mod(i-11,4);
            if idxj == 0
                idxj = 4;
            end
            stateR(idxi,idxj) = val;
        else
            stateH(i) = val;
        end
        code = code-val;
    end
    code = code/5;
end
end

function moveOK = ISLEGALRTH(idxR,stateR)
moveOK = false;
for i = idxR(1):size(stateR,1)
    if stateR(i,idxR(2)) ~= idxR(2)
        moveOK = true;
        break
    end
end
end

function moveOK = ISLEGALHTR(idxR,idxH,stateR,stateH)
moveOK = true;
if idxR(2) ~= stateH(idxH)
    moveOK = false;
    return
end
for i = idxR(1)+1:size(stateR,1)
    if stateR(i,idxR(2)) ~= idxR(2)
        moveOK = false;
        break
    end
end
end

function [stateR,stateH] = HALLTOROOM(idxR,idxH,stateR,stateH)
stateR(idxR(1),idxR(2)) = stateH(idxH);
stateH(idxH) = 0;
end

function [stateR,stateH] = ROOMTOHALL(idxR,idxH,stateR,stateH)
stateH(idxH) = stateR(idxR(1),idxR(2));
stateR(idxR(1),idxR(2)) = 0;
end

function dist = DIST(idxR,idxH,mapRH)
dist = idxR(1)+max(mapRH(idxR(2)),idxH)-min(mapRH(idxR(2)),idxH); 
end

function blocked = ISBLOCKED(idxR,idxH,stateR,stateH,mapRH)
blocked = false;
for i = 1:idxR(1)-1
    if stateR(i,idxR(2)) ~= 0
        blocked = true;
        return
    end
end
if mapRH(idxR(2)) > idxH
    h = idxH+1:mapRH(idxR(2));
else
    h = mapRH(idxR(2)):idxH-1;
end
for i = 1:length(h)
    if stateH(h(i)) ~= 0
        blocked = true;
        return
    end
end
end

function [states,states2,stateRsize,stateRsize2,endState,endState2,mapRH,RtH] = PARSEDATA(data)
stateR = [];
for i = 3:numel(data)-1
    d = data{i};
    d = d(isstrprop(d,'alpha'));
    c = zeros(1,numel(d));
    for j = 1:numel(d)
        c(j) = d(j)-'0'-16;
    end
    stateR = [stateR;c];
end
stateR2 = [stateR(1,:);[[4,3,2,1];[4,2,1,3]];stateR(2,:)];
stateH = zeros(1,11);
mapRH = [3;5;7;9];
RtH = [1;2;4;6;8;10;11];
endH = zeros(1,11);
endR = stateR;
endR2 = stateR2;
for i = 1:4
    endR(:,i) = i;
    endR2(:,i) = i;
end
stateRsize = size(stateR,1)*size(stateR,2);
stateRsize2 = size(stateR2,1)*size(stateR2,2);
endState = ENCODE(endR,endH,stateRsize);
endState2 = ENCODE(endR2,endH,stateRsize2);
states = ENCODE(stateR,stateH,stateRsize);
states2 = ENCODE(stateR2,stateH,stateRsize2);
end