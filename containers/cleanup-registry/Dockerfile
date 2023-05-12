FROM python:3.11-alpine@sha256:2f2dadb583247fa176faf0a22800ce7a8b7a83cfee734c00315c4d68a55f4b68
RUN pip install requests
ADD delete_unused_images.py /usr/local/bin/
ENTRYPOINT [ "/usr/local/bin/delete_unused_images.py" ]
