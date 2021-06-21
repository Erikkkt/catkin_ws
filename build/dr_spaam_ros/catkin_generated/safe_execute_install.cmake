execute_process(COMMAND "/home/xiao/catkin_ws/build/dr_spaam_ros/catkin_generated/python_distutils_install.sh" RESULT_VARIABLE res)

if(NOT res EQUAL 0)
  message(FATAL_ERROR "execute_process(/home/xiao/catkin_ws/build/dr_spaam_ros/catkin_generated/python_distutils_install.sh) returned error code ")
endif()
