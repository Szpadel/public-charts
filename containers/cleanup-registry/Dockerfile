FROM python:3.12-alpine@sha256:ae64ab05f92ea14bc9207a7a3165494c028cf3af735aea45f7c3d7137da1b14b
RUN pip install requests
ADD delete_unused_images.py /usr/local/bin/
ENTRYPOINT [ "/usr/local/bin/delete_unused_images.py" ]
