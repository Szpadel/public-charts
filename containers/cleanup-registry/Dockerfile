FROM python:3.13-alpine@sha256:657dbdb20479a6523b46c06114c8fec7db448232f956a429d3cc0606d30c1b59
RUN pip install requests
ADD delete_unused_images.py /usr/local/bin/
ENTRYPOINT [ "/usr/local/bin/delete_unused_images.py" ]
