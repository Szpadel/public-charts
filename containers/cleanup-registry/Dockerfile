FROM python:3.12-alpine@sha256:a0c22d88d8a5738d8dbe0d4482783f6d39595182b02df694ca170c664afff2b7
RUN pip install requests
ADD delete_unused_images.py /usr/local/bin/
ENTRYPOINT [ "/usr/local/bin/delete_unused_images.py" ]
