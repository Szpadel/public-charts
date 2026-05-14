ARG ALPINE_IMAGE=alpine:3.23.3@sha256:25109184c71bdad752c8312a8623239686a9a2071e8825f20acb8f2198c3f659
ARG GO_IMAGE=golang:1.26.1-alpine3.23@sha256:2389ebfa5b7f43eeafbd6be0c3700cc46690ef842ad962f6c5bd6be49ed82039
ARG INGRESS_NGINX_TAG=controller-v1.15.1
ARG INGRESS_NGINX_COMMIT=0a5901f3c64f11e92e487799b8da3f00cca37515
ARG CONTROLLER_VERSION=v1.15.1
ARG NGINX_VERSION=1.30.1

FROM ${ALPINE_IMAGE} AS upstream-source
ARG INGRESS_NGINX_TAG
ARG INGRESS_NGINX_COMMIT
RUN apk add --no-cache ca-certificates git \
  && git clone --branch "${INGRESS_NGINX_TAG}" --depth 1 https://github.com/kubernetes/ingress-nginx.git /src \
  && test "$(git -C /src rev-parse HEAD)" = "${INGRESS_NGINX_COMMIT}"

FROM ${ALPINE_IMAGE} AS nginx-builder
ARG NGINX_VERSION
COPY --from=upstream-source /src/images/nginx/rootfs /
RUN rm /patches/28_nginx-1.27.1-CVE-2025-23419.patch \
  && sed -i "s/^export NGINX_VERSION=.*/export NGINX_VERSION=${NGINX_VERSION}/" /build.sh \
  && apk update \
  && apk upgrade \
  && apk add -U bash --no-cache \
  && /build.sh

FROM ${ALPINE_IMAGE} AS nginx-base
ENV PATH=$PATH:/usr/local/luajit/bin:/usr/local/nginx/sbin:/usr/local/nginx/bin
ENV LUA_PATH="/usr/local/share/luajit-2.1.0-beta3/?.lua;/usr/local/share/lua/5.1/?.lua;/usr/local/lib/lua/?.lua;;"
ENV LUA_CPATH="/usr/local/lib/lua/?/?.so;/usr/local/lib/lua/?.so;;"

COPY --from=nginx-builder /usr/local /usr/local
COPY --from=nginx-builder /usr/lib/libopentelemetry* /usr/local/lib
COPY --from=nginx-builder /opt /opt
COPY --from=nginx-builder /etc/nginx /etc/nginx

RUN apk update \
  && apk upgrade \
  && apk add -U --no-cache \
    bash \
    openssl \
    pcre \
    zlib \
    ca-certificates \
    patch \
    yajl \
    lmdb \
    libxml2 \
    libmaxminddb \
    yaml-cpp \
    dumb-init \
    tzdata \
    grpc-cpp \
    libprotobuf \
    abseil-cpp-crc-cpu-detect \
    abseil-cpp-vlog-config-internal \
  && ln -s /usr/local/nginx/sbin/nginx /sbin/nginx \
  && adduser -S -D -H -u 101 -h /usr/local/nginx \
    -s /sbin/nologin -G www-data -g www-data www-data \
  && bash -eu -c ' \
    writeDirs=( \
      /var/log/nginx \
      /var/lib/nginx/body \
      /var/lib/nginx/fastcgi \
      /var/lib/nginx/proxy \
      /var/lib/nginx/scgi \
      /var/lib/nginx/uwsgi \
      /var/log/audit \
    ); \
    for dir in "${writeDirs[@]}"; do \
      mkdir -p ${dir}; \
      chown -R www-data:www-data ${dir}; \
    done'

FROM --platform=$BUILDPLATFORM ${GO_IMAGE} AS controller-bin-builder
ARG TARGETARCH
ARG CONTROLLER_VERSION
ARG INGRESS_NGINX_COMMIT
COPY --from=upstream-source /src /src
WORKDIR /src
RUN apk add --no-cache git \
  && PKG=k8s.io/ingress-nginx \
    ARCH="${TARGETARCH}" \
    COMMIT_SHA="${INGRESS_NGINX_COMMIT}" \
    REPO_INFO=https://github.com/kubernetes/ingress-nginx \
    TAG="${CONTROLLER_VERSION}" \
    build/build.sh

FROM nginx-base AS controller
ARG TARGETARCH
ARG IMAGE_VERSION=0.1.0
ARG CONTROLLER_VERSION
ARG INGRESS_NGINX_COMMIT
ARG NGINX_VERSION

LABEL org.opencontainers.image.title="ingress-nginx controller"
LABEL org.opencontainers.image.documentation="https://kubernetes.github.io/ingress-nginx/"
LABEL org.opencontainers.image.source="https://github.com/Szpadel/public-charts"
LABEL org.opencontainers.image.licenses="Apache-2.0"
LABEL org.opencontainers.image.version="${IMAGE_VERSION}"
LABEL org.opencontainers.image.revision="${INGRESS_NGINX_COMMIT}"
LABEL org.opencontainers.image.description="ingress-nginx ${CONTROLLER_VERSION} rebuilt with nginx ${NGINX_VERSION}"

WORKDIR /etc/nginx

RUN apk update \
  && apk upgrade \
  && apk add --no-cache diffutils \
  && rm -rf /var/cache/apk/*

COPY --from=upstream-source --chown=www-data:www-data /src/rootfs/etc /etc
COPY --from=controller-bin-builder --chown=www-data:www-data /src/rootfs/bin/${TARGETARCH}/dbg /
COPY --from=controller-bin-builder --chown=www-data:www-data /src/rootfs/bin/${TARGETARCH}/nginx-ingress-controller /
COPY --from=controller-bin-builder --chown=www-data:www-data /src/rootfs/bin/${TARGETARCH}/wait-shutdown /

RUN bash -xeu -c ' \
    writeDirs=( \
      /etc/ingress-controller \
      /etc/ingress-controller/ssl \
      /etc/ingress-controller/auth \
      /etc/ingress-controller/geoip \
      /etc/ingress-controller/telemetry \
      /var/log \
      /var/log/nginx \
      /tmp/nginx \
    ); \
    for dir in "${writeDirs[@]}"; do \
      mkdir -p ${dir}; \
      chown -R www-data:www-data ${dir}; \
    done' \
  && echo "/lib:/usr/lib:/usr/local/lib:/modules_mount/etc/nginx/modules/otel" > /etc/ld-musl-x86_64.path \
  && echo "/lib:/usr/lib:/usr/local/lib:/modules_mount/etc/nginx/modules/otel" > /etc/ld-musl-aarch64.path

RUN apk add --no-cache libcap \
  && setcap    cap_net_bind_service=+ep /nginx-ingress-controller \
  && setcap -v cap_net_bind_service=+ep /nginx-ingress-controller \
  && setcap    cap_net_bind_service=+ep /usr/local/nginx/sbin/nginx \
  && setcap -v cap_net_bind_service=+ep /usr/local/nginx/sbin/nginx \
  && setcap    cap_net_bind_service=+ep /usr/bin/dumb-init \
  && setcap -v cap_net_bind_service=+ep /usr/bin/dumb-init \
  && apk del libcap \
  && ln -sf /usr/local/nginx/sbin/nginx /usr/bin/nginx

USER www-data
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
  && ln -sf /dev/stderr /var/log/nginx/error.log
EXPOSE 80 443
ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD ["/nginx-ingress-controller"]

FROM nginx-base AS chroot-source
COPY --from=upstream-source /src/rootfs/chroot.sh /chroot.sh
RUN apk update \
  && apk upgrade \
  && /chroot.sh

FROM ${ALPINE_IMAGE} AS controller-chroot
ARG TARGETARCH
ARG IMAGE_VERSION=0.1.0
ARG CONTROLLER_VERSION
ARG INGRESS_NGINX_COMMIT
ARG NGINX_VERSION

LABEL org.opencontainers.image.title="ingress-nginx controller chroot"
LABEL org.opencontainers.image.documentation="https://kubernetes.github.io/ingress-nginx/"
LABEL org.opencontainers.image.source="https://github.com/Szpadel/public-charts"
LABEL org.opencontainers.image.licenses="Apache-2.0"
LABEL org.opencontainers.image.version="${IMAGE_VERSION}"
LABEL org.opencontainers.image.revision="${INGRESS_NGINX_COMMIT}"
LABEL org.opencontainers.image.description="ingress-nginx ${CONTROLLER_VERSION} chroot rebuilt with nginx ${NGINX_VERSION}"

ENV LUA_PATH="/usr/local/share/luajit-2.1.0-beta3/?.lua;/usr/local/share/lua/5.1/?.lua;/usr/local/lib/lua/?.lua;;"
ENV LUA_CPATH="/usr/local/lib/lua/?/?.so;/usr/local/lib/lua/?.so;;"
ENV PATH=$PATH:/usr/local/luajit/bin:/usr/local/nginx/sbin:/usr/local/nginx/bin

RUN apk update \
  && apk upgrade \
  && apk add -U --no-cache \
    bash \
    openssl \
    ca-certificates \
    dumb-init \
    tzdata \
    diffutils \
    util-linux \
  && ln -s /usr/local/nginx/sbin/nginx /sbin/nginx \
  && adduser -S -D -H -u 101 -h /usr/local/nginx \
    -s /sbin/nologin -G www-data -g www-data www-data

COPY --from=chroot-source /chroot /chroot
COPY --from=upstream-source --chown=www-data:www-data /src/rootfs/etc /chroot/etc
COPY --from=controller-bin-builder --chown=www-data:www-data /src/rootfs/bin/${TARGETARCH}/dbg /
COPY --from=controller-bin-builder --chown=www-data:www-data /src/rootfs/bin/${TARGETARCH}/nginx-ingress-controller /
COPY --from=controller-bin-builder --chown=www-data:www-data /src/rootfs/bin/${TARGETARCH}/wait-shutdown /
COPY --from=upstream-source --chown=www-data:www-data /src/rootfs/nginx-chroot-wrapper.sh /usr/bin/nginx

WORKDIR /chroot/etc/nginx

RUN bash -xeu -c ' \
    writeDirs=( \
      /var/log \
    ); \
    for dir in "${writeDirs[@]}"; do \
      mkdir -p ${dir}; \
      chown -R www-data:www-data ${dir}; \
    done' \
  && echo "/lib:/usr/lib:/usr/local/lib:/modules_mount/etc/nginx/modules/otel" > /chroot/etc/ld-musl-x86_64.path \
  && echo "/lib:/usr/lib:/usr/local/lib:/modules_mount/etc/nginx/modules/otel" > /chroot/etc/ld-musl-aarch64.path

RUN apk add --no-cache libcap \
  && setcap    cap_sys_chroot,cap_net_bind_service=+ep /nginx-ingress-controller \
  && setcap -v cap_sys_chroot,cap_net_bind_service=+ep /nginx-ingress-controller \
  && setcap    cap_sys_chroot,cap_net_bind_service=+ep /usr/bin/unshare \
  && setcap -v cap_sys_chroot,cap_net_bind_service=+ep /usr/bin/unshare \
  && setcap    cap_net_bind_service=+ep /chroot/usr/local/nginx/sbin/nginx \
  && setcap -v cap_net_bind_service=+ep /chroot/usr/local/nginx/sbin/nginx \
  && setcap    cap_sys_chroot,cap_net_bind_service=+ep /usr/bin/dumb-init \
  && setcap -v cap_sys_chroot,cap_net_bind_service=+ep /usr/bin/dumb-init \
  && apk del libcap

RUN ln -sf /chroot/etc/nginx /etc/nginx \
  && ln -sf /chroot/tmp/nginx /tmp/nginx \
  && ln -sf /chroot/etc/ingress-controller /etc/ingress-controller \
  && ln -sf /chroot/var/log/nginx /var/log/nginx \
  && touch /chroot/var/log/nginx/access.log \
  && chown www-data:www-data /chroot/var/log/nginx/access.log \
  && echo "" > /chroot/etc/resolv.conf \
  && chown -R www-data:www-data /chroot/var/log/nginx /chroot/etc/resolv.conf \
  && mknod -m 0666 /chroot/dev/null c 1 3 \
  && mknod -m 0666 /chroot/dev/random c 1 8 \
  && mknod -m 0666 /chroot/dev/urandom c 1 9 \
  && mknod -m 0666 /chroot/dev/full c 1 7 \
  && mknod -m 0666 /chroot/dev/ptmx c 5 2 \
  && mknod -m 0666 /chroot/dev/zero c 1 5 \
  && mknod -m 0666 /chroot/dev/tty c 5 0

RUN mkdir -p /chroot/modules_mount \
  && mkdir -p modules_mount \
  && ln -s /modules_mount /chroot/modules_mount

USER www-data
EXPOSE 80 443
ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD ["/nginx-ingress-controller"]
