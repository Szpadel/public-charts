FROM python:3.11-alpine@sha256:adf851cf80f1f9f1b2d414019f378cbd1b7c52acc6aee1e69323b5d3b097b4d1
RUN pip install requests
ADD delete_unused_images.py /usr/local/bin/
ENTRYPOINT [ "/usr/local/bin/delete_unused_images.py" ]
