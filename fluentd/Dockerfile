# fluentd/Dockerfile

FROM fluent/fluentd:edge-debian
USER root

RUN ["gem", "install", "elasticsearch", "--no-document", "--version", "9.1.2"]

RUN ["gem", "install", "fluent-plugin-elasticsearch", "--no-document", "--version", "6.0.0"]
USER fluent