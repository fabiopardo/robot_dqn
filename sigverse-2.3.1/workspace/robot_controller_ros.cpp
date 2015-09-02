#include <stdexcept>

#include <Controller.h>
#include <ControllerEvent.h>
#include <Logger.h>
#include <ViewImage.h>

#include "ros/ros.h"
#include "std_msgs/Int8.h"


enum Action { NOTHING, FORWARD, BACK, LEFT, RIGHT,
              // last element to get the size of the enum
              N_ACTIONS };

class RobotController : public Controller {
public:
  void onInit(InitEvent &evt);
  double onAction(ActionEvent&);
  void onRecvMsg(RecvMsgEvent &evt);
  void onCollision(CollisionEvent &evt);
  void actionCallback(const std_msgs::Int8& action);

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

  // ros
  ros::Subscriber actions_subscriber;
};

void RobotController::actionCallback(const std_msgs::Int8& action_msg) {
  const char action = action_msg.data;
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

void RobotController::onInit(InitEvent &evt) {
  int argc = 0;
  char** argv = NULL;
  ros::init(argc, argv, "robot_controller");
  ros::NodeHandle node_handle;
  actions_subscriber = node_handle.subscribe
    ("actions_stream", 100, &RobotController::actionCallback, this);

  time_step = 0.0;
  max_velocity = 10.0;
  me = getRobotObj(myname());
  n_collisions = 0;
  n_repetitions = 1;
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

double RobotController::onAction(ActionEvent &evt) {
  me->setWheelVelocity(lvel, rvel);

  return time_step;
}

void RobotController::onCollision(CollisionEvent &evt) {
  const std::vector<std::string>& objects_collided = evt.getWith();
  for (size_t i_object = 0; i_object < objects_collided.size(); ++i_object) {
    const std::string& object_name = objects_collided[i_object];
    std::cout << n_collisions << " collision with " << object_name << std::endl;
    if (object_name.substr(0, 6) == "target") {
      std::cout << "target reached!" << std::endl;
    }
    else {
      // walls or blocks
    }
  }
}

void RobotController::onRecvMsg(RecvMsgEvent &evt) {}

extern "C" Controller * createController() {
  return new RobotController;
}

