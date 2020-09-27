# Multiarch Quarkus Native Builder Image

![Docker Image CI](https://github.com/DevoteamNL/quarkus-native-builder-multiarch/workflows/Docker%20Image%20CI/badge.svg)

This docker image provides the capability to compile a native quarkus image for multiple architectures on a x86_64 machine. It is based on the multiarch project on github (https://github.com/multiarch) and includes GraalVM with native compilation features enabled.

Using this image in a multi-stage build allows you to for example compile a quarkus application to a native aarch64 binary and package the result into a container that can be run on aarch64 (eg. Raspberry Pi 3B)

Below is an example multi-stage docker build

```
FROM bentaljaard/quarkus-native-builder-multiarch:aarch64 AS builder
RUN mkdir -p /usr/src/app
COPY pom.xml /usr/src/app/
RUN mvn -f /usr/src/app/pom.xml -B de.qaware.maven:go-offline-maven-plugin:1.2.5:resolve-dependencies
COPY src /usr/src/app/src
#USER root
#RUN chown -R quarkus /usr/src/app
#USER quarkus
RUN mvn -f /usr/src/app/pom.xml -Pnative clean package


FROM bentaljaard/fedora:32-aarch64
WORKDIR /work/
COPY --from=builder /usr/src/app/target/*-runner /work/application

# set up permissions for user `1001`
RUN chmod 775 /work /work/application \
  && chown -R 1001 /work \
  && chmod -R "g+rwX" /work \
  && chown -R 1001:root /work

EXPOSE 8080
USER 1001

CMD ["./application", "-Dquarkus.http.host=0.0.0.0"]
```
