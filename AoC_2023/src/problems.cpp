# include "problems.h"

std::vector<std::string> ReadFile(std::string filepath)
{
    std::ifstream infile(filepath);
    if (!infile.is_open()) {
        std::cerr << "Error opening file: " << filepath << std::endl;
        exit(1);
    }

    std::string line;
    std::vector<std::string> lines;
    while (std::getline(infile, line)) {
        lines.push_back(line);
    }

    infile.close();
    return lines;
}

void Runner(int problem)
{
    std::vector<std::string> input;
    int (*ptrA)(std::vector<std::string>);
    int (*ptrB)(std::vector<std::string>);

    switch(problem)
    {
        case 1:
        {
            input = ReadFile("../data/d01.txt");
            ptrA = P01A;
            ptrB = P01B;
        }
        case 2:
        {
            input = ReadFile("../data/d02.txt");
            ptrA = P02A;
            ptrB = P02B;
        }
        case 3:
        {
            input = ReadFile("../data/d03.txt");
            ptrA = P03A;
            ptrB = P03B;
        }
        case 4:
        {
            input = ReadFile("../data/d04.txt");
            ptrA = P04A;
            ptrB = P04B;
        }
        case 6:
        {
            input = ReadFile("../data/d06.txt");
            ptrA = P06A;
            ptrB = P06B;
        }
    }

    auto start = std::chrono::high_resolution_clock::now();
    int partA = ptrA(input);
    auto stop = std::chrono::high_resolution_clock::now();
    float duration = std::chrono::duration_cast<std::chrono::microseconds>(stop - start).count() / 1e6;
    std::cout << "P0" << problem << "A: " << partA << " in " << duration << " seconds." << std::endl;

    start = std::chrono::high_resolution_clock::now();
    int partB = ptrB(input);
    stop = std::chrono::high_resolution_clock::now();
    duration = std::chrono::duration_cast<std::chrono::microseconds>(stop - start).count() / 1e6;
    std::cout << "P0" << problem << "B: " << partB << " in " << duration << " seconds." << std::endl;
}

// --- P01 --- //
int P01A(std::vector<std::string> input)
{
    //PART A
    int total = 0;
    for (int i = 0; i < input.size(); i++)
    {
        int first = -1;
        int second = -1;
        for (int j = 0; j < input[i].size(); j++)
        {
            if (isdigit(input[i][j]))
            {
                if (first < 0)
                {
                    first = input[i][j] - '0';
                }
                second = input[i][j] - '0';
            }
        }
        total += first * 10 + second;
    }
    return total;
}

int P01B(std::vector<std::string> input)
{
    std::vector<std::string> words{"one", "two", "three", "four", "five", "six", "seven", "eight", "nine"};
    std::vector<int> wordsLen{3, 3, 5, 4, 4, 3, 5, 5, 4};
    std::unordered_map<std::string, int> hm
    { 
        {"one", 1}, 
        {"two", 2}, 
        {"three", 3}, 
        {"four", 4}, 
        {"five", 5}, 
        {"six", 6}, 
        {"seven", 7}, 
        {"eight", 8}, 
        {"nine", 9} 
    };

    int total = 0;
    for (int i = 0; i < input.size(); i++)
    {
        int first = -1;
        int second = -1;
        int n = input[i].size();
        for (int j = 0; j < n; j++)
        {
            if (isdigit(input[i][j]))
            {
                if (first < 0)
                {
                    first = input[i][j] - '0';
                }
                second = input[i][j] - '0';
            }
            else
            {
                for (int k = 0; k < 9; k++)
                {
                    if (n - j + 1 >= wordsLen[k] && input[i].substr(j, wordsLen[k]) == words[k])
                    {
                        if (first < 0)
                        {
                            first = hm[words[k]];
                        }
                        second = hm[words[k]];
                    }
                }
            }
        }
        total += first * 10 + second;
    }
    return total;
}

// --- P02 --- //
int P02A(std::vector<std::string> input)
{
    std::unordered_map<std::string, int> hm
    { 
        {"red", 12}, 
        {"green", 13}, 
        {"blue", 14}
    };

    int total = 0;
    for (int i = 0; i < input.size(); i++)
    {
        std::string game = input[i].substr(std::to_string(i + 1).length() + 7);
        if (P02APossible(game, hm))
        {
            total += i + 1;
        }
    }
    return total;
}

bool P02APossible(std::string& game, std::unordered_map<std::string, int>& hm)
{
    int state = -1;
    int count;
    std::string countStr = "";
    std::string color = "";
    for (int j = 0; j < game.size(); j++)
    {
        if (game[j] == ',' || game[j] == ';')
        {
            continue;
        }
        else if (game[j] == ' ')
        {
            if (state < 0)
            {
                count = std::stoi(countStr);
                countStr = "";
            }
            else
            {
                if (hm[color] < count)
                {
                    return false;
                }
                color = "";
            }
            state *= -1;
        }
        else
        {
            if (state < 0)
            {
                countStr += game[j];
            }
            else
            {
                color += game[j];
            }
        }
    }
    if (hm[color] < count)
    {
        return false;
    }
    return true;
}

int P02B(std::vector<std::string> input)
{
    int total = 0;
    for (int i = 0; i < input.size(); i++)
    {
        std::string game = input[i].substr(std::to_string(i + 1).length() + 7);
        total += P02BMinCubesPower(game);
    }
    return total;
}

int P02BMinCubesPower(std::string& game)
{
    std::unordered_map<std::string, int> hm
    { 
        {"red", 0}, 
        {"green", 0}, 
        {"blue", 0}
    };

    int state = -1;
    int count;
    std::string countStr = "";
    std::string color = "";
    for (int j = 0; j < game.size(); j++)
    {
        if (game[j] == ',' || game[j] == ';')
        {
            continue;
        }
        else if (game[j] == ' ')
        {
            if (state < 0)
            {
                count = std::stoi(countStr);
                countStr = "";
            }
            else
            {
                if (hm[color] < count)
                {
                    hm[color] = count;
                }
                color = "";
            }
            state *= -1;
        }
        else
        {
            if (state < 0)
            {
                countStr += game[j];
            }
            else
            {
                color += game[j];
            }
        }
    }
    if (hm[color] < count)
    {
        hm[color] = count;
    }

    return hm["red"] * hm["green"] * hm["blue"];
}

// --- P03 --- //
int P03A(std::vector<std::string> input)
{
    int total = 0;
    std::vector<std::vector<int>> dir { {-1, 0}, {1, 0}, {0, -1}, {0, 1}, {-1, -1}, {-1, 1}, {1, 1}, {1, -1} };
    std::unordered_set<int> s;

    for (int i = 0; i < input.size(); i++)
    {
        for (int j = 0; j < input[0].size(); j++)
        {
            if (!(isdigit(input[i][j]) || input[i][j] == '.'))
            {
                for (int k = 0; k < dir.size(); k++)
                {
                    int x = j + dir[k][0];
                    int y = i + dir[k][1];
                    if (x >= 0 && x < input[i].size() && y >= 0 && y < input.size() && isdigit(input[y][x]) && s.count(y * input[0].size() + x) == 0)
                    {
                        std::string number;
                        number = input[y][x];
                        s.insert(y * input[0].size() + x);

                        int left = x - 1;
                        while (left >= 0 && isdigit(input[y][left]))
                        {
                            s.insert(y * input[0].size() + left);
                            number = input[y][left] + number;
                            left--; 
                        }

                        int right = x + 1;
                        while (right < input[i].size() && isdigit(input[y][right]))
                        {
                            s.insert(y * input[0].size() + right);
                            number += input[y][right];
                            right++; 
                        }
                        total += std::stoi(number);
                    }
                }
            }
        }
    }
    return total;
}

int P03B(std::vector<std::string> input)
{
    int total = 0;
    std::vector<std::vector<int>> dir { {-1, 0}, {1, 0}, {0, -1}, {0, 1}, {-1, -1}, {-1, 1}, {1, 1}, {1, -1} };
    std::unordered_set<int> s;

    for (int i = 0; i < input.size(); i++)
    {
        for (int j = 0; j < input[0].size(); j++)
        {
            if (input[i][j] == '*')
            {
                std::vector<int> adj;
                for (int k = 0; k < dir.size(); k++)
                {
                    int x = j + dir[k][0];
                    int y = i + dir[k][1];
                    if (x >= 0 && x < input[i].size() && y >= 0 && y < input.size() && isdigit(input[y][x]) && s.count(y * input[0].size() + x) == 0)
                    {
                        std::string number;
                        number = input[y][x];
                        s.insert(y * input[0].size() + x);

                        int left = x - 1;
                        while (left >= 0 && isdigit(input[y][left]))
                        {
                            s.insert(y * input[0].size() + left);
                            number = input[y][left] + number;
                            left--; 
                        }

                        int right = x + 1;
                        while (right < input[i].size() && isdigit(input[y][right]))
                        {
                            s.insert(y * input[0].size() + right);
                            number += input[y][right];
                            right++; 
                        }
                        adj.emplace_back(std::stoi(number));
                    }
                }
                if (adj.size() == 2)
                {
                    total += adj[0] * adj[1];
                }
                adj.clear();
            }
        }
    }
    return total;
}

// --- P04 --- //
int P04A(std::vector<std::string> input)
{
    int total = 0;
    for (int i = 0; i < input.size(); i++)
    {
        int idx = 0;
        std::string strNum = "";
        std::vector<std::unordered_set<int>> numbers(2);
        std::string data = input[i].substr(input[i].find(":") + 1); 
        for (int j = 0; j < data.size(); j++)
        {
            if (data[j] == ' ')
            {
                if (!strNum.empty())
                {
                    numbers[idx].insert(std::stoi(strNum));
                    strNum = "";
                }               
            }
            else if (data[j] == '|')
            {
                idx++;
            }
            else
            {
                strNum += data[j];
            }
        }

        if (!strNum.empty())
        {
            numbers[idx].insert(std::stoi(strNum));
        }
        
        int nMatches = 0;
        for (const auto& element : numbers[0]) 
        {
            if (numbers[1].count(element) > 0)
            {
                nMatches += 1;
            }
        }

        if (nMatches > 0)
        {
            total += std::pow(2, nMatches - 1);
        }
    }

    std::cout << total << std::endl;


    return total;
}

int P04B(std::vector<std::string> input)
{
    int total = 0;
    std::vector<int> counts(input.size(), 1);
    for (int i = 0; i < input.size(); i++)
    {
        int idx = 0;
        std::string strNum = "";
        std::vector<std::unordered_set<int>> numbers(2);
        std::string data = input[i].substr(input[i].find(":") + 1); 
        for (int j = 0; j < data.size(); j++)
        {
            if (data[j] == ' ')
            {
                if (!strNum.empty())
                {
                    numbers[idx].insert(std::stoi(strNum));
                    strNum = "";
                }               
            }
            else if (data[j] == '|')
            {
                idx++;
            }
            else
            {
                strNum += data[j];
            }
        }

        if (!strNum.empty())
        {
            numbers[idx].insert(std::stoi(strNum));
        }
        
        int nMatches = 0;
        for (const auto& element : numbers[0]) 
        {
            if (numbers[1].count(element) > 0)
            {
                nMatches += 1;
            }
        }

        if (nMatches > 0)
        {
            for (int k = 1; k < nMatches + 1; k++)
            {
                counts[i+k] += counts[i];
            }
        }
        total += counts[i];
    }
    return total;
}

// -- P05 --- //
int P05A(std::vector<std::string> input)
{
    std::string strNum = "";
    std::vector<long long> seeds;
    std::string seedsInfo = input[0].substr(input[0].find(":") + 1); 
    for (int i = 0; i < input[0].size(); i++)
    {
        if (seedsInfo[i] == ' ')
        {
            if (!strNum.empty())
            {
                seeds.emplace_back(std::stoll(strNum));
                strNum = "";
            }               
        }
        else
        {
            strNum += seedsInfo[i];
        }
    }
    seeds.emplace_back(std::stoi(strNum));
    strNum = "";

    int i = 3;
    std::vector<std::vector<long long>> section;
    std::vector<std::vector<std::vector<long long>>> data;
    while (i < input.size())
    {
        if (isdigit(input[i][0]))
        {
            std::vector<long long> line;
            for (int j = 0; j < input[i].size(); j++)
            {
                if (input[i][j] == ' ')
                {
                    if (!strNum.empty())
                    {
                        line.emplace_back(std::stoll(strNum));
                        strNum = "";
                    }               
                }
                else
                {
                    strNum += input[i][j];
                }
            }
            line.emplace_back(std::stoll(strNum));
            P05AppendSorted(section, line); 
            strNum = "";
            i++;
        }
        else
        {
            P05FillGaps(section);
            data.push_back(section);
            section.clear();
            i += 2;
        }
    }
    P05FillGaps(section);
    data.push_back(section);

    /*long long value;
    long long partA = std::numeric_limits<long long>::max();
    for (int i = 0; i < seeds.size(); i++)
    {
        value = seeds[i];
        for (int j = 0; j < data.size() - 1; j++)
        {
            value = P05GetConversionValue(data, j, value);
        }
        if (value < partA)
        {
            partA = value;
        }
    }

    std::cout << "partA: " << partA << std::endl;
    */

    struct Range
    {
            Range(long long _min, long long _max) 
            {
                min = _min;
                max = _max;
            }
            long long min;
            long long max;
    };

    long long partB = std::numeric_limits<long long>::max();
    for (int ii = 0; ii < seeds.size() / 2; ii++)
    {
        std::vector<Range> currRanges{ Range(seeds[ii*2], seeds[ii*2] + seeds[ii*2+1] - 1) };
        for (int i = 0; i < data.size(); i++) // for each section
        {
            std::vector<Range> nextRanges;
            Range sectionRange(data[i][0][1], data[i].back()[1] + data[i].back()[2] - 1);
            for (int j = 0; j < currRanges.size(); j++)
            {
                if (currRanges[j].min > sectionRange.max) // entirely left
                {
                    nextRanges.push_back(currRanges[j]);
                }
                else if (currRanges[j].max < sectionRange.min) // entirely right
                {
                    nextRanges.push_back(currRanges[j]);
                }
                else // some overlap
                {
                    if (currRanges[j].min < sectionRange.min) // partial left
                    {
                        nextRanges.push_back(Range(currRanges[j].min, sectionRange.min - 1));
                    } 

                    if (currRanges[j].max > sectionRange.max) // partial right
                    {
                        nextRanges.push_back(Range(sectionRange.max + 1, currRanges[j].max));
                    }

                    // overlaps
                    for (int k = 0; k < data[i].size(); k++) // for each line
                    {
                        long long lineMin = data[i][k][1];
                        long long lineMax = data[i][k][1] + data[i][k][2] - 1;
                        if (currRanges[j].min <= lineMax && lineMin <= currRanges[j].max) // overlap exists.
                        {   
                            long long start = std::max(currRanges[j].min, lineMin);
                            long long end = std::min(currRanges[j].max, lineMax);
                            long long difference = data[i][k][0] - data[i][k][1];
                            nextRanges.push_back(Range(start + difference, end + difference));
                        }
                    }
                }
            }

            // squish (any) shared, redundant ranges
            currRanges.clear();
            for (int j = 0; j < nextRanges.size(); j++)
            {
                for (int k = currRanges.size() - 1; k >= 0; k--)
                {
                    if (nextRanges[j].min <= currRanges[k].max && currRanges[k].min <= nextRanges[j].max) // if overlap
                    {
                        nextRanges[j].min = std::min(nextRanges[j].min, currRanges[k].min);
                        nextRanges[j].max = std::max(nextRanges[j].max, currRanges[k].max);
                        currRanges.erase(currRanges.begin() + k);
                    }
                }
                currRanges.push_back(nextRanges[j]);
            }
        }

        // keep track of the lowest value
        for (int j = 0; j < currRanges.size(); j++)
        {
            if (currRanges[j].min < partB)
            {
                partB = currRanges[j].min;
            }
        }
    }



    
    

    std::cout << "FINAL: " << partB << std::endl;


    return partB;
}

void P05AppendSorted(std::vector<std::vector<long long>>& section, std::vector<long long>& line)
{
    for (int i = 0; i < section.size(); i++)
    {
        if (line[1] < section[i][1])
        {
            section.insert(section.begin() + i, line);
            return;
        }
    }
    section.push_back(line);
}

void P05FillGaps(std::vector<std::vector<long long>>& section)
{
    for (int i = section.size() - 1; i > 0; i--)
    {
        if (section[i-1][1] + section[i-1][2] < section[i][1])
        {
            long long start = section[i-1][1] + section[i-1][2];
            long long end = section[i][1] - 1;
            long long range = end - start + 1;
            section.insert(section.begin() + i, std::vector<long long> { start, start, range} );
        }
    }
}

// --- P06 --- //
std::vector<std::vector<int>> P06AParseInput(std::vector<std::string> input)
{
    std::string strNum;
    std::vector<std::vector<int>> data(2);
    for (int i = 0; i < input.size(); i++)
    {
        for (int j = 0; j < input[i].size(); j++)
        {
            if (isdigit(input[i][j]))
            {
                strNum += input[i][j];
            }
            else if (!strNum.empty())
            {
                data[i].emplace_back(std::stoi(strNum));
                strNum = "";
            }
        }
        if (!strNum.empty())
        {
            data[i].emplace_back(std::stoi(strNum));
            strNum = "";
        }
    }
    return data;
}

std::vector<long long> P06BParseInput(std::vector<std::string> input)
{
    std::vector<long long> data(2);
    for (int i = 0; i < input.size(); i++)
    {
        std::string strNum = "";
        for (int j = 0; j < input[i].size(); j++)
        {
            if (isdigit(input[i][j]))
            {
                strNum += input[i][j];
            }
        }
        data[i] = std::stoll(strNum);
    }
    return data;
}

int P06A(std::vector<std::string> input)
{
    int res = 1;
    std::vector<std::vector<int>> data = P06AParseInput(input);
    for (int i = 0; i < data[0].size(); i++)
    {
        for (int j = 1; j < data[0][i]; j++)
        {
            if (j * (data[0][i] - j) > data[1][i])
            {
                res *= (data[0][i] - j) - j + 1;
                break;
            }
        }
    }
    return res;
}

int P06B(std::vector<std::string> input)
{
    std::vector<long long> data = P06BParseInput(input);

    long long left = 0;
    long long right = data[0];
    long long target = data[1];
    while (left <= right)
    {
        long long mid = left + (right - left) / 2;
        long long score = mid * (data[0] - mid);
        long long scoreLeft = (mid-1) * (data[0] - (mid-1));
        if (score > target && scoreLeft <= target)
        {
            return (data[0] - mid) - mid + 1;
        }
        else if (score > target)
        {
            right = mid - 1;
        }
        else
        {
            left = mid + 1;
        }
    }
    return -1;
}


// --- P07 --- //



