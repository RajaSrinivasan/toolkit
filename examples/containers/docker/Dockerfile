FROM ubuntu:latest

ARG TARGETARCH
ARG TARGETOS
ARG ALRBINBASE="https://github.com/alire-project/alire/releases/download/v2.1.0/alr-2.1.0-bin"

SHELL [ "/bin/bash" , "-c" ]
RUN ln -fs /usr/share/zoneinfo/America/New_York /etc/localtime && \
    apt-get update && \
    apt-get install -y \
        bash \
        curl \
        git \
        gnat \
        gprbuild \
        jq \
        libpython3-dev \
        make \
        python3-dev \
        python3-pip \
        python3-venv \
        sudo \
        tzdata \
        unzip \
        nano \
        wget \
        openssh-server && \
    apt-get clean

RUN cat /etc/os-release && \
    gnat --version && \
    gprbuild --version

RUN mkdir /projects
RUN mkdir -p /usr/local/toolkit/bin


RUN if [ "$TARGETARCH" = "arm64" ]; then \
        wget $ALRBINBASE-aarch64-$TARGETOS.zip -O alr.zip; \
    fi; \
    if [ "$TARGETARCH" = "amd64" ]; then \
        wget $ALRBINBASE-x86_64-$TARGETOS.zip -O alr.zip; \
    fi
RUN unzip alr.zip 

#codemd: begin segment=AlireBuild caption=Build prerequisites
WORKDIR /projects

RUN alr toolchain --disable-assistant

RUN git clone https://gitlab.com/ada23/codemd.git
RUN cd codemd; alr build; cp bin/codemd /usr/local/toolkit/bin
RUN git clone https://github.com/RajaSrinivasan/toolkit.git 
RUN cd toolkit/adalib; alr build
RUN cd toolkit/examples/;  ./build.sh; cp bin/* /usr/local/toolkit/bin

ENV PATH /usr/local/toolkit/bin:$PATH
#codemd: end

RUN mkdir /var/run/sshd

# Set root password (change "rootpassword" for security)
RUN echo "root:rootpassword" | chpasswd

# Allow root login and password authentication
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config

# Expose SSH port
EXPOSE 22

# Start SSH daemon
CMD ["/usr/sbin/sshd", "-D"]
