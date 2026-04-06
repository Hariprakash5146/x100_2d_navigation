# X100 ROS 2 Simulation Workspace

ROS 2 Humble workspace for simulating the **X100 UGV** in Gazebo, running SLAM with `slam_toolbox`, and testing navigation with Nav2.

This repository contains the `x100_gazebo` package and helper scripts to quickly launch the simulation and mapping workflow.

## Highlights

- X100 robot model and world assets for Gazebo Classic
- ROS 2 launch files for simulation, display, SLAM, and navigation
- Preconfigured RViz layout (`viz.rviz`)
- Helper scripts for one-command startup
- Example generated map files (`map.yaml`, `map.pgm`)

## Repository Structure

```text
x100_ws/
├── src/
│   └── x100_gazebo/
│       ├── launch/
│       ├── urdf/
│       ├── meshes/
│       ├── models/
│       └── worlds/
├── run_lidar.sh
├── run_slam_rviz.sh
├── viz.rviz
├── map.yaml
└── map.pgm
```

## Prerequisites

- Ubuntu 22.04
- ROS 2 Humble
- Gazebo Classic 11
- `colcon`

Install core dependencies (if needed):

```bash
sudo apt update
sudo apt install -y \
  ros-humble-gazebo-ros-pkgs \
  ros-humble-robot-state-publisher \
  ros-humble-xacro \
  ros-humble-rviz2 \
  ros-humble-slam-toolbox \
  ros-humble-nav2-bringup
```

## Setup

```bash
cd ~/x100_ws
source /opt/ros/humble/setup.bash
colcon build --packages-select x100_gazebo
source install/setup.bash
```

## Quick Start

### 1. Start Gazebo + X100

```bash
cd ~/x100_ws
chmod +x run_lidar.sh run_slam_rviz.sh
./run_lidar.sh
```

This launches:

- Gazebo (`gazebo_ros`)
- X100 robot spawn from `x100.urdf.xacro`
- Default world: `src/x100_gazebo/worlds/bigmap.world`

### 2. Start SLAM + RViz

Open a second terminal:

```bash
cd ~/x100_ws
./run_slam_rviz.sh
```

This launches:

- `slam_toolbox` (online async mode)
- RViz with `viz.rviz`

## Manual Launch Commands

Build and source first:

```bash
cd ~/x100_ws
source /opt/ros/humble/setup.bash
source install/setup.bash
```

Launch Gazebo world:
<img width="1920" height="1080" alt="Screenshot from 2026-04-06 18-52-39" src="https://github.com/user-attachments/assets/0ae32d53-5c06-492d-b25a-742e34e5fca4" />

```bash
ros2 launch x100_gazebo x100_empty_world.launch.py
```

Launch SLAM only:

```bash
ros2 launch x100_gazebo online_async.launch.py use_sim_time:=true
```

Launch RViz display:

```bash
ros2 launch x100_gazebo display.launch.py use_sim_time:=true rviz_config:=/home/$USER/x100_ws/viz.rviz
```

Launch combined world + SLAM + RViz:

```bash
ros2 launch x100_gazebo navigation_slam_online_async.launch.py use_sim_time:=true
```

Launch Nav2 bringup wrapper:

```bash
ros2 launch x100_gazebo navigation.launch.py use_sim_time:=true slam:=True map:=/home/$USER/x100_ws/map.yaml
```

## SLAM Map Saving

After mapping is complete:

```bash
cd ~/x100_ws
ros2 run nav2_map_server map_saver_cli -f map
```

This generates `map.yaml` and `map.pgm` in the current directory.

## Notes

- The launch files set `FASTDDS_BUILTIN_TRANSPORTS=UDPv4` to avoid common DDS transport issues.
- Helper scripts stop stale Gazebo/RViz/SLAM processes before relaunching.
- If RViz has rendering issues, keep using the included launch/script since they set required environment variables.

## Troubleshooting

If Gazebo fails with address/port conflicts:

```bash
pkill -f gzserver
pkill -f gzclient
```

If RViz does not start cleanly, kill old instances and retry:

```bash
killall -9 rviz2
```

## Package

Main ROS 2 package: `src/x100_gazebo`

If you are using this repository in a larger robotics stack, add this workspace to your normal ROS 2 overlay sourcing flow.
