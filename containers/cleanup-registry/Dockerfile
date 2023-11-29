FROM python:3.12-alpine@sha256:c5bbde5ada8f427a1f2e2fb41f08077bfb4f1c779e82ab7e603a145275bec840
RUN pip install requests
ADD delete_unused_images.py /usr/local/bin/
ENTRYPOINT [ "/usr/local/bin/delete_unused_images.py" ]
