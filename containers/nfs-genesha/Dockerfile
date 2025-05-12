FROM fedora:41@sha256:e10efcce862bea890d8d2fe6eeeb78d7b67aa1301280bd7853b4184acf5ec148

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
