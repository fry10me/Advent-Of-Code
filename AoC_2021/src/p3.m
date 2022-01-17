clear, close, clc;
d = splitlines(fileread("../data/p3_data.txt"));
n = numel(d); m = numel(d{1});
dm = zeros(n,m);
for i = 1:n
    dm(i,:) = d{i}-'0';    
end

sprintf("PART 1: count: %.f", EXG(dm,m,n))
sprintf("PART 2: count: %.f", O2XCO2(d,dm,m,n))

function count = EXG(dm,m,n)
e = blanks(m);
g = e;
for j = 1:m
   if sum(dm(:,j)) >= n/2
       e(j) = '0';
       g(j) = '1';
   elseif sum(dm(:,j)) < n/2
       e(j) = '1';
       g(j) = '0';
   end 
end
count = bin2dec(e)*bin2dec(g);
end

function count = O2XCO2(d,dm,m,n)
O2 = [1:n]';
CO2 = O2;
for j = 1:m    
    if numel(O2) > 1
        if sum(dm(O2,j)) >= ceil(numel(O2)/2)
            O2 = O2(dm(O2,j) == 1);
        else
            O2 = O2(dm(O2,j) == 0);
        end
    end
    if numel(CO2) > 1
        if sum(dm(CO2,j)) >= numel(CO2)/2 
            CO2 = CO2(dm(CO2,j) == 0);
        else 
            CO2 = CO2(dm(CO2,j) == 1);
        end
    end
end  
count = bin2dec(d{O2})*bin2dec(d{CO2});
end
