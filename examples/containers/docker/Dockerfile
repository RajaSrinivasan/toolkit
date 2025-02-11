FROM ubuntu:latest

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
        mercurial \
        python3-dev \
        python3-pip \
        python3-venv \
        subversion \
        sudo \
        tzdata \
        unzip \
        vim \
        wget && \
    apt-get clean

RUN cat /etc/os-release && \
    gnat --version && \
    gprbuild --version

RUN mkdir /projects
RUN mkdir -p /usr/local/toolkit/bin
#codemd: begin segment=AlireBuild caption=Build prerequisites
WORKDIR /projects
RUN git clone --recurse-submodules https://github.com/alire-project/alire.git
RUN cd alire; dev/build.sh ; cp bin/alr /bin
RUN alr toolchain --disable-assistant
#codemd: end

#codemd: begin segment=Toolkit caption=Build the toolkit and examples
RUN git clone https://gitlab.com/ada23/codemd.git
RUN cd codemd; alr build; cp bin/codemd /usr/local/toolkit/bin
RUN git clone https://gitlab.com/ada23/toolkit.git
RUN cd toolkit/adalib; alr build
RUN cd toolkit/examples/;  ./build.sh; cp bin/* /usr/local/toolkit/bin

RUN git clone https://gitlab.com/RajaSrinivasan/TechAdaBook.git
RUN cd TechAdaBook/Prj; ./build.sh; cp bin/* /usr/local/toolkit/bin
ENV PATH /usr/local/toolkit/bin:$PATH
#codemd: end
RUN codemd -h