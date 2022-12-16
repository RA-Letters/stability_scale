FROM lindwaltz/ros-indigo-desktop-full-nvidia

RUN apt-get update \
 && apt-get install -y --force-yes \
     ros-indigo-ardrone-autonomy \
 && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /catkin_ws/src
 
COPY . /catkin_ws/src/.

RUN . /opt/ros/$ROS_DISTRO/setup.sh \
 && apt-get update && rosdep install -y \
      --from-paths \
        /catkin_ws/src \
      --ignore-src -r \
  && rm -rf /var/lib/apt/lists/*

RUN . /opt/ros/$ROS_DISTRO/setup.sh \
 && cd /catkin_ws \
 && catkin_make

RUN sed --in-place --expression \
      '$isource "/catkin_ws/devel/setup.bash"' \
      /ros_entrypoint.sh

CMD ["roslaunch", "cvg_sim_gazebo", "brick_wall.launch"]
