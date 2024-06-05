FROM python:3.12-alpine@sha256:42e1e4928ec21c0e70ad9a558ecdaac617d930e4e12c6f6e88b74886629e4d1c
RUN pip install requests
ADD delete_unused_images.py /usr/local/bin/
ENTRYPOINT [ "/usr/local/bin/delete_unused_images.py" ]
