FROM python:3.12-alpine@sha256:1bf8e10904181a535546cb14980ca635fec33d944a097ce786f9fc34d6cff20c
RUN pip install requests
ADD delete_unused_images.py /usr/local/bin/
ENTRYPOINT [ "/usr/local/bin/delete_unused_images.py" ]
