FROM ubuntu:bionic

LABEL maintainer="Creed Zagrzebski"

ENV DEBIAN_FRONTEND noninteractive

# Update package list and install dependencies 
RUN apt-get update && apt-get -y install openjdk-8-jdk libcurl3 libjava3d-* ttf-dejavu* fonts-ipafont fonts-baekmuk fonts-nanum fonts-arphic-uming fonts-arphic-ukai 
RUN apt-get install -y lib32gcc1 lib32stdc++6 libc6-i386 wget curl nano 

# Download URSim 5.11.11 
RUN wget https://s3-eu-west-1.amazonaws.com/ur-support-site/159649/URSim_Linux-5.11.11.1010533.tar.gz

# Create ursim directory and extract the tarball
RUN mkdir -p /root/ursim && tar -xf URSim_Linux-5.11.11.1010533.tar.gz -C /root/ursim --strip-components=2
 
# Remove the TAR
RUN rm -rf URSim_Linux-5.11.11.1010533.tar.gz

# Copy the entrypoint/stopurcontrol script and set the CWD
COPY ./entrypoint.sh /root/ursim
COPY ./stopurcontrol.sh /root/ursim
WORKDIR /root/ursim

# Make URScripts Executable
RUN chmod u+x ./*.sh

# Install included dependencies
RUN dpkg -i ursim-dependencies/*amd64.deb

# Install XServer and VNC
RUN apt-get install -y x11vnc xvfb novnc net-tools
ENV DISPLAY :0.0

# Expose VNC Server Port
EXPOSE 5900

# Expose Primary, Secondary, Matlab, and RTDE Ports
EXPOSE 30001
EXPOSE 30002
EXPOSE 30003
EXPOSE 30004
EXPOSE 29999
EXPOSE 30000

ENV URSIM_ROOT="$PWD"

CMD ["./entrypoint.sh"]






