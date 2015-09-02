#ifndef ROBOT_MIND_H
#define ROBOT_MIND_H

#include <sstream>
#include <vector>

#include "ros/ros.h"
#include "std_msgs/Int8.h"
#include "std_msgs/Int32.h"
#include "sensor_msgs/Image.h"


class RobotMind {
 public:
  RobotMind(int hist_len);
  ~RobotMind();
  void get_images(uint8_t* dst);
  void act(int action);
  void camera_callback(const sensor_msgs::Image& image_msg);
  void reward_callback(const std_msgs::Int32& new_reward);
  int get_reward();
 private:
  ros::Publisher actions_publisher;
  ros::Subscriber camera_subscriber;
  ros::Subscriber reward_subscriber;
  int n_images_queued;
  int n_rewards_queued;
  size_t n_char_image;
  uint8_t* array_to_fill;
  std::vector<uint8_t> last_image;
  bool new_image_found;
  int reward;
};

RobotMind::RobotMind(int hist_len) {
  n_images_queued = 1;
  n_rewards_queued = 1;

  int argc = 0;
  char** argv = 0;
  ros::init(argc, argv, "robot_mind");
  ros::NodeHandle n;
  actions_publisher = n.advertise<std_msgs::Int8>("actions_stream", 1);
  camera_subscriber = n.subscribe("camera_stream", n_images_queued, &RobotMind::camera_callback, this);
  reward_subscriber = n.subscribe("rewards_stream", n_rewards_queued, &RobotMind::reward_callback, this);

  n_char_image = 230400; // 320 * 240 * 3 = 230400
  reward = 0;

  last_image = std::vector<uint8_t>(n_char_image, 0);
}

RobotMind::~RobotMind() {}

void RobotMind::get_images(uint8_t* dst) {
  array_to_fill = dst;
  new_image_found = false;
  ros::spinOnce(); // dequeue images
  if (not new_image_found) {
    std::cout << "no new image... use the last one" << std::endl;
    std::copy(last_image.begin(), last_image.begin() + n_char_image, array_to_fill);
  }
}

void RobotMind::act(int action) {
  std_msgs::Int8 action_msg;
  action_msg.data = action;
  actions_publisher.publish(action_msg);
}

// TODO better (for example the reward disapears with time like activation in brain)
int RobotMind::get_reward() {
  int last_reward = reward;
  reward = 0;
  return last_reward;
}

void RobotMind::camera_callback(const sensor_msgs::Image& image_msg) {
  std::copy(image_msg.data.begin(), image_msg.data.begin() + n_char_image, array_to_fill);
  std::copy(image_msg.data.begin(), image_msg.data.begin() + n_char_image, last_image.begin());
  new_image_found = true;
}

void RobotMind::reward_callback(const std_msgs::Int32& new_reward) {
  reward += new_reward.data;
  //std::cout << "$$$ reward " << new_reward.data << " dequeued" << std::endl;
}

#endif // ROBOT_MIND_H

