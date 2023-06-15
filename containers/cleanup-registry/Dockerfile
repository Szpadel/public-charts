FROM python:3.11-alpine@sha256:b6292f989265b13c1b64608f17021dcf93ea22ed768cf8590a0526083c656f5d
RUN pip install requests
ADD delete_unused_images.py /usr/local/bin/
ENTRYPOINT [ "/usr/local/bin/delete_unused_images.py" ]
