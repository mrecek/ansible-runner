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
RUN curl -o /usr/local/bin/akeyless https://akeyless-cli.s3.us-east-2.amazonaws.com/cli/latest/production/cli-linux-amd64
RUN chmod +x /usr/local/bin/akeyless
RUN ./akeyless --init

# Install Hashicorp Vault CLI for use with Akeyless
RUN pip install hvac

# Cleanup cached apt lists
RUN rm -rf /var/lib/apt/lists/*
RUN service ssh start

# Set up the entrypoint
CMD ["/bin/bash"]