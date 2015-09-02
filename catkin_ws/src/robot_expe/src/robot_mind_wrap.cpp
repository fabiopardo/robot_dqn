#include <stdexcept>
#include <cassert>
#include <algorithm>

#include "robot_mind_wrap.hpp"


RobotMind *robot_mind_new(int hist_len) {
  return new RobotMind(hist_len);
}

void robot_mind_gc(RobotMind *robot_mind) {
  delete robot_mind;
}

void robot_mind_get_images(RobotMind *robot_mind, uint8_t* dst) {
  robot_mind->get_images(dst);
}

void robot_mind_act(RobotMind *robot_mind, int action) {
  robot_mind->act(action);
}

int robot_mind_get_reward(RobotMind *robot_mind) {
  return robot_mind->get_reward();
}


