FROM python:3.12-alpine@sha256:d7a5a8bf92f2cf5c27852bbfb48d34721d15ce1c638cae1b6d45fdb76480285c
RUN pip install requests
ADD delete_unused_images.py /usr/local/bin/
ENTRYPOINT [ "/usr/local/bin/delete_unused_images.py" ]
