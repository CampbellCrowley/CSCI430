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

  class Header {
    string title;
    void RecieveCurState();
  };

  class Body {
    int num_floors = 1;
    Object noise_level;
    void RecieveCurState();
  }

  class Footer {
    int button_navigator;
    Object ChangeScreenState(int screen);
  }
};

void UserInterface::StateManager::InitState() {
  /* * * * * * * * */
  /* Do Something  */
  /* * * * * * * * */
}

int main() {
  UserInterface ui;

  ui::Header h;
  h.RecieveCurState();

  ui::Body b;
  b.RecieveCurState();

  ui::Footer f;
  f.ChangeScreenState(int 1);  // screen 1 = home screen

  return 0;
}
