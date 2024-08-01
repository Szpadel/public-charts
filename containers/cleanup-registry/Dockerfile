FROM python:3.12-alpine@sha256:7b76f1c83e0a66bd4ad4a3562d5bbf133dfbd5b2069cba86a2a728f27b2a71bb
RUN pip install requests
ADD delete_unused_images.py /usr/local/bin/
ENTRYPOINT [ "/usr/local/bin/delete_unused_images.py" ]
