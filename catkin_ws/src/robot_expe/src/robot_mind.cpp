#include <sstream>

#include "ros/ros.h"
#include "std_msgs/Int8.h"

#include "robot_mind.hpp"


int main(int argc, char **argv) {
  RobotMind robot_mind;
  robot_mind.run();
  std::cout << "here!" << std::endl;

  return 0;
}

