#ifndef SET_STORAGE_H
#define SET_STORAGE_H

#include <iostream>
#include <set>
#include <string>
#include <unordered_map>

extern std::unordered_map<std::string, std::set<std::string>> gSets;

void showSets();
void listSets();
void printSet(const std::set<std::string>& elements);
void showSet(const std::string& name);
void clearSet(const std::string& name);
void deleteSet(const std::string& name);
void addSet(const std::string& name, const std::set<std::string>& elements);
std::set<std::string> unionSets(const std::string& set1, const std::string& set2);
std::set<std::string> intersectSets(const std::string& set1, const std::string& set2);
std::set<std::string> concatSets(const std::string& set1, const std::string& set2);

#endif
