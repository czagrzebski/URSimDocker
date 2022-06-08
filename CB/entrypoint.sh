#!/bin/bash
# Entrypoint for the URSimDock

echo "Universal Robots Simulator with Docker"

# start the x server 
Xvfb :0 -screen 0 1280x800x24 &> /dev/null &

# wait a few seconds for server to initialize
sleep 3

# Start the VNC Server
x11vnc -forever -display :0  &> /dev/null &

# Modify launch.sh to use hostname rather than container id (for noVNC)
sed -i 's/$(hostname)/localhost/g' /usr/share/novnc/utils/launch.sh &> /dev/null 

# Launch noVNC
/usr/share/novnc/utils/launch.sh --listen 8080 --vnc localhost:5900 &

# Launch the polyscope interface and the simulated controller
./start-ursim.sh $ROBOT_TYPE &> /dev/null