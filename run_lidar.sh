#!/bin/bash
set -e

# Avoid stale Gazebo processes that cause "Address already in use" and duplicate entities.
pkill -f gzserver 2>/dev/null || true
pkill -f gzclient 2>/dev/null || true

cd /home/hari/x100_ws
source /opt/ros/humble/setup.bash
export FASTDDS_BUILTIN_TRANSPORTS=UDPv4
colcon build --packages-select x100_gazebo
source install/setup.bash
ros2 launch x100_gazebo x100_empty_world.launch.py
