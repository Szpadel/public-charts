FROM python:3.12-alpine@sha256:849dcd222e0a95b1b83776fd1cd950e681b354e1748ec8dbc7d860f99401d5b7
RUN pip install requests
ADD delete_unused_images.py /usr/local/bin/
ENTRYPOINT [ "/usr/local/bin/delete_unused_images.py" ]
