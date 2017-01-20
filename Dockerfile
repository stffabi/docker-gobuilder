FROM golang:1.6.4
MAINTAINER Fabrizio Steiner <stffabi@users.noreply.github.com>

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION

LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/stffabi/docker-goreleaser" \
      org.label-schema.version="$VERSION" \
      org.label-schema.schema-version="1.0"

ARG goreleaser=0.5.7
ARG glide=0.12.3

# Install glide binary
RUN curl --silent --show-error --fail --location \
      --header "Accept: application/tar+gzip, application/x-gzip, application/octet-stream" -o - \
      "https://github.com/Masterminds/glide/releases/download/v${glide}/glide-v${glide}-linux-amd64.tar.gz" \
    | tar --no-same-owner -xz linux-amd64/glide -O > /usr/bin/glide \
 && chmod 0755 /usr/bin/glide \
 && /usr/bin/glide -v

# Install goreleaser binary
RUN curl --silent --show-error --fail --location \
      --header "Accept: application/tar+gzip, application/x-gzip, application/octet-stream" -o - \
      "https://github.com/goreleaser/goreleaser/releases/download/v${goreleaser}/goreleaser_Linux_x86_64.tar.gz" \
    | tar --no-same-owner -C /usr/bin/ -xz goreleaser \
 && chmod 0755 /usr/bin/goreleaser \
 && /usr/bin/goreleaser -v

VOLUME /src
WORKDIR /src

COPY build_environment.sh /
COPY build.sh /

ENTRYPOINT ["/build.sh"]