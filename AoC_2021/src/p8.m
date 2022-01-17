clear, close, clc;
d = split(splitlines(fileread("../data/p8_data.txt"))," | ");
n = numel(d(:,1));

sprintf("PART 1: sum: %.f",UNIQUEDIGITS(d,n))
sprintf("PART 2: sum: %.f",ALLDIGITS(d,n))

function c = UNIQUEDIGITS(d,n)
c = 0;
for i = 1:n
   di = split(d{i,2});
   for j = 1:numel(di)
       nn = numel(di{j});
       if nn == 2 || nn == 3 || nn == 4 || nn == 7
           c = c+1;
       end
   end
end
end

function sum = ALLDIGITS(d,n)
sum = 0;
for i = 1:n
    [d235,d069] = deal('','');
    dict = cell(8,1);
    di = split(d{i,1});
    for j = 1:numel(di)
        nn = numel(di{j});
        switch nn
            case 2
                dict{2} = di{j};
            case 3
                dict{8} = di{j};
            case 4
                dict{5} = di{j};
            case 5
                d235 = [d235;di{j}];
            case 6
                d069 = [d069;di{j}];
            case 7
                dict{9} = di{j};
        end
    end
    dict = D235(dict,d235);
    dict = D069(dict,d069);
    for j = 1:10
        dict{j} = sort(dict{j});
    end
    do = split(d{i,2});
    for j = 1:numel(do)
        do{j} = sort(do{j});
    end
    si = 0;
    nn = numel(do);
    for j = 1:nn
        for k = 1:10
            if strcmp(do{j},dict{k})
                si = si+10^(nn-j)*(k-1);
            end
        end
    end
    sum = sum+si;
end
end

function dict = D235(dict,d235)
for i = 1:size(d235,1)
    if sum(ismember(dict{8},d235(i,:))) == 3
        dict{4} = d235(i,:);
    else
        if sum(ismember(dict{5},d235(i,:))) == 3
            dict{6} = d235(i,:);
        else
            dict{3} = d235(i,:);
        end
    end
end
end

function dict = D069(dict,d069)
for i = 1:size(d069,1)
    if sum(ismember(dict{5},d069(i,:))) == 4
        dict{10} = d069(i,:);
    else
        if sum(ismember(dict{8},d069(i,:))) == 3
            dict{1} = d069(i,:);
        else
            dict{7} = d069(i,:);
        end
    end  
end
end
