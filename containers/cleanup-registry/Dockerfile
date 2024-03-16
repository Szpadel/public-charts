FROM python:3.12-alpine@sha256:fa2fd94b02c2eacf55775c37fee40752275ac7710d0f7c8dc709ccc67917b332
RUN pip install requests
ADD delete_unused_images.py /usr/local/bin/
ENTRYPOINT [ "/usr/local/bin/delete_unused_images.py" ]
