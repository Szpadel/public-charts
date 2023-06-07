FROM python:3.11-alpine@sha256:5112004fc9df018b0d31bbe89b92b2daf2cb690a3f66be715bfcaeb3496a3991
RUN pip install requests
ADD delete_unused_images.py /usr/local/bin/
ENTRYPOINT [ "/usr/local/bin/delete_unused_images.py" ]
