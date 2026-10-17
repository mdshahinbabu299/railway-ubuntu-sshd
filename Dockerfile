FROM ubuntu:22.04

# Starting Ubuntu official docker image has user ubuntu with UID/GID 1000
# Remove the default ubuntu user to free up UID/GID 1000
RUN userdel -r ubuntu 2>/dev/null || true

# Install dependencies and configure SSH
RUN apt-get update \
    && apt-get install -y iproute2 iputils-ping openssh-server telnet sudo curl git python3 python3-pip nodejs npm \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && mkdir -p /run/sshd \
    && chmod 755 /run/sshd \
    && echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config \
    # Root login চালু করা (যাতে সরাসরি root ইউজার হিসেবে যুক্ত হওয়া যায়)
    && echo "PermitRootLogin yes" >> /etc/ssh/sshd_config \
    # তৈরি হওয়া যেকোনো ইউজারের জন্য পাসওয়ার্ড ছাড়া Sudo এনাবল করা
    && echo "%sudo ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Copy ssh user config to configure user's password and authorized keys
COPY ssh-user-config.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/ssh-user-config.sh

# Expose port 22
EXPOSE 22

# Start SSH server
CMD ["/usr/local/bin/ssh-user-config.sh"]
