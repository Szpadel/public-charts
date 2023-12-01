FROM python:3.12-alpine@sha256:46c18c627cdc193ef212a30075e9d27dbdbdbf70f60dcad4ca2b5aa0e82e3817
RUN pip install requests
ADD delete_unused_images.py /usr/local/bin/
ENTRYPOINT [ "/usr/local/bin/delete_unused_images.py" ]
