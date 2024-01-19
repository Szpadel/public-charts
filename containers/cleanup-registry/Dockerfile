FROM python:3.12-alpine@sha256:67990ec44e221e6ebb5dce61cf3a3ad5176b0b09871fd841e62e07f4a5b7e976
RUN pip install requests
ADD delete_unused_images.py /usr/local/bin/
ENTRYPOINT [ "/usr/local/bin/delete_unused_images.py" ]
