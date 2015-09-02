# generated from genmsg/cmake/pkg-genmsg.cmake.em

message(WARNING "Invoking generate_messages() without having added any message or service file before.
You should either add add_message_files() and/or add_service_files() calls or remove the invocation of generate_messages().")
message(STATUS "robot_expe: 0 messages, 0 services")

set(MSG_I_FLAGS "-Istd_msgs:/opt/ros/jade/share/std_msgs/cmake/../msg")

# Find all generators
find_package(gencpp REQUIRED)
find_package(geneus REQUIRED)
find_package(genlisp REQUIRED)
find_package(genpy REQUIRED)

add_custom_target(robot_expe_generate_messages ALL)

# verify that message/service dependencies have not changed since configure



#
#  langs = gencpp;geneus;genlisp;genpy
#

### Section generating for lang: gencpp
### Generating Messages

### Generating Services

### Generating Module File
_generate_module_cpp(robot_expe
  ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/robot_expe
  "${ALL_GEN_OUTPUT_FILES_cpp}"
)

add_custom_target(robot_expe_generate_messages_cpp
  DEPENDS ${ALL_GEN_OUTPUT_FILES_cpp}
)
add_dependencies(robot_expe_generate_messages robot_expe_generate_messages_cpp)

# add dependencies to all check dependencies targets

# target for backward compatibility
add_custom_target(robot_expe_gencpp)
add_dependencies(robot_expe_gencpp robot_expe_generate_messages_cpp)

# register target for catkin_package(EXPORTED_TARGETS)
list(APPEND ${PROJECT_NAME}_EXPORTED_TARGETS robot_expe_generate_messages_cpp)

### Section generating for lang: geneus
### Generating Messages

### Generating Services

### Generating Module File
_generate_module_eus(robot_expe
  ${CATKIN_DEVEL_PREFIX}/${geneus_INSTALL_DIR}/robot_expe
  "${ALL_GEN_OUTPUT_FILES_eus}"
)

add_custom_target(robot_expe_generate_messages_eus
  DEPENDS ${ALL_GEN_OUTPUT_FILES_eus}
)
add_dependencies(robot_expe_generate_messages robot_expe_generate_messages_eus)

# add dependencies to all check dependencies targets

# target for backward compatibility
add_custom_target(robot_expe_geneus)
add_dependencies(robot_expe_geneus robot_expe_generate_messages_eus)

# register target for catkin_package(EXPORTED_TARGETS)
list(APPEND ${PROJECT_NAME}_EXPORTED_TARGETS robot_expe_generate_messages_eus)

### Section generating for lang: genlisp
### Generating Messages

### Generating Services

### Generating Module File
_generate_module_lisp(robot_expe
  ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/robot_expe
  "${ALL_GEN_OUTPUT_FILES_lisp}"
)

add_custom_target(robot_expe_generate_messages_lisp
  DEPENDS ${ALL_GEN_OUTPUT_FILES_lisp}
)
add_dependencies(robot_expe_generate_messages robot_expe_generate_messages_lisp)

# add dependencies to all check dependencies targets

# target for backward compatibility
add_custom_target(robot_expe_genlisp)
add_dependencies(robot_expe_genlisp robot_expe_generate_messages_lisp)

# register target for catkin_package(EXPORTED_TARGETS)
list(APPEND ${PROJECT_NAME}_EXPORTED_TARGETS robot_expe_generate_messages_lisp)

### Section generating for lang: genpy
### Generating Messages

### Generating Services

### Generating Module File
_generate_module_py(robot_expe
  ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/robot_expe
  "${ALL_GEN_OUTPUT_FILES_py}"
)

add_custom_target(robot_expe_generate_messages_py
  DEPENDS ${ALL_GEN_OUTPUT_FILES_py}
)
add_dependencies(robot_expe_generate_messages robot_expe_generate_messages_py)

# add dependencies to all check dependencies targets

# target for backward compatibility
add_custom_target(robot_expe_genpy)
add_dependencies(robot_expe_genpy robot_expe_generate_messages_py)

# register target for catkin_package(EXPORTED_TARGETS)
list(APPEND ${PROJECT_NAME}_EXPORTED_TARGETS robot_expe_generate_messages_py)



if(gencpp_INSTALL_DIR AND EXISTS ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/robot_expe)
  # install generated code
  install(
    DIRECTORY ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/robot_expe
    DESTINATION ${gencpp_INSTALL_DIR}
  )
endif()
add_dependencies(robot_expe_generate_messages_cpp std_msgs_generate_messages_cpp)

if(geneus_INSTALL_DIR AND EXISTS ${CATKIN_DEVEL_PREFIX}/${geneus_INSTALL_DIR}/robot_expe)
  # install generated code
  install(
    DIRECTORY ${CATKIN_DEVEL_PREFIX}/${geneus_INSTALL_DIR}/robot_expe
    DESTINATION ${geneus_INSTALL_DIR}
  )
endif()
add_dependencies(robot_expe_generate_messages_eus std_msgs_generate_messages_eus)

if(genlisp_INSTALL_DIR AND EXISTS ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/robot_expe)
  # install generated code
  install(
    DIRECTORY ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/robot_expe
    DESTINATION ${genlisp_INSTALL_DIR}
  )
endif()
add_dependencies(robot_expe_generate_messages_lisp std_msgs_generate_messages_lisp)

if(genpy_INSTALL_DIR AND EXISTS ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/robot_expe)
  install(CODE "execute_process(COMMAND \"/usr/bin/python\" -m compileall \"${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/robot_expe\")")
  # install generated code
  install(
    DIRECTORY ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/robot_expe
    DESTINATION ${genpy_INSTALL_DIR}
  )
endif()
add_dependencies(robot_expe_generate_messages_py std_msgs_generate_messages_py)
