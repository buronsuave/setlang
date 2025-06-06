#ifndef STRING_STACK_H
#define STRING_STACK_H

#include <vector>
#include <string>

class StringStack {
  private:
    std::string name;
    std::vector<std::string> stack;

  public:
    void push(const std::string& str) {
      stack.push_back(str);
    }

    std::string pop() {
      if (stack.empty()) return "";
      std::string top = stack.back();
      stack.pop_back();
      return top;
    }

    std::size_t size() const {
      return stack.size();
    }
};

extern StringStack gStringStack;

#endif
