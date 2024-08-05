FROM registry.access.redhat.com/ubi8/ubi-minimal:latest

USER root

RUN microdnf update \
    && microdnf --setopt=install_weak_deps=0 --setopt=tsflags=nodocs install java-17-openjdk-headless shadow-utils \
    && microdnf clean all