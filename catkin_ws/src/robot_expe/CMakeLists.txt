cmake_minimum_required(VERSION 2.8.3)
project(robot_expe)

find_package(catkin REQUIRED COMPONENTS roscpp rospy std_msgs message_generation)

## System dependencies are found with CMake's conventions
# find_package(Boost REQUIRED COMPONENTS system)


## Uncomment this if the package has a setup.py. This macro ensures
## modules and global scripts declared therein get installed
## See http://ros.org/doc/groovy/api/catkin/html/user_guide/setup_dot_py.html
# catkin_python_setup()

#######################################
## Declare ROS messages and services ##
#######################################

## Generate messages in the 'msg' folder
#add_service_files(
#  FILES
#  NextTargetLocation.srv
#)

## Generate services in the 'srv' folder
# add_service_files(
#   FILES
#   AddTwoInts.srv
# )

## Generate added messages and services with any dependencies listed here
 generate_messages(
   DEPENDENCIES
   std_msgs
 )

###################################
## catkin specific configuration ##
###################################
## The catkin_package macro generates cmake config files for your package
## Declare things to be passed to dependent projects
## LIBRARIES: libraries you create in this project that dependent projects also need
## CATKIN_DEPENDS: catkin_packages dependent projects also need
## DEPENDS: system dependencies of this project that dependent projects also need
catkin_package(
#INCLUDE_DIRS include
  CATKIN_DEPENDS message_runtime
#  LIBRARIES beginner_tutorials
#  CATKIN_DEPENDS roscpp rospy std_msgs
#  DEPENDS system_lib
)

###########
## Build ##
###########

## Specify additional locations of header files
## Your package locations should be listed before other locations
include_directories(include
  ${catkin_INCLUDE_DIRS}
)
include_directories (/home/fabio/sigverse-2.3.1/include/sigverse /home/fabio/sigverse-2.3.1/include/sigverse/comm/controller )

#include_directories (${SIGVERSE_PATH}/include/sigverse /home/fabio/sigverse-2.3.1/include/sigverse/comm/controller )
## Declare a cpp library
# add_library(beginner_tutorials
#   src/${PROJECT_NAME}/beginner_tutorials.cpp
# )

## Declare a cpp executable
# add_executable(beginner_tutorials_node src/beginner_tutorials_node.cpp)

## Add cmake target dependencies of the executable/library
## as an example, message headers may need to be generated before nodes
# add_dependencies(beginner_tutorials_node beginner_tutorials_generate_messages_cpp)

## Specify libraries to link a library or executable target against
# target_link_libraries(beginner_tutorials_node
#   ${catkin_LIBRARIES}
# )

#############
## Install ##
#############

# all install targets should use catkin DESTINATION variables
# See http://ros.org/doc/groovy/api/catkin/html/adv_user_guide/variables.html

## Mark executable scripts (Python etc.) for installation
## in contrast to setup.py, you can choose the destination
# install(PROGRAMS
#   scripts/my_python_script
#   DESTINATION ${CATKIN_PACKAGE_BIN_DESTINATION}
# )

## Mark executables and/or libraries for installation
# install(TARGETS beginner_tutorials beginner_tutorials_node
#   ARCHIVE DESTINATION ${CATKIN_PACKAGE_LIB_DESTINATION}
#   LIBRARY DESTINATION ${CATKIN_PACKAGE_LIB_DESTINATION}
#   RUNTIME DESTINATION ${CATKIN_PACKAGE_BIN_DESTINATION}
# )

## Mark cpp header files for installation
# install(DIRECTORY include/${PROJECT_NAME}/
#   DESTINATION ${CATKIN_PACKAGE_INCLUDE_DESTINATION}
#   FILES_MATCHING PATTERN "*.h"
#   PATTERN ".svn" EXCLUDE
# )

## Mark other files for installation (e.g. launch and bag files, etc.)
# install(FILES
#   # myfile1
#   # myfile2
#   DESTINATION ${CATKIN_PACKAGE_SHARE_DESTINATION}
# )

#############
## Testing ##
#############

## Add gtest based cpp test target and link libraries
# catkin_add_gtest(${PROJECT_NAME}-test test/test_beginner_tutorials.cpp)
# if(TARGET ${PROJECT_NAME}-test)
#   target_link_libraries(${PROJECT_NAME}-test ${PROJECT_NAME})
# endif()

## Add folders to be run by python nosetests
# catkin_add_nosetests(test)

add_definitions(-DCONTROLLER -DNDEBUG -DUSE_ODE -DdDOUBLE)

## Build talker and listener
include_directories(include ${catkin_INCLUDE_DIRS})

#add_executable(robot_mind src/robot_mind.cpp)
#target_link_libraries(robot_mind ${catkin_LIBRARIES})
#add_dependencies(robot_mind robot_expe_gencpp)

add_library(robot_expe/robot_controller src/robot_controller.cpp)
target_link_libraries(robot_expe/robot_controller ${catkin_LIBRARIES})
add_dependencies(robot_expe/robot_controller robot_expe_gencpp)

add_library(robot_expe/target_controller src/target_controller.cpp)
target_link_libraries(robot_expe/target_controller ${catkin_LIBRARIES})
add_dependencies(robot_expe/target_controller robot_expe_gencpp)

add_executable(next_target_srv src/next_target_srv.cpp)
target_link_libraries(next_target_srv ${catkin_LIBRARIES})
add_dependencies(next_target_srv robot_expe_gencpp)

add_library(robot_expe/robot_mind_wrap src/robot_mind_wrap.cpp)
target_link_libraries(robot_expe/robot_mind_wrap ${catkin_LIBRARIES})
add_dependencies(robot_expe/robot_mind_wrap robot_expe_gencpp)

