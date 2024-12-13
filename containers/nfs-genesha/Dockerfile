FROM fedora:rawhide

RUN dnf install -y \
    nfs-ganesha \
    dbus-daemon \
    rpcbind \
    nfs-utils \
    && dnf clean all

COPY exports /etc/
COPY nfsd.sh /usr/bin/nfsd.sh

RUN mkdir -p  /var/run/dbus &&\
    chmod +x /usr/bin/nfsd.sh

EXPOSE 2049 38465-38467 662 111/udp 111
ENTRYPOINT ["/usr/bin/nfsd.sh"]
