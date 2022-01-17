clear, close, clc;
d = splitlines(fileread("../data/p4_data.txt"));

[instr,boards,n] = PARSEDATA(d);
[boardW,boardBoolW,instrW,instrL,boardL,boardBoolL] = BESTWORST(boards,instr,n);
sprintf("PART 1: best board score: %.f",BOARDSCORE(boardW,boardBoolW,instrW))
sprintf("PART 2: worst board score: %.f",BOARDSCORE(boardL,boardBoolL,instrL))

function [boardW,boardBoolW,instrW,instrL,boardL,boardBoolL] = BESTWORST(boards,instr,n)
boardsBool = zeros([5,5,n]);
boardsWon = zeros(n,1);
[instrW,boardW,boardBoolW] = deal([],[],[]);
for i = 1:numel(instr)
    for ii = 1:n
        if boardsWon(ii) == 0
            for jj = 1:5
                for kk = 1:5
                    if boards(kk,jj,ii) == instr(i)
                        boardsBool(kk,jj,ii) = 1;
                        if sum(boardsBool(kk,:,ii)) == 5 || sum(boardsBool(:,jj,ii)) == 5
                            if isempty(instrW)
                                instrW = instr(i);
                                boardW = boards(:,:,ii);
                                boardBoolW = boardsBool(:,:,ii);
                            end
                            boardsWon(ii) = 1;
                            if sum(boardsWon) == n
                                instrL = instr(i);
                                boardL = boards(:,:,ii);
                                boardBoolL = boardsBool(:,:,ii);
                                return
                            end
                        end
                    end
                end
            end
        end
    end
end
end

function score = BOARDSCORE(board,boardBool,instrEnd)
score = 0;
for i = 1:5
    for j = 1:5
        if boardBool(i,j) == 0 
            score = score+board(i,j);
        end
    end
end
score = score*instrEnd;
end

function [instr, boards,n] = PARSEDATA(d)
instr = sscanf(d{1},'%f,');
d = d(3:end);
n = (numel(d)+1)/6;
boards = zeros([5,5,n]);
for i = 1:n
    idx = 1;
    currBoard = zeros(5,5);
    for j = 6*(i-1)+1:6*i-1
        currBoard(idx,:) = sscanf(d{j},'%f ');
        idx = idx+1;
    end
    boards(:,:,i) = currBoard;
end
end