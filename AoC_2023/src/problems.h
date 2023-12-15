#include <cctype>
#include <cmath>
#include <chrono>
#include <fstream>
#include <functional>
#include <iostream>
#include <sstream>
#include <string>
#include <unordered_map>
#include <unordered_set>
#include <vector>

std::vector<std::string> ReadFile(std::string filepath);

void Runner(int problem);

int P01A(std::vector<std::string> input);
int P01B(std::vector<std::string> input);

int P02A(std::vector<std::string> input);
int P02B(std::vector<std::string> input);
bool P02APossible(std::string& game, std::unordered_map<std::string, int>& hm);
int P02BMinCubesPower(std::string& game);

int P03A(std::vector<std::string> input);
int P03B(std::vector<std::string> input);

int P04A(std::vector<std::string> input);
int P04B(std::vector<std::string> input);

int P05A(std::vector<std::string> input);
int P05B(std::vector<std::string> input);
void P05AppendSorted(std::vector<std::vector<long long>>& section, std::vector<long long>& line);
void P05FillGaps(std::vector<std::vector<long long>>& section);

std::vector<std::vector<int>> P06AParseInput(std::vector<std::string> input);
std::vector<long long> P06BParseInput(std::vector<std::string> input);
int P06A(std::vector<std::string> input);
int P06B(std::vector<std::string> input);
