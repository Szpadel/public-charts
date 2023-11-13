FROM python:3.12-alpine@sha256:a5d1738d6abbdff3e81c10b7f86923ebcb340ca536e21e8c5ee7d938d263dba1
RUN pip install requests
ADD delete_unused_images.py /usr/local/bin/
ENTRYPOINT [ "/usr/local/bin/delete_unused_images.py" ]
