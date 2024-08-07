FROM python:3.12-alpine@sha256:d25c94a7862d8ded0c79c629fc56210001470e54d914ab2f161c18af0755eaae
RUN pip install requests
ADD delete_unused_images.py /usr/local/bin/
ENTRYPOINT [ "/usr/local/bin/delete_unused_images.py" ]
