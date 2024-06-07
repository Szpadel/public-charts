FROM python:3.12-alpine@sha256:affa51de304bec8c2e87a9226b018110d4a1105d10bff30b655672deaf98e34d
RUN pip install requests
ADD delete_unused_images.py /usr/local/bin/
ENTRYPOINT [ "/usr/local/bin/delete_unused_images.py" ]
