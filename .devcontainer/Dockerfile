# Pick any base image, but if you select node, skip installing node. 😊
FROM ubuntu:24.04

# Terraform and tflint versions
ARG TERRAFORM_VERSION=1.10.4
ARG TFLINT_VERSION=0.54.0
ARG G_VRSN=1.22.7

# This Dockerfile adds a non-root user with sudo access. Update the “remoteUser” property in
# devcontainer.json to use it. More info: https://aka.ms/vscode-remote/containers/non-root-user.
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Install needed packages and setup non-root user. Use a separate RUN statement to add your own dependencies.
RUN apt-get update \
  && export DEBIAN_FRONTEND=noninteractive \
  && apt-get -y install --no-install-recommends apt-utils dialog 2>&1 \
  #
  # install git iproute2, required tools installed
  && apt-get install -y \
  git \
  openssh-client \
  libssl-dev \
  libffi-dev \
  less \
  wget \
  jq \
  unzip \
  tmux \
  tree \
  curl \
  vim \
  procps \
  unzip \
  apt-transport-https \
  ca-certificates \
  gnupg-agent \
  software-properties-common \
  lsb-release 2>&1 \
  #
  #
  # [Optional] For local testing instead of cloud shell
  # Install the Azure CLI
  && echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $(lsb_release -cs) main" > /etc/apt/sources.list.d/azure-cli.list \
  && curl -sL https://packages.microsoft.com/keys/microsoft.asc | apt-key add - 2>/dev/null \
  && apt-get update \
  && apt-get install -y azure-cli \
  #
  # Install Terraform, tflint, and graphviz
  && mkdir -p /tmp/docker-downloads \
  && curl -sSL -o /tmp/docker-downloads/terraform.zip https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
  && unzip /tmp/docker-downloads/terraform.zip \
  && mv terraform /usr/local/bin \
  && curl -sSL -o /tmp/docker-downloads/tflint.zip https://github.com/wata727/tflint/releases/download/v${TFLINT_VERSION}/tflint_linux_amd64.zip \
  && unzip /tmp/docker-downloads/tflint.zip \
  && mv tflint /usr/local/bin \
  && cd ~ \ 
  && rm -rf /tmp/docker-downloads \
  && apt-get install -y graphviz \
  #
  # Create a non-root user to use if preferred - see https://aka.ms/vscode-remote/containers/non-root-user.
  && groupadd --gid $USER_GID $USERNAME \
  && useradd -s /bin/bash --uid $USER_UID --gid $USER_GID -m $USERNAME \
  # [Optional] Add sudo support for the non-root user
  && apt-get install -y sudo \
  && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME\
  && chmod 0440 /etc/sudoers.d/$USERNAME \
  
  #
  # Terraform Providers
  && mkdir -p /home/$USERNAME/.terraform.d/plugin-cache/linux_amd64 \
  #
  && chown  -R $USERNAME:$USERNAME /home/$USERNAME/.terraform.d/ \
  # Clean up
  && apt-get autoremove -y \
  && apt-get clean -y \
  && rm -rf /var/lib/apt/lists/*

# [Optional] Uncomment this section to install additional OS packages.
# RUN apt-get update \
#     && export DEBIAN_FRONTEND=noninteractive \
#     && apt-get -y install --no-install-recommends <your-package-list-here>

# go
RUN wget -q https://dl.google.com/go/go${G_VRSN}.linux-amd64.tar.gz \
  && tar -C /opt -xzf go${G_VRSN}.linux-amd64.tar.gz \
  && rm go${G_VRSN}.linux-amd64.tar.gz