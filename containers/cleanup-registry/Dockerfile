FROM python:3.12-alpine@sha256:dbc0126aa8ebdf637b224ca52eecc992bdc6b68c1017e9f0084748d50e6fc729
RUN pip install requests
ADD delete_unused_images.py /usr/local/bin/
ENTRYPOINT [ "/usr/local/bin/delete_unused_images.py" ]
