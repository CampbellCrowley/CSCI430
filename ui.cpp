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
   public:
    string title;
    void RecieveCurState();
  };

  class Body {
   public:
    int num_floors;
    struct noise_level;
    void RecieveCurState();
  };

  class Footer {
   public:
    int button_navigator;
    struct ChangeScreenState {
      int screen;
    } ScreenState;
  };
};

void UserInterface::StateManager::InitState() {
  /* * * * * * * * */
  /* Do Something  */
  /* * * * * * * * */
}

int main() {
  UserInterface ui;

  UserInterface::Header h;
  h.RecieveCurState();

  UserInterface::Body b;
  b.RecieveCurState();

  UserInterface::Footer f;
  f.ScreenState.screen = 1;  // screen 1 = home screen

  return 0;
}
