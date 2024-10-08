##################################################################################
# Container designed for executing Ansible playbooks. Includes the Akeyless CLI
# and dependancies. Uses Ubuntu as the base image.
##################################################################################

FROM ubuntu:22.04
LABEL org.opencontainers.image.title="ansible-runner"
LABEL org.opencontainers.image.authors="Mark Recek"

# To prevent interactive prompts from apt commands
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt update && apt install -y python3 python3-pip python-is-python3 gnupg2 curl openssh-server software-properties-common

# Install Ansible using pip
RUN pip3 install ansible

# Install Akeyless CLI
RUN curl -o /tmp/akeyless https://akeyless-cli.s3.us-east-2.amazonaws.com/cli/latest/production/cli-linux-amd64
RUN chmod +x /tmp/akeyless
RUN /tmp/akeyless --init
RUN mv /tmp/akeyless /usr/bin/akeyless

# Install Hashicorp Vault CLI for use with Akeyless
RUN pip install hvac

# Cleanup cached apt lists
RUN rm -rf /var/lib/apt/lists/*
RUN service ssh start

# Set up the entrypoint
CMD ["/bin/bash"]