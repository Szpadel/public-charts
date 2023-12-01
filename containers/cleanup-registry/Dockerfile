FROM python:3.12-alpine@sha256:3d2969ec27f0b38fc53ba7e4b6e01459a6f397f27649d82dc8e82631267bca0d
RUN pip install requests
ADD delete_unused_images.py /usr/local/bin/
ENTRYPOINT [ "/usr/local/bin/delete_unused_images.py" ]
