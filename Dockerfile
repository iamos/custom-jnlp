FROM jenkins/jnlp-slave

MAINTAINER Marco <marco@buzzni.com>

ARG DC_VERSION=1.22.0
ENV KUBECTL_VERSION=v1.10.2
ENV HELM_VERSION=v2.8.2

USER root

RUN apt update && \
    apt install -qq -y --no-install-recommends \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg2 \
    software-properties-common \
    python python-setuptools python-dev build-essential python-pip 

RUN pip install awscli==1.16.31

RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - && \
    apt-key fingerprint 0EBFCD88 && \
    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian stretch stable" && \
    apt update && \
    apt install -qq -y --no-install-recommends docker-ce

RUN curl -L https://github.com/docker/compose/releases/download/${DC_VERSION}/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose && \
    chmod +x /usr/local/bin/docker-compose && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl && \
    mv kubectl /usr/local/bin/kubectl

RUN curl -LO https://storage.googleapis.com/kubernetes-helm/helm-${HELM_VERSION}-linux-amd64.tar.gz && \
    tar -zxvf helm-${HELM_VERSION}-linux-amd64.tar.gz && \
    mv linux-amd64/helm /usr/local/bin/helm && \
    chmod +x /usr/local/bin/kubectl /usr/local/bin/helm

RUN rm -rf helm-${HELM_VERSION}-linux-amd64.tar.gz