#include <stdexcept>

#include <Controller.h>
#include <ControllerEvent.h>
#include <Logger.h>


class MobileController : public Controller {
public:
  void onInit(InitEvent &evt);
  double onAction(ActionEvent&);
  //void onRecvMsg(RecvMsgEvent &evt);
  void onCollision(CollisionEvent &evt);

private:
  SimObj* me;
  std::vector<Vector3d> possible_locations;
  size_t i_current_location;
};

void MobileController::onInit(InitEvent &evt) {
  me = getObj(myname());
  
  double y = 40.05;
  // TODO: find good locations
  possible_locations.push_back(Vector3d(0.0, 200, 0.0)); // temp
  /* no longer valid
  possible_locations.push_back(Vector3d(500.0, y, -300.0));
  possible_locations.push_back(Vector3d(300.0, y, 700.0));
  possible_locations.push_back(Vector3d(700.0, y, -700.0));
  possible_locations.push_back(Vector3d(-700.0, y, 300.0));
  possible_locations.push_back(Vector3d(-300.0, y, -300.71));
  possible_locations.push_back(Vector3d(-500.0, y, 500.71));
  */

  i_current_location = rand() % possible_locations.size();
  std::cout << "target is at location #" << i_current_location << std::endl;
  me->setPosition(possible_locations[i_current_location]);
}

double MobileController::onAction(ActionEvent &evt) {
  return 10000.0;
}

void MobileController::onCollision(CollisionEvent &evt) {
  bool collided_with_robot = false;
  const std::vector<std::string> with = evt.getWith();
  for (size_t i = 0; i < with.size(); ++i) {
    if (with[i] == "robot") {
      collided_with_robot = true;
      break;
    }
  }
  bool collided_with_main_part = false;
  if (collided_with_robot) {
    const std::vector<std::string> withParts = evt.getWithParts();
    for (size_t i = 0; i < withParts.size(); ++i) {
      if (withParts[i] == "LINK_CENTER") {
        collided_with_main_part = true;
        break;
      }
    }
    if (collided_with_main_part) {
      size_t temp_i_location;
      do {
        temp_i_location = rand() % possible_locations.size();
      }
      while (temp_i_location == i_current_location);
      i_current_location = temp_i_location;
      std::cout << myname() << ": reached, target jumps to location #" << i_current_location << std::endl;
      me->setPosition(possible_locations[i_current_location]);
    }
  }
}

//void MobileController::onRecvMsg(RecvMsgEvent &evt) {}

extern "C" Controller * createController() {
  return new MobileController;
}

