#include <iostream>
#include <string>
using namespace std;

class UserInterface {
 public:
  class StateManager {
   public:
    string title;
    void InitState();
  };
};

void UserInterface::StateManager::InitState() { /* Do Something */
}

int main() {
  UserInterface ui;

  return 0;
}
