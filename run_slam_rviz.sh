#!/bin/bash
# Stop any hanging rviz or slam nodes before starting fresh 
killall -9 rviz2 2>/dev/null
pkill -f slam_toolbox 2>/dev/null

source /opt/ros/humble/setup.bash
source /home/hari/x100_ws/install/setup.bash
export FASTDDS_BUILTIN_TRANSPORTS=UDPv4
export LD_LIBRARY_PATH=/usr/lib/x86_64-linux-gnu/gazebo-11/plugins:/opt/ros/humble/opt/rviz_ogre_vendor/lib:/opt/ros/humble/lib/x86_64-linux-gnu:/opt/ros/humble/lib:/usr/lib/x86_64-linux-gnu:/lib/x86_64-linux-gnu

echo "Starting SLAM Toolbox and RViz2..."

# Run slam_toolbox synchronously using an explicit launch command and handle shutdown nicely
# We use a subshell or a bash trap to close both when the user hits CTRL+C
trap 'kill $(jobs -p)' SIGINT SIGTERM EXIT

ros2 launch x100_gazebo online_async.launch.py use_sim_time:=true &
sleep 3
env -u GTK_PATH -u GTK_EXE_PREFIX -u GIO_MODULE_DIR -u GSETTINGS_SCHEMA_DIR -u GTK_IM_MODULE_FILE \
	rviz2 -d /home/hari/x100_ws/viz.rviz --ros-args -p use_sim_time:=true

wait
