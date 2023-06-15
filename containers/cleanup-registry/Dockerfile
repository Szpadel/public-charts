FROM python:3.11-alpine@sha256:0df84a640c9c91bc9b0c75fedd99c9784955e3a8a1978adbaf4ba904a937d63e
RUN pip install requests
ADD delete_unused_images.py /usr/local/bin/
ENTRYPOINT [ "/usr/local/bin/delete_unused_images.py" ]
