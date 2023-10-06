FROM registry.access.redhat.com/ubi8/ubi-minimal:latest

USER root

RUN microdnf update \
    && microdnf install java-11-openjdk-headless shadow-utils \
    && microdnf clean all