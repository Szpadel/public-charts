FROM python:3.11-alpine@sha256:d33eab6e5ac9323e1af04dc1bc015fb11d0b8d83670aec2029058048dcdd4fa1
RUN pip install requests
ADD delete_unused_images.py /usr/local/bin/
ENTRYPOINT [ "/usr/local/bin/delete_unused_images.py" ]
