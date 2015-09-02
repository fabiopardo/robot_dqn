#include "ros/ros.h"
#include "robot_mind/NextTargetLocation.h"

bool give_next_target_location(robot_mind::NextTargetLocation::Response& req,
                               robot_mind::NextTargetLocation::Response& res) {
  static double last_y = 100.0;
  res.x = 100.0;
  res.y = last_y + 100.0;
  res.z = 100.0;
  last_y = res.y;
  
  ROS_INFO("request next target location");
  ROS_INFO("sending back response: [%f %f %f]", res.x, res.y, res.z);
  return true;
}

int main(int argc, char **argv) {
  ros::init(argc, argv, "next_target_srv");
  ros::NodeHandle n;

  ros::ServiceServer service = n.advertiseService("next_target_srv", give_next_target_location);
  ROS_INFO("Ready to give target location");
  ros::spin();

  return 0;
}

