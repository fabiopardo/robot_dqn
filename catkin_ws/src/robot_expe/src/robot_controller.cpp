#include <stdexcept>

#include <sys/time.h>
#include <stdio.h>
#include <unistd.h>

#include <Controller.h>
#include <ControllerEvent.h>
#include <Logger.h>
#include <ViewImage.h>

#include "ros/ros.h"
#include "std_msgs/Int8.h"
#include "std_msgs/Int32.h"
#include "sensor_msgs/Image.h"


enum Action { STOP, FORWARD, BACK, LEFT, RIGHT,
              // last element to get the size of the enum
              N_ACTIONS, NOTHING };

class RobotController : public Controller {
public:
  void onInit(InitEvent &evt);
  double onAction(ActionEvent&);
  void onRecvMsg(RecvMsgEvent &evt);
  //void onCollision(CollisionEvent &evt);
  void actionCallback(const std_msgs::Int8& action);

private:
  double time_step;
  double max_velocity; // rad/s
  //SimObj* me_obj;
  int n_collisions;
  int n_repetitions;
  int i_repetition;
  double lvel;
  double rvel;
  Vector3d previous_position;
  Rotation previous_rotation;
  ViewService *view;

  // ros
  ros::Subscriber actions_subscriber;
  ros::Publisher  images_publisher;
  ros::Publisher  rewards_publisher;

  Action action;
  std::vector<CParts*> all_robot_parts;

  RobotObj* me;
  CParts* main_parts;
  SimObj* target;
  CParts* target_parts;
  std::vector<Vector3d> possible_target_locations;
  size_t i_target_location;

  ///
  int tmp_cnt;
  struct timeval previous_time;
};

void RobotController::actionCallback(const std_msgs::Int8& action_msg) {
  if (action_msg.data < 0 || action_msg.data >= N_ACTIONS) action = NOTHING;
  else action = static_cast<Action>(action_msg.data);
  ///
  tmp_cnt = 1;
}

void RobotController::onInit(InitEvent &evt) {
  int argc = 0;
  char** argv = NULL;
  ros::init(argc, argv, "robot_controller");
  ros::NodeHandle node_handle;
  actions_subscriber = node_handle.subscribe("actions_stream", 1, &RobotController::actionCallback, this);
  images_publisher = node_handle.advertise<sensor_msgs::Image>("camera_stream", 1);
  rewards_publisher = node_handle.advertise<std_msgs::Int32>("rewards_stream", 1);

  time_step = 0.0;
  max_velocity = 30.0;
  me = getRobotObj(myname());
  //me_obj = getObj(myname());
  n_collisions = 0;
  n_repetitions = 1;
  i_repetition = 0;
  lvel = 0.0;
  rvel = 0.0;
  action = STOP;

  view = (ViewService*)connectToService("SIGViewer");

  srand(0); //srand(time(NULL));

  double radius = 8.0;
	double distance = 24.0;
	me->setWheel(radius, distance);
  me->setWheelVelocity(0.0, 0.0);

  std::map<std::string, CParts *>& broken_map = me->getPartsCollection(); // keys are ok but not values...
  for (std::map<std::string, CParts *>::iterator it_pair = broken_map.begin(); it_pair != broken_map.end(); ++it_pair) {
    all_robot_parts.push_back(me->getParts(it_pair->first.c_str()));
  }
  main_parts = me->getParts("LINK_CENTER");

  target = getObj("target");
  target_parts = target->getMainParts();
  
  double y_target = 40.05;

  possible_target_locations.push_back(Vector3d(-70.0, y_target, -70.0));
  possible_target_locations.push_back(Vector3d( 70.0, y_target, -70.0));
  possible_target_locations.push_back(Vector3d(-70.0, y_target,  70.0));
  possible_target_locations.push_back(Vector3d( 70.0, y_target,  70.0));

  //possible_target_locations.push_back(Vector3d(120.0, y_target, 250.0));
  //possible_target_locations.push_back(Vector3d(-250.0, y_target, -10.0));
  /*
  possible_target_locations.push_back(Vector3d(-400.0, y_target, -400.0));
  possible_target_locations.push_back(Vector3d(-300.0, y_target, -400.0));
  possible_target_locations.push_back(Vector3d(-200.0, y_target, -400.0));
  possible_target_locations.push_back(Vector3d(-100.0, y_target, -400.0));
  possible_target_locations.push_back(Vector3d(0.0, y_target, -400.0));
  possible_target_locations.push_back(Vector3d(100.0, y_target, -400.0));
  possible_target_locations.push_back(Vector3d(200.0, y_target, -400.0));
  possible_target_locations.push_back(Vector3d(300.0, y_target, -400.0));
  possible_target_locations.push_back(Vector3d(400.0, y_target, -400.0));
  possible_target_locations.push_back(Vector3d(-400.0, y_target, -300.0));
  possible_target_locations.push_back(Vector3d(-300.0, y_target, -300.0));
  possible_target_locations.push_back(Vector3d(-200.0, y_target, -300.0));
  possible_target_locations.push_back(Vector3d(-100.0, y_target, -300.0));
  possible_target_locations.push_back(Vector3d(100.0, y_target, -300.0));
  possible_target_locations.push_back(Vector3d(200.0, y_target, -300.0));
  possible_target_locations.push_back(Vector3d(300.0, y_target, -300.0));
  possible_target_locations.push_back(Vector3d(400.0, y_target, -300.0));
  possible_target_locations.push_back(Vector3d(-400.0, y_target, -200.0));
  possible_target_locations.push_back(Vector3d(-300.0, y_target, -200.0));
  possible_target_locations.push_back(Vector3d(-100.0, y_target, -200.0));
  possible_target_locations.push_back(Vector3d(0.0, y_target, -200.0));
  possible_target_locations.push_back(Vector3d(100.0, y_target, -200.0));
  possible_target_locations.push_back(Vector3d(200.0, y_target, -200.0));
  possible_target_locations.push_back(Vector3d(300.0, y_target, -200.0));
  possible_target_locations.push_back(Vector3d(400.0, y_target, -200.0));
  possible_target_locations.push_back(Vector3d(-400.0, y_target, -100.0));
  possible_target_locations.push_back(Vector3d(-300.0, y_target, -100.0));
  possible_target_locations.push_back(Vector3d(-200.0, y_target, -100.0));
  possible_target_locations.push_back(Vector3d(-100.0, y_target, -100.0));
  possible_target_locations.push_back(Vector3d(0.0, y_target, -100.0));
  possible_target_locations.push_back(Vector3d(100.0, y_target, -100.0));
  possible_target_locations.push_back(Vector3d(200.0, y_target, -100.0));
  possible_target_locations.push_back(Vector3d(400.0, y_target, -100.0));
  possible_target_locations.push_back(Vector3d(-400.0, y_target, 0.0));
  possible_target_locations.push_back(Vector3d(-300.0, y_target, 0.0));
  possible_target_locations.push_back(Vector3d(-200.0, y_target, 0.0));
  possible_target_locations.push_back(Vector3d(-100.0, y_target, 0.0));
  possible_target_locations.push_back(Vector3d(100.0, y_target, 0.0));
  possible_target_locations.push_back(Vector3d(200.0, y_target, 0.0));
  possible_target_locations.push_back(Vector3d(300.0, y_target, 0.0));
  possible_target_locations.push_back(Vector3d(400.0, y_target, 0.0));
  possible_target_locations.push_back(Vector3d(-400.0, y_target, 400.0));
  possible_target_locations.push_back(Vector3d(-300.0, y_target, 400.0));
  possible_target_locations.push_back(Vector3d(-200.0, y_target, 400.0));
  possible_target_locations.push_back(Vector3d(-100.0, y_target, 400.0));
  possible_target_locations.push_back(Vector3d(0.0, y_target, 400.0));
  possible_target_locations.push_back(Vector3d(100.0, y_target, 400.0));
  possible_target_locations.push_back(Vector3d(200.0, y_target, 400.0));
  possible_target_locations.push_back(Vector3d(300.0, y_target, 400.0));
  possible_target_locations.push_back(Vector3d(400.0, y_target, 400.0));
  possible_target_locations.push_back(Vector3d(-400.0, y_target, 300.0));
  possible_target_locations.push_back(Vector3d(-300.0, y_target, 300.0));
  possible_target_locations.push_back(Vector3d(-200.0, y_target, 300.0));
  possible_target_locations.push_back(Vector3d(-100.0, y_target, 300.0));
  possible_target_locations.push_back(Vector3d(100.0, y_target, 300.0));
  possible_target_locations.push_back(Vector3d(200.0, y_target, 300.0));
  possible_target_locations.push_back(Vector3d(300.0, y_target, 300.0));
  possible_target_locations.push_back(Vector3d(400.0, y_target, 300.0));
  possible_target_locations.push_back(Vector3d(-400.0, y_target, 200.0));
  possible_target_locations.push_back(Vector3d(-300.0, y_target, 200.0));
  possible_target_locations.push_back(Vector3d(-200.0, y_target, 200.0));
  possible_target_locations.push_back(Vector3d(-100.0, y_target, 200.0));
  possible_target_locations.push_back(Vector3d(0.0, y_target, 200.0));
  possible_target_locations.push_back(Vector3d(100.0, y_target, 200.0));
  possible_target_locations.push_back(Vector3d(300.0, y_target, 200.0));
  possible_target_locations.push_back(Vector3d(400.0, y_target, 200.0));
  possible_target_locations.push_back(Vector3d(-400.0, y_target, 100.0));
  possible_target_locations.push_back(Vector3d(-200.0, y_target, 100.0));
  possible_target_locations.push_back(Vector3d(-100.0, y_target, 100.0));
  possible_target_locations.push_back(Vector3d(0.0, y_target, 100.0));
  possible_target_locations.push_back(Vector3d(100.0, y_target, 100.0));
  possible_target_locations.push_back(Vector3d(200.0, y_target, 100.0));
  possible_target_locations.push_back(Vector3d(300.0, y_target, 100.0));
  possible_target_locations.push_back(Vector3d(400.0, y_target, 100.0));
  */

  i_target_location = rand() % possible_target_locations.size();
  std::cout << "target is at location #" << i_target_location << std::endl;
  target->setPosition(possible_target_locations[i_target_location]);

  std::cout << "init ok!" << std::endl;

  ///
  tmp_cnt = 0;
}

double RobotController::onAction(ActionEvent &evt) {
  static int count = 0;
  static bool collision_happened_before = false;

  // CHECK MESSAGES

  ros::spinOnce();

  // MOVE

  if (tmp_cnt <= 0) {
    lvel = 0;
    rvel = 0;
    me->setWheelVelocity(lvel, rvel);
    std::cout << "stop" << std::endl;
  }
  else
    std::cout << "continue" << std::endl;
  
  if (action != NOTHING) {
    //std::cout << "action: ";
    switch (action) {
      case STOP:    lvel =  0.0;                rvel = 0.0;                 /*std::cout << "stop" << std::endl;*/     break;
      case FORWARD: lvel =  max_velocity;       rvel =  max_velocity;       /*std::cout << "forward" << std::endl;*/  break;
      case BACK:    lvel = -max_velocity;       rvel = -max_velocity;       /*std::cout << "back" << std::endl;*/     break;
      case LEFT:    lvel = -0.3 * max_velocity; rvel =  0.3 * max_velocity; /*std::cout << "left" << std::endl;*/     break;
      case RIGHT:   lvel =  0.3 * max_velocity; rvel = -0.3 * max_velocity; /*std::cout << "right" << std::endl;*/    break;
      default:      std::cout << "ERROR wrong action!" << std::endl;                                              break;
    }
    me->setWheelVelocity(lvel, rvel);                                       // 10 ms
    action = NOTHING;
  }

  // GET IMAGE, POSITION AND ROTATION

  // save before checking collisions because otherwise we have problems!
  // the robot continues to move while collisions are checked
  ViewImage* image = view->captureView(1, COLORBIT_24, IMAGE_320X240);      // +? ms
  char* buffer = image->getBuffer();
  Vector3d temp_position;
  Rotation temp_rotation;
  me->getPosition(temp_position);                                           // +10 ms
  me->getRotation(temp_rotation);                                           // +10 ms
  //std::cout << "temp position, temp rotation, and image saved" << std::endl;

  //std::cout << "z position: " << temp_position.z() << std::endl;

  // CHECK COLLISION

  bool collision = false;
  bool target_reached = target_parts->getCollisionState();                    // +10 ms
  if (target_reached) {
    std_msgs::Int32 reward_msg;
    reward_msg.data = 1;
    rewards_publisher.publish(reward_msg);
    // problems with collision detection so stop even if it's a target
    lvel = 0.0;
    rvel = 0.0;
    me->setWheelVelocity(lvel, rvel);                                     // +10 ms
    std::cout << "set velocity to 0" << std::endl;

    size_t temp_i_location;
    do {
      temp_i_location = rand() % possible_target_locations.size();
    }
    while (temp_i_location == i_target_location);
    i_target_location = temp_i_location;
    std::cout << "target reached, jump to location #" << i_target_location << std::endl;
    target->setPosition(possible_target_locations[i_target_location]);
    
    collision = true; // otherwise, if target and wall at the same time we can have a problem
  }
  else {
    collision = main_parts->getCollisionState();                              // +10 ms
  }

  /*
  bool collision = false;
  for (int i = 0; i < all_robot_parts.size(); ++i) {
    collision = all_robot_parts[i]->getCollisionState();
    if (collision) break;
  }
  */

  // IF COLLISION GO BACK
  
  if (collision) {
    //std::cout << "COLLISION!" << std::endl;
    if (lvel != 0.0 or rvel != 0.0) {
      lvel = 0.0;
      rvel = 0.0;
      me->setWheelVelocity(lvel, rvel);                                     // +10 ms
      //std::cout << "set velocity to 0" << std::endl;
      collision_happened_before = true;
    }

    me->setPosition(previous_position);                                     // +10 ms
    me->setRotation(previous_rotation);                                     // +10 ms
    //std::cout << "set position and rotation to previous values (#" << count << ")" << std::endl;
    //std::cout << "back to z position: " << previous_position.z() << std::endl;
  }

  // ELSE SEND IMAGE

  else {
    //std::cout << "no collision" << std::endl;
    if (collision_happened_before) {
      //std::cout << "but collision just before so do nothing..." << std::endl;
      collision_happened_before = false;
    }
    else {
      // save position and rotation
      previous_position = Vector3d(temp_position);
      previous_rotation = Rotation(temp_rotation);

      // send image
      sensor_msgs::Image image_msg;
      image_msg.height = image->getHeight();
      image_msg.width = image->getWidth();
      image_msg.encoding = "bgr8";
      image_msg.is_bigendian = false;
      image_msg.step = image_msg.width * 3;
      image_msg.data = std::vector<unsigned char>(buffer, buffer + 230400); // 320 * 240 * 3

      images_publisher.publish(image_msg);
      ++count;
      //std::cout << "position and rotation saved (#" << count << "), and image sent" << std::endl;
    }
  }

  delete image; // otherwise memory leak!

  //std::cout << "-------------" << std::endl;
  

  ///
  --tmp_cnt;

  struct timeval current_time;
	gettimeofday(&current_time, NULL);
  double loop_time = (current_time.tv_sec - previous_time.tv_sec) * 1000 + (current_time.tv_usec - previous_time.tv_usec) / 1000.0;
  previous_time = current_time;
  std::cout << "loop time: " << loop_time << " ms" << std::endl;

  return time_step;
}

//void RobotController::onCollision(CollisionEvent &evt) {}

void RobotController::onRecvMsg(RecvMsgEvent &evt) {}

extern "C" Controller * createController() {
  return new RobotController;
}

