FROM python:3.12-alpine@sha256:8e53811601025c16fdf0e4d79ed33127652d2b8eef73c939e54b5a6e1fb54707
RUN pip install requests
ADD delete_unused_images.py /usr/local/bin/
ENTRYPOINT [ "/usr/local/bin/delete_unused_images.py" ]
