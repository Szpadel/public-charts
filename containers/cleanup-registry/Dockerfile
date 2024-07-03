FROM python:3.12-alpine@sha256:d16d0127032bddebc11d8f5731c30b3f5af76cac58d8a0cb970a8e66a3044d13
RUN pip install requests
ADD delete_unused_images.py /usr/local/bin/
ENTRYPOINT [ "/usr/local/bin/delete_unused_images.py" ]
