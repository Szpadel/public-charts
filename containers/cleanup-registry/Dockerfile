FROM python:3.12-alpine@sha256:7f15e22f496c65cffbbac5e30e7e98d60f3e3b9cc5ee5d51cf3c55ed604787c8
RUN pip install requests
ADD delete_unused_images.py /usr/local/bin/
ENTRYPOINT [ "/usr/local/bin/delete_unused_images.py" ]
