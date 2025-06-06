#include "set_storage.h"

std::unordered_map<std::string, std::set<std::string>> gSets;

void printSet(const std::set<std::string>& elements) {
    std::cout << "{";               
    for (const auto& elem : elements) {            
        std::cout << elem << ",";                     
    }                                         
    std::cout << "}\n";  
}

void showSets() {
    for (const auto& pair : gSets) {
        std::cout << pair.first << " := ";
	printSet(pair.second);
    }
}

void listSets() {
    for (const auto& pair : gSets) {
        std::cout << pair.first << ",";
    }
    std::cout << "\n";
}

void showSet(const std::string& name) {
    auto it = gSets.find(name);
    if (it == gSets.end()) {
        std::cout << "Set " << name << " is undefined.\n";
	return;
    }

    std::cout << name << " := ";
    printSet(it -> second);
}

void clearSet(const std::string& name) {
    gSets[name].clear();
}

void deleteSet(const std::string& name) {
    gSets.erase(name);
}

void addSet(const std::string& name, const std::set<std::string>& elements) {
    gSets[name] = elements;
}

std::set<std::string> unionSets(const std::string& set1, const std::string& set2) {
    std::set<std::string> result = gSets[set1];
    result.insert(gSets[set2].begin(), gSets[set2].end());
    return result;
}

std::set<std::string> intersectSets(const std::string& set1, const std::string& set2) {
    std::set<std::string> result;
    for (const auto& elem : gSets[set1]) {
        if (gSets[set2].count(elem)) {
	    result.insert(elem);
	}
    }
    return result;
}

std::set<std::string> concatSets(const std::string& set1, const std::string& set2) {
    std::set<std::string> result;
    for (const auto& e1 : gSets[set1]) {
        for (const auto& e2 : gSets[set2]) {
	    result.insert(e1 + e2);
	}
    }
    return result;
}
