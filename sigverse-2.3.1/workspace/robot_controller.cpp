#include <stdexcept>

#include <Controller.h>
#include <ControllerEvent.h>
#include <Logger.h>
#include <ViewImage.h>

enum Action { NOTHING, FORWARD, BACK, LEFT, RIGHT,
              // last element to get the size of the enum
              N_ACTIONS };

// a bit biased
Action random_action() { return static_cast<Action>(rand() % (int)(N_ACTIONS)); }

class MobileController : public Controller {
public:
  //MobileController();
  //~MobileController();
  void onInit(InitEvent &evt);
  double onAction(ActionEvent&);
  void onRecvMsg(RecvMsgEvent &evt);
  void onCollision(CollisionEvent &evt);

private:
  double time_step;
  double max_velocity; // rad/s
  RobotObj* me;
  int n_collisions;
  int n_repetitions;
  int i_repetition;
  double lvel;
  double rvel;
  double previous_x;
  double previous_y;
  double previous_z;
  ViewService *view;
};

//MobileController::MobileController() {}
//MobileController::~MobileController() {}

void MobileController::onInit(InitEvent &evt) {
  time_step = 0.0; //0.5;
  max_velocity = 10.0;
  me = getRobotObj(myname());
  n_collisions = 0;
  n_repetitions = 1; //50;
  i_repetition = 0;
  lvel = 0.0;
  rvel = 0.0;

  view = (ViewService*)connectToService("SIGViewer");

  srand(0); //srand(time(NULL));

  double radius = 8.0;
	double distance = 24.0;
	me->setWheel(radius, distance);
  me->setWheelVelocity(0.0, 0.0);
}

double MobileController::onAction(ActionEvent &evt) {
  /* */
  Vector3d position;
  me->getPosition(position);
  previous_x = position.x();
  previous_y = position.y();
  previous_z = position.z();
  /* */
  /*
  previous_x = me->x();
  previous_y = me->y();
  previous_z = me->z();
  */
  std::cout << previous_x << " " << previous_y << " " << previous_z << std::endl;

  //
  static int count = 0;
  if (++count % 10 == 0) {
    Action action = random_action();
    switch (action) {
      case NOTHING:                                                         break;
      case FORWARD: lvel =  max_velocity;       rvel =  max_velocity;       break;
      case BACK:    lvel = -max_velocity;       rvel = -max_velocity;       break;
      case LEFT:    lvel =  0.1 * max_velocity; rvel =  max_velocity;       break;
      case RIGHT:   lvel =  max_velocity;       rvel =  0.1 * max_velocity; break;
      default:
        std::cout << std::cout << "unknown action number " << action << "..." << std::endl;
        std::cout << "do nothing" << std::endl;
        break;
    }
  }
  //

  me->setWheelVelocity(lvel, rvel);
  //ViewImage* img = view->captureView(1, COLORBIT_24, IMAGE_320X240);
  //char* buf = img->getBuffer();

  return time_step;
}

void MobileController::onCollision(CollisionEvent &evt) {
  const std::vector<std::string>& objects_collided = evt.getWith();
  for (size_t i_object = 0; i_object < objects_collided.size(); ++i_object) {
    const std::string& object_name = objects_collided[i_object];
    std::cout << n_collisions << " collision with " << object_name << std::endl;
    if (object_name.substr(0, 6) == "target") {
      std::cout << "target reached!" << std::endl;
    }
    else {
      // walls or blocks
      lvel = 0.0;
      rvel = 0.0;
      me->setPosition(previous_x, previous_y, previous_z);
    }
  }
}

void MobileController::onRecvMsg(RecvMsgEvent &evt) {}

extern "C" Controller * createController() {
  return new MobileController;
}

