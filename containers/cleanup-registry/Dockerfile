FROM python:3.12-alpine@sha256:26e68e6ae1714bccd7918f8e71548b40435325eb7a3b0508cd1e65b1d26a9b2c
RUN pip install requests
ADD delete_unused_images.py /usr/local/bin/
ENTRYPOINT [ "/usr/local/bin/delete_unused_images.py" ]
