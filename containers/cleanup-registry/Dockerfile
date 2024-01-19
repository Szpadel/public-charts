FROM python:3.12-alpine@sha256:1d1a3d9593c14e3b43a51c53213e23bfcd51f43b12595ffa0872cc64bd6626fd
RUN pip install requests
ADD delete_unused_images.py /usr/local/bin/
ENTRYPOINT [ "/usr/local/bin/delete_unused_images.py" ]
