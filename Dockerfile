FROM ubuntu:22.04

LABEL maintainer='Aytuğ HAN <me@aytughan.com>'

# Install Git, Basic SSH Server and JDK
RUN apt update && \
    apt install -y \
    git \
    openssh-server \
    default-jdk

# Cleanup Packages
RUN apt autoremove

RUN sed -i 's|session    required     pam_loginuid.so|session    optional     pam_loginuid.so|g' /etc/pam.d/sshd && \
    mkdir -p /var/run/sshd && \
    # Add user jenkins to the image
    adduser --quiet jenkins && \
    # Set password for the jenkins user
    echo 'jenkins:jenkins' | chpasswd

# Copy Authorized Keys
COPY .ssh/authorized_keys /home/jenkins/.ssh/authorized_keys

# Set .ssh folder ownership to jenkins user
RUN chown -R jenkins:jenkins /home/jenkins/.ssh/

# Standard SSH port
EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
