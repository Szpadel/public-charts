FROM fedora:41@sha256:3ec60eb34fa1a095c0c34dd37cead9fd38afb62612d43892fcf1d3425c32bc1e

RUN dnf install -y \
    nfs-ganesha \
    nfs-ganesha-vfs \
    dbus-daemon \
    rpcbind \
    nfs-utils \
    && dnf clean all

COPY nfsd.sh /usr/bin/nfsd.sh

RUN mkdir -p  /var/run/dbus &&\
    chmod +x /usr/bin/nfsd.sh

EXPOSE 2049 38465-38467 662 111/udp 111
ENTRYPOINT ["/usr/bin/nfsd.sh"]
