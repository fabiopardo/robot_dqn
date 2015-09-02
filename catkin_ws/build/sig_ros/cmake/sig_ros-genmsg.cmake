# generated from genmsg/cmake/pkg-genmsg.cmake.em

message(STATUS "sig_ros: 1 messages, 0 services")

set(MSG_I_FLAGS "-Isig_ros:/home/fabio/catkin_ws/src/sig_ros/msg;-Istd_msgs:/opt/ros/jade/share/std_msgs/cmake/../msg")

# Find all generators
find_package(gencpp REQUIRED)
find_package(geneus REQUIRED)
find_package(genlisp REQUIRED)
find_package(genpy REQUIRED)

add_custom_target(sig_ros_generate_messages ALL)

# verify that message/service dependencies have not changed since configure



get_filename_component(_filename "/home/fabio/catkin_ws/src/sig_ros/msg/Velocity.msg" NAME_WE)
add_custom_target(_sig_ros_generate_messages_check_deps_${_filename}
  COMMAND ${CATKIN_ENV} ${PYTHON_EXECUTABLE} ${GENMSG_CHECK_DEPS_SCRIPT} "sig_ros" "/home/fabio/catkin_ws/src/sig_ros/msg/Velocity.msg" ""
)

#
#  langs = gencpp;geneus;genlisp;genpy
#

### Section generating for lang: gencpp
### Generating Messages
_generate_msg_cpp(sig_ros
  "/home/fabio/catkin_ws/src/sig_ros/msg/Velocity.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/sig_ros
)

### Generating Services

### Generating Module File
_generate_module_cpp(sig_ros
  ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/sig_ros
  "${ALL_GEN_OUTPUT_FILES_cpp}"
)

add_custom_target(sig_ros_generate_messages_cpp
  DEPENDS ${ALL_GEN_OUTPUT_FILES_cpp}
)
add_dependencies(sig_ros_generate_messages sig_ros_generate_messages_cpp)

# add dependencies to all check dependencies targets
get_filename_component(_filename "/home/fabio/catkin_ws/src/sig_ros/msg/Velocity.msg" NAME_WE)
add_dependencies(sig_ros_generate_messages_cpp _sig_ros_generate_messages_check_deps_${_filename})

# target for backward compatibility
add_custom_target(sig_ros_gencpp)
add_dependencies(sig_ros_gencpp sig_ros_generate_messages_cpp)

# register target for catkin_package(EXPORTED_TARGETS)
list(APPEND ${PROJECT_NAME}_EXPORTED_TARGETS sig_ros_generate_messages_cpp)

### Section generating for lang: geneus
### Generating Messages
_generate_msg_eus(sig_ros
  "/home/fabio/catkin_ws/src/sig_ros/msg/Velocity.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${geneus_INSTALL_DIR}/sig_ros
)

### Generating Services

### Generating Module File
_generate_module_eus(sig_ros
  ${CATKIN_DEVEL_PREFIX}/${geneus_INSTALL_DIR}/sig_ros
  "${ALL_GEN_OUTPUT_FILES_eus}"
)

add_custom_target(sig_ros_generate_messages_eus
  DEPENDS ${ALL_GEN_OUTPUT_FILES_eus}
)
add_dependencies(sig_ros_generate_messages sig_ros_generate_messages_eus)

# add dependencies to all check dependencies targets
get_filename_component(_filename "/home/fabio/catkin_ws/src/sig_ros/msg/Velocity.msg" NAME_WE)
add_dependencies(sig_ros_generate_messages_eus _sig_ros_generate_messages_check_deps_${_filename})

# target for backward compatibility
add_custom_target(sig_ros_geneus)
add_dependencies(sig_ros_geneus sig_ros_generate_messages_eus)

# register target for catkin_package(EXPORTED_TARGETS)
list(APPEND ${PROJECT_NAME}_EXPORTED_TARGETS sig_ros_generate_messages_eus)

### Section generating for lang: genlisp
### Generating Messages
_generate_msg_lisp(sig_ros
  "/home/fabio/catkin_ws/src/sig_ros/msg/Velocity.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/sig_ros
)

### Generating Services

### Generating Module File
_generate_module_lisp(sig_ros
  ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/sig_ros
  "${ALL_GEN_OUTPUT_FILES_lisp}"
)

add_custom_target(sig_ros_generate_messages_lisp
  DEPENDS ${ALL_GEN_OUTPUT_FILES_lisp}
)
add_dependencies(sig_ros_generate_messages sig_ros_generate_messages_lisp)

# add dependencies to all check dependencies targets
get_filename_component(_filename "/home/fabio/catkin_ws/src/sig_ros/msg/Velocity.msg" NAME_WE)
add_dependencies(sig_ros_generate_messages_lisp _sig_ros_generate_messages_check_deps_${_filename})

# target for backward compatibility
add_custom_target(sig_ros_genlisp)
add_dependencies(sig_ros_genlisp sig_ros_generate_messages_lisp)

# register target for catkin_package(EXPORTED_TARGETS)
list(APPEND ${PROJECT_NAME}_EXPORTED_TARGETS sig_ros_generate_messages_lisp)

### Section generating for lang: genpy
### Generating Messages
_generate_msg_py(sig_ros
  "/home/fabio/catkin_ws/src/sig_ros/msg/Velocity.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/sig_ros
)

### Generating Services

### Generating Module File
_generate_module_py(sig_ros
  ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/sig_ros
  "${ALL_GEN_OUTPUT_FILES_py}"
)

add_custom_target(sig_ros_generate_messages_py
  DEPENDS ${ALL_GEN_OUTPUT_FILES_py}
)
add_dependencies(sig_ros_generate_messages sig_ros_generate_messages_py)

# add dependencies to all check dependencies targets
get_filename_component(_filename "/home/fabio/catkin_ws/src/sig_ros/msg/Velocity.msg" NAME_WE)
add_dependencies(sig_ros_generate_messages_py _sig_ros_generate_messages_check_deps_${_filename})

# target for backward compatibility
add_custom_target(sig_ros_genpy)
add_dependencies(sig_ros_genpy sig_ros_generate_messages_py)

# register target for catkin_package(EXPORTED_TARGETS)
list(APPEND ${PROJECT_NAME}_EXPORTED_TARGETS sig_ros_generate_messages_py)



if(gencpp_INSTALL_DIR AND EXISTS ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/sig_ros)
  # install generated code
  install(
    DIRECTORY ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/sig_ros
    DESTINATION ${gencpp_INSTALL_DIR}
  )
endif()
add_dependencies(sig_ros_generate_messages_cpp std_msgs_generate_messages_cpp)

if(geneus_INSTALL_DIR AND EXISTS ${CATKIN_DEVEL_PREFIX}/${geneus_INSTALL_DIR}/sig_ros)
  # install generated code
  install(
    DIRECTORY ${CATKIN_DEVEL_PREFIX}/${geneus_INSTALL_DIR}/sig_ros
    DESTINATION ${geneus_INSTALL_DIR}
  )
endif()
add_dependencies(sig_ros_generate_messages_eus std_msgs_generate_messages_eus)

if(genlisp_INSTALL_DIR AND EXISTS ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/sig_ros)
  # install generated code
  install(
    DIRECTORY ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/sig_ros
    DESTINATION ${genlisp_INSTALL_DIR}
  )
endif()
add_dependencies(sig_ros_generate_messages_lisp std_msgs_generate_messages_lisp)

if(genpy_INSTALL_DIR AND EXISTS ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/sig_ros)
  install(CODE "execute_process(COMMAND \"/usr/bin/python\" -m compileall \"${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/sig_ros\")")
  # install generated code
  install(
    DIRECTORY ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/sig_ros
    DESTINATION ${genpy_INSTALL_DIR}
  )
endif()
add_dependencies(sig_ros_generate_messages_py std_msgs_generate_messages_py)
