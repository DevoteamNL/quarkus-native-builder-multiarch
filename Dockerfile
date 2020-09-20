FROM bentaljaard/fedora:32-aarch64

RUN dnf install -y gcc glibc-devel zlib-devel libstdc++-static java-11-openjdk maven
RUN mkdir -p  /opt/graalvm
WORKDIR /opt/graalvm
RUN curl -LJ https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-20.2.0/graalvm-ce-java11-linux-aarch64-20.2.0.tar.gz -o /tmp/graalvm-ce-java11-linux-aarch64-20.2.0.tar.gz && tar -xzvf /tmp/graalvm-ce-java11-linux-aarch64-20.2.0.tar.gz
ENV PATH=$PATH:/opt/graalvm/graalvm-ce-java11-20.2.0/bin
ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk-11.0.8.10-2.fc32.aarch64
RUN gu install native-image
