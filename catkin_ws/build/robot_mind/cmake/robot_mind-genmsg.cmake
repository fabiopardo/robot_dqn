# generated from genmsg/cmake/pkg-genmsg.cmake.em

message(STATUS "robot_mind: 0 messages, 1 services")

set(MSG_I_FLAGS "-Istd_msgs:/opt/ros/jade/share/std_msgs/cmake/../msg")

# Find all generators
find_package(gencpp REQUIRED)
find_package(geneus REQUIRED)
find_package(genlisp REQUIRED)
find_package(genpy REQUIRED)

add_custom_target(robot_mind_generate_messages ALL)

# verify that message/service dependencies have not changed since configure



get_filename_component(_filename "/home/fabio/catkin_ws/src/robot_mind/srv/NextTargetLocation.srv" NAME_WE)
add_custom_target(_robot_mind_generate_messages_check_deps_${_filename}
  COMMAND ${CATKIN_ENV} ${PYTHON_EXECUTABLE} ${GENMSG_CHECK_DEPS_SCRIPT} "robot_mind" "/home/fabio/catkin_ws/src/robot_mind/srv/NextTargetLocation.srv" ""
)

#
#  langs = gencpp;geneus;genlisp;genpy
#

### Section generating for lang: gencpp
### Generating Messages

### Generating Services
_generate_srv_cpp(robot_mind
  "/home/fabio/catkin_ws/src/robot_mind/srv/NextTargetLocation.srv"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/robot_mind
)

### Generating Module File
_generate_module_cpp(robot_mind
  ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/robot_mind
  "${ALL_GEN_OUTPUT_FILES_cpp}"
)

add_custom_target(robot_mind_generate_messages_cpp
  DEPENDS ${ALL_GEN_OUTPUT_FILES_cpp}
)
add_dependencies(robot_mind_generate_messages robot_mind_generate_messages_cpp)

# add dependencies to all check dependencies targets
get_filename_component(_filename "/home/fabio/catkin_ws/src/robot_mind/srv/NextTargetLocation.srv" NAME_WE)
add_dependencies(robot_mind_generate_messages_cpp _robot_mind_generate_messages_check_deps_${_filename})

# target for backward compatibility
add_custom_target(robot_mind_gencpp)
add_dependencies(robot_mind_gencpp robot_mind_generate_messages_cpp)

# register target for catkin_package(EXPORTED_TARGETS)
list(APPEND ${PROJECT_NAME}_EXPORTED_TARGETS robot_mind_generate_messages_cpp)

### Section generating for lang: geneus
### Generating Messages

### Generating Services
_generate_srv_eus(robot_mind
  "/home/fabio/catkin_ws/src/robot_mind/srv/NextTargetLocation.srv"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${geneus_INSTALL_DIR}/robot_mind
)

### Generating Module File
_generate_module_eus(robot_mind
  ${CATKIN_DEVEL_PREFIX}/${geneus_INSTALL_DIR}/robot_mind
  "${ALL_GEN_OUTPUT_FILES_eus}"
)

add_custom_target(robot_mind_generate_messages_eus
  DEPENDS ${ALL_GEN_OUTPUT_FILES_eus}
)
add_dependencies(robot_mind_generate_messages robot_mind_generate_messages_eus)

# add dependencies to all check dependencies targets
get_filename_component(_filename "/home/fabio/catkin_ws/src/robot_mind/srv/NextTargetLocation.srv" NAME_WE)
add_dependencies(robot_mind_generate_messages_eus _robot_mind_generate_messages_check_deps_${_filename})

# target for backward compatibility
add_custom_target(robot_mind_geneus)
add_dependencies(robot_mind_geneus robot_mind_generate_messages_eus)

# register target for catkin_package(EXPORTED_TARGETS)
list(APPEND ${PROJECT_NAME}_EXPORTED_TARGETS robot_mind_generate_messages_eus)

### Section generating for lang: genlisp
### Generating Messages

### Generating Services
_generate_srv_lisp(robot_mind
  "/home/fabio/catkin_ws/src/robot_mind/srv/NextTargetLocation.srv"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/robot_mind
)

### Generating Module File
_generate_module_lisp(robot_mind
  ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/robot_mind
  "${ALL_GEN_OUTPUT_FILES_lisp}"
)

add_custom_target(robot_mind_generate_messages_lisp
  DEPENDS ${ALL_GEN_OUTPUT_FILES_lisp}
)
add_dependencies(robot_mind_generate_messages robot_mind_generate_messages_lisp)

# add dependencies to all check dependencies targets
get_filename_component(_filename "/home/fabio/catkin_ws/src/robot_mind/srv/NextTargetLocation.srv" NAME_WE)
add_dependencies(robot_mind_generate_messages_lisp _robot_mind_generate_messages_check_deps_${_filename})

# target for backward compatibility
add_custom_target(robot_mind_genlisp)
add_dependencies(robot_mind_genlisp robot_mind_generate_messages_lisp)

# register target for catkin_package(EXPORTED_TARGETS)
list(APPEND ${PROJECT_NAME}_EXPORTED_TARGETS robot_mind_generate_messages_lisp)

### Section generating for lang: genpy
### Generating Messages

### Generating Services
_generate_srv_py(robot_mind
  "/home/fabio/catkin_ws/src/robot_mind/srv/NextTargetLocation.srv"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/robot_mind
)

### Generating Module File
_generate_module_py(robot_mind
  ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/robot_mind
  "${ALL_GEN_OUTPUT_FILES_py}"
)

add_custom_target(robot_mind_generate_messages_py
  DEPENDS ${ALL_GEN_OUTPUT_FILES_py}
)
add_dependencies(robot_mind_generate_messages robot_mind_generate_messages_py)

# add dependencies to all check dependencies targets
get_filename_component(_filename "/home/fabio/catkin_ws/src/robot_mind/srv/NextTargetLocation.srv" NAME_WE)
add_dependencies(robot_mind_generate_messages_py _robot_mind_generate_messages_check_deps_${_filename})

# target for backward compatibility
add_custom_target(robot_mind_genpy)
add_dependencies(robot_mind_genpy robot_mind_generate_messages_py)

# register target for catkin_package(EXPORTED_TARGETS)
list(APPEND ${PROJECT_NAME}_EXPORTED_TARGETS robot_mind_generate_messages_py)



if(gencpp_INSTALL_DIR AND EXISTS ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/robot_mind)
  # install generated code
  install(
    DIRECTORY ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/robot_mind
    DESTINATION ${gencpp_INSTALL_DIR}
  )
endif()
add_dependencies(robot_mind_generate_messages_cpp std_msgs_generate_messages_cpp)

if(geneus_INSTALL_DIR AND EXISTS ${CATKIN_DEVEL_PREFIX}/${geneus_INSTALL_DIR}/robot_mind)
  # install generated code
  install(
    DIRECTORY ${CATKIN_DEVEL_PREFIX}/${geneus_INSTALL_DIR}/robot_mind
    DESTINATION ${geneus_INSTALL_DIR}
  )
endif()
add_dependencies(robot_mind_generate_messages_eus std_msgs_generate_messages_eus)

if(genlisp_INSTALL_DIR AND EXISTS ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/robot_mind)
  # install generated code
  install(
    DIRECTORY ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/robot_mind
    DESTINATION ${genlisp_INSTALL_DIR}
  )
endif()
add_dependencies(robot_mind_generate_messages_lisp std_msgs_generate_messages_lisp)

if(genpy_INSTALL_DIR AND EXISTS ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/robot_mind)
  install(CODE "execute_process(COMMAND \"/usr/bin/python\" -m compileall \"${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/robot_mind\")")
  # install generated code
  install(
    DIRECTORY ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/robot_mind
    DESTINATION ${genpy_INSTALL_DIR}
  )
endif()
add_dependencies(robot_mind_generate_messages_py std_msgs_generate_messages_py)
