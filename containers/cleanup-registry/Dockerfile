FROM python:3.12-alpine@sha256:bf7c2a88f14163371be438fb13415ada036dd02667a6f48a9d0c4130fd2f699f
RUN pip install requests
ADD delete_unused_images.py /usr/local/bin/
ENTRYPOINT [ "/usr/local/bin/delete_unused_images.py" ]
