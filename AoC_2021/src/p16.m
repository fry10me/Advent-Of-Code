clear, close, clc;
d = fileread("../data/p16_data.txt");

[Vsum,num] = DECODE(d);

sprintf("PART 1: version sum: %.f",Vsum)
sprintf("PART 2: decoded val: %.f",num)

function [Vsum,num] = DECODE(d)
binCode = '';
for i = 1:length(d)
    binCode = strcat(binCode,dec2bin(hex2dec(d(i)),4));
end
idx = 1;
OP = [];
Vsum = 0;
while 1
    startIdx = idx;
    V = bin2dec(binCode(idx:idx+2));
    T = bin2dec(binCode(idx+3:idx+5));
    Vsum = Vsum+V;
    idx = idx+6;
    if T == 4
        N = '';
        while 1
            flag = binCode(idx);
            N = strcat(N,binCode(idx+1:idx+4));
            idx = idx+5;
            if strcmp(flag,'0')
                break
            end
        end
        N = bin2dec(N);
        if isempty(OP)
            num = N;
            return 
        else
            if OP(end,4) == -1
                OP(end,4) = N;
            else
            OP(end,4) = OPERATION(OP(end,2),[OP(end,4),N]);
            end
            if OP(end,1) == 1
                OP(end,3) = OP(end,3)-1;
            else
                OP(end,3) = OP(end,3)-(idx-startIdx);
            end
        end
    else
        I = bin2dec(binCode(idx));
        if I == 0
            L = bin2dec(binCode(idx+1:idx+15));
            OP = [OP;[I,T,L,-1]];
            idx = idx+16;
        else
            L = bin2dec(binCode(idx+1:idx+11));
            OP = [OP;[I,T,L,-1]];
            idx = idx+12;
        end
    end
    n = size(OP,1);
    for i = n-1:-1:1
        if OP(i,1) == 0
            OP(i,3) = OP(i,3)-(idx-startIdx);
        end
    end
    for i = n:-1:1
        len = size(OP,1);
        if len == 1
            if OP(i,3) == 0
                num = OP(i,4);
                return
            end
        else
            if OP(i,3) == 0
                if OP(i-1,4) == -1
                    OP(i-1,4) = OP(i,4);
                else
                    OP(i-1,4) = OPERATION(OP(i-1,2),[OP(i-1,4),OP(i,4)]);
                end
                if OP(i-1,1) == 1
                    OP(i-1,3) = OP(i-1,3)-1;
                end
                OP = OP(1:i-1,:);
            end
        end
    end
end
end

    
function cv = OPERATION(TT,NN)
switch TT
    case 0 
        cv = sum(NN);
    case 1 
        cv = prod(NN);
    case 2 
        cv = min(NN);
    case 3 
        cv = max(NN);
    case 5 
        cv = NN(1) > NN(2);
    case 6 
        cv = NN(1) < NN(2);
    case 7 
        cv = NN(1) == NN(2);
end
end