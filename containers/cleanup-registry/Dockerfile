FROM python:3.12-alpine@sha256:d5e15ffab6bd0d3debed76fa3acf42c5ed2cf30f253c8b3a9bb7498d579040f4
RUN pip install requests
ADD delete_unused_images.py /usr/local/bin/
ENTRYPOINT [ "/usr/local/bin/delete_unused_images.py" ]
