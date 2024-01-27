FROM python:3.12-alpine@sha256:a30c98e141ad55fa608cd1437c4f091f85a10bdd9bf51634d4cf6369325a2b5b
RUN pip install requests
ADD delete_unused_images.py /usr/local/bin/
ENTRYPOINT [ "/usr/local/bin/delete_unused_images.py" ]
